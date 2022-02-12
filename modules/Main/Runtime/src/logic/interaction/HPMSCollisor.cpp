/*!
 * File HPMSCollisor.cpp
 */

#include <logic/interaction/HPMSCollisor.h>
#include <glm/gtx/vector_angle.hpp>

void hpms::Collisor::Sample(float tpf)
{
	currentTriangle = walkMap->SampleTriangle(nextPosition, config.radius);
}

void hpms::Collisor::CollidesWalkmap(float tpf)
{
	collisionState = DetectByBoundingRadius(tpf);
}

void hpms::Collisor::CollidesCollisor(float tpf, Collisor* other)
{
	if (config.rect.x == 0 || config.rect.y == 0) {
		// Manage target as bounding radius.
		float dist = glm::distance(nextPosition, other->nextPosition);
		if (dist <= config.radius + other->GetConfig().radius)
		{
			//SetPosition(lastPosition);
			collisionState = COLLISOR_COLLISION(GetPosition(), GetName(), other->GetName(), true);
		}
	}
	else
	{
		// Manage target as bounding rect.
		// TODO
		collisionState = NO_COLLISION(nextPosition, GetName());
	}
}

hpms::CollisionInfo hpms::Collisor::DetectByBoundingRadius(float tpf)
{
	CollisionResponse collisionResponse;
	walkMap->Collides(nextPosition, config.radius, &collisionResponse);
	bool inPerimeter = !collisionResponse.AnyCollision();
	if (inPerimeter)
	{
		ApplyHeight(&nextPosition, tpf);
		return NO_COLLISION(nextPosition, GetName());
	}
	// Double check is required because of correct position result.
	// Infact after slide the new position could be outside of perimeter.
	bool skipCorrection = false;
	glm::vec3 correctPosition;
	bool insideAgain = CorrectAndRetry(collisionResponse.collisions[0], nextPosition, &correctPosition, tpf);
	if (!insideAgain && collisionResponse.collisions.size() >= 2)
	{
		if (!CorrectAndRetry(collisionResponse.collisions[1], nextPosition, &correctPosition, tpf))
		{
			skipCorrection = true;
		}
	}

	
	return WALKMAP_COLLISION(correctPosition, GetName(), skipCorrection);
}

bool hpms::Collisor::CorrectAndRetry(const hpms::SingleCollisionResponse& singleCollision, const glm::vec3& nextPosition, glm::vec3* correctPosition, float tpf)
{	
	CorrectPositionBoundingRadiusMode(singleCollision.sidePointA, singleCollision.sidePointB, correctPosition);
	glm::vec3 correctPosition2 = *correctPosition;
	UP(correctPosition2) = UP(actor->GetPosition());
	*correctPosition = correctPosition2;
	hpms::CollisionResponse collisionResponse;
	walkMap->Collides(*correctPosition, config.radius, &collisionResponse);
	float inPerimeter = !collisionResponse.AnyCollision();
	if (inPerimeter)
	{
		ApplyHeight(correctPosition, tpf);
		return true;
	}
	return false;
}

void hpms::Collisor::ApplyHeight(glm::vec3* nextPos, float tpf)
{

	if (!baseHeightDefined)
	{
		baseHeightDefined = true;
		baseHeight = GetHeightInMap() - UP(actor->GetPosition());
	}
	else
	{
		if (currentTriangle == nullptr)
		{
			return;
		}
		float fixedHeight = baseHeight + GetHeightInMap();
		glm::vec3 fixedPosition = *nextPos;
		UP(fixedPosition) = fixedHeight;
		*nextPos = fixedPosition;

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
//	auto* nextTriangle = walkMap->SampleTriangle(nextPosition, config.radius);
//
//	if (nextTriangle)
//	{
//		// No collision, go to next triangle.
//		actor->SetPosition(nextPosition);
//		currentTriangle = nextTriangle;
//		return;
//	}
//	else
//	{
//		// No sampling.
//		if (currentTriangle == nullptr)
//		{
//			return;
//		}
//
//		// Check potential collisions.
//		for (auto* side : currentTriangle->GetPerimetralSides())
//		{
//			std::pair<glm::vec2, glm::vec2> sidePair = walkMap->GetSideCoordsFromTriangle(currentTriangle, side);
//			float t = IntersectRayLineSegment(actor->GetPosition(), direction, sidePair.first, sidePair.second);
//			// Correct side.
//			if (t > -1)
//			{
//				CorrectPositionSectorMode(sidePair.first, sidePair.second, true);
//				return;
//			}
//		}
//	}
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
//	glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
//	glm::vec3 v = nextPosition - actor->GetPosition();
//	glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
//	glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
//	glm::vec3 correctPosition = ADDV3_V2(actor->GetPosition(), vt);
//
//	if (resampleTriangle)
//	{
//
//		auto* correctTriangle = walkMap->SampleTriangle(correctPosition, config.radius);
//
//		if (correctTriangle != nullptr)
//		{
//			// Calculated position is good, move actor to calculated position.
//			actor->SetPosition(correctPosition);
//
//			// Assign for safe, but correctTriangle should be the original.
//			currentTriangle = correctTriangle;
//		}
//	}
//	else
//	{
//		actor->SetPosition(correctPosition);
//	}
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

std::string hpms::Collisor::GetName() const
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

hpms::Collisor::Collisor(hpms::ActorAdapter* actor, hpms::WalkmapAdapter* walkMap, const CollisorConfig& config) : actor(actor),
walkMap(walkMap),
config(config),
ignore(false),
outOfDate(true),
baseHeightDefined(false),
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