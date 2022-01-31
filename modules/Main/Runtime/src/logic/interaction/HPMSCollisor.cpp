/*!
 * File HPMSCollisor.cpp
 */

#include <logic/interaction/HPMSCollisor.h>
#include <glm/gtx/vector_angle.hpp>

#define NO_COLLISION hpms::CollisionInfo{ false, hpms::ZERO_COLLISION, nullptr };
#define WALKMAP_COLLISION hpms::CollisionInfo{ true, hpms::VS_WALKMAP, nullptr };
#define COLLISOR_COLLISION(coll) hpms::CollisionInfo{ true, hpms::VS_COLLISOR, coll };

void hpms::Collisor::Update(float tpf)
{
	if (!active || !outOfDate)
	{
		collisionState = NO_COLLISION;
		return;
	}

	outOfDate = false;
	currentTriangle = walkMap->SampleTriangle(nextPosition, tolerance);

	collisionState = DetectByBoundingRadius(tpf);
}

hpms::CollisionInfo hpms::Collisor::DetectByBoundingRadius(float tpf)
{
	CollisionResponse collisionResponse;
	walkMap->Collides(nextPosition, tolerance, &collisionResponse);
	bool inPerimeter = !collisionResponse.AnyCollision();
	if (inPerimeter)
	{
		ApplyGravity(nextPosition, tpf);
		return NO_COLLISION;
	}
	// Double check is required because of correct position result.
	// Infact after slide the new position could be outside of perimeter.
	glm::vec3 correctPosition;
	bool insideAgain = CorrectAndRetry(collisionResponse.collisions[0], nextPosition, tpf);
	if (!insideAgain && collisionResponse.collisions.size() >= 2)
	{
		CorrectAndRetry(collisionResponse.collisions[1], nextPosition, tpf);
	}
	
	return WALKMAP_COLLISION;
}

bool hpms::Collisor::CorrectAndRetry(const hpms::SingleCollisionResponse& singleCollision, const glm::vec3& nextPosition, float tpf)
{
	glm::vec3 correctPosition;
	CorrectPositionBoundingRadiusMode(singleCollision.sidePointA, singleCollision.sidePointB, &correctPosition);
	UP(correctPosition) = UP(actor->GetPosition());	
	hpms::CollisionResponse collisionResponse;
	walkMap->Collides(correctPosition, tolerance, &collisionResponse);
	float inPerimeter = !collisionResponse.AnyCollision();
	if (inPerimeter)
	{
		ApplyGravity(correctPosition, tpf);
		return true;
	}
	return false;
}

void hpms::Collisor::ApplyGravity(const glm::vec3& nextPos, float tpf)
{

	if (!baseHeightDefined)
	{
		baseHeightDefined = true;
		baseHeight = GetHeightInMap() - UP(actor->GetPosition());
		actor->SetPosition(nextPos);
	}
	else
	{
		if (currentTriangle == nullptr)
		{
			return;
		}
		float fixedHeight = baseHeight + GetHeightInMap();
		glm::vec3 fixedPosition = nextPos;
		UP(fixedPosition) = fixedHeight;
		if (UP(fixedPosition) - UP(nextPos) < config.maxStepHeight)
		{
			actor->SetPosition(fixedPosition);
		}
		if (UP(nextPos) - UP(fixedPosition) > config.maxStepHeight)
		{
			currentVerticalSpeed += config.gravityAffection * tpf;
			float posWithFallDown = UP(nextPos) - currentVerticalSpeed;
			if (UP(fixedPosition) < posWithFallDown)
			{
				UP(fixedPosition) = posWithFallDown;
			}
			actor->SetPosition(fixedPosition);

		}
		else
		{
			currentVerticalSpeed = 0;
		}

	}
}



float hpms::Collisor::GetHeightInMap()
{
	if (currentTriangle == nullptr)
	{
		return 0.0f;
	}
	return hpms::CalcHeightOf2DPointInside3DSector(currentTriangle->TO_FW1(), currentTriangle->TO_FW2(), currentTriangle->TO_FW3(),
		currentTriangle->TO_SD1(), currentTriangle->TO_SD2(), currentTriangle->TO_SD3(),
		currentTriangle->TO_UP1(), currentTriangle->TO_UP2(), currentTriangle->TO_UP3(), actor->GetPosition());
}

// UNUSED
void hpms::Collisor::DetectBySector()
{
	auto* nextTriangle = walkMap->SampleTriangle(nextPosition, tolerance);

	if (nextTriangle)
	{
		// No collision, go to next triangle.
		actor->SetPosition(nextPosition);
		currentTriangle = nextTriangle;
		return;
	}
	else
	{
		// No sampling.
		if (currentTriangle == nullptr)
		{
			return;
		}

		// Check potential collisions.
		for (auto* side : currentTriangle->GetPerimetralSides())
		{
			std::pair<glm::vec2, glm::vec2> sidePair = walkMap->GetSideCoordsFromTriangle(currentTriangle, side);
			float t = IntersectRayLineSegment(actor->GetPosition(), direction, sidePair.first, sidePair.second);
			// Correct side.
			if (t > -1)
			{
				CorrectPositionSectorMode(sidePair.first, sidePair.second, true);
				return;
			}
		}
	}
}

void hpms::Collisor::CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec3* correctPosition)
{
	glm::vec2 correctPosition2D;
	CorrectPositionBoundingRadiusMode(sideA, sideB, &correctPosition2D);
	*correctPosition = V2_TO_V3(correctPosition2D);
}

void hpms::Collisor::CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec2* correctPosition)
{
	glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
	glm::vec3 v = nextPosition - actor->GetPosition();
	glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
	glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
	*correctPosition = ADDV3_V2(actor->GetPosition(), vt);
}

void hpms::Collisor::CorrectPositionSectorMode(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle)
{
	glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
	glm::vec3 v = nextPosition - actor->GetPosition();
	glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
	glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
	glm::vec3 correctPosition = ADDV3_V2(actor->GetPosition(), vt);

	if (resampleTriangle)
	{

		auto* correctTriangle = walkMap->SampleTriangle(correctPosition, tolerance);

		if (correctTriangle != nullptr)
		{
			// Calculated position is good, move actor to calculated position.
			actor->SetPosition(correctPosition);

			// Assign for safe, but correctTriangle should be the original.
			currentTriangle = correctTriangle;
		}
	}
	else
	{
		actor->SetPosition(correctPosition);
	}
}

void hpms::Collisor::Move(const glm::vec3& nextPosition, const glm::vec2 direction)
{
	if (Collisor::nextPosition != nextPosition)
	{
		outOfDate = true;
	}
	Collisor::nextPosition = nextPosition;
	Collisor::direction = direction;
}

std::string hpms::Collisor::GetName()
{
	return actor->GetName();
}

glm::vec3 hpms::Collisor::GetPosition() const
{
	return actor->GetPosition();
}

glm::quat hpms::Collisor::GetRotation() const
{
	return actor->GetRotation();
}

glm::vec3 hpms::Collisor::GetScale() const
{
	return actor->GetScale();
}

void hpms::Collisor::SetVisible(bool visible)
{
}

bool hpms::Collisor::IsVisible() const
{
	return false;
}

const std::string hpms::Collisor::Name() const
{
	return "Collisor";
}

void hpms::Collisor::SetScale(const glm::vec3& scale)
{
	actor->SetScale(scale);
}

void hpms::Collisor::SetRotation(const glm::quat& rotation)
{
	actor->SetRotation(rotation);
}

void hpms::Collisor::SetPosition(const glm::vec3& position)
{
	glm::vec3 dir3 = hpms::CalcDirection(actor->GetRotation(), VEC_FORWARD);
	glm::vec2 dir2(dir3.x, dir3.z);
	Move(position, dir2);
}

hpms::Collisor::Collisor(hpms::ActorAdapter* actor, hpms::WalkmapAdapter* walkMap, float tolerance, const CollisorConfig& config) : actor(actor),
walkMap(walkMap),
tolerance(tolerance),
config(config),
ignore(false),
outOfDate(true),
baseHeightDefined(false),
currentVerticalSpeed(0.0f),
collisionState(CollisionInfo{})
{

	auto checkPerimeter = [&](const glm::vec2& sideAPos, const glm::vec2& sideBPos)
	{
		perimeter.push_back(sideAPos);
		return false;
	};
	walkMap->ForEachSide(checkPerimeter);
}

hpms::Collisor::~Collisor()
{
	
}