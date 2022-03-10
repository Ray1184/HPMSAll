/*!
 * File HPMSCollisor.cpp
 */

#include <logic/interaction/HPMSCollisor.h>
#include <glm/gtx/vector_angle.hpp>
#include <glm/gtx/euler_angles.hpp>
#include <glm/gtx/rotate_vector.hpp>

float hpms::Collisor::LookAt(const glm::vec3& to, float interpolateRatio)
{
	const double pi = std::atan(1.0) * 4;
	glm::vec3 newDir = to - GetPosition();
	glm::vec2 currDir2d = hpms::CalcDirection(actor->GetRotation(), VEC_FORWARD);
	glm::vec2 newDir2d = V3_TO_V2(newDir);
	float angle = glm::orientedAngle(hpms::SafeNormalize(currDir2d), hpms::SafeNormalize(newDir2d));
	glm::quat currRot = GetRotation();
	auto finalRot = glm::rotate(currRot, angle, VEC_UP);
	if (lookTarget != to)
	{
		lookTarget = to;
		cumulatedInterpolation = 0;
	}
	cumulatedInterpolation += interpolateRatio;
	if (cumulatedInterpolation >= 1)
	{
		cumulatedInterpolation = 1;
	}
	SetRotation(glm::slerp(GetRotation(), finalRot, cumulatedInterpolation));
	return angle;
	
}

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
	if (!GetConfig().active || !other->GetConfig().active || IsStopped())
	{
		ApplyHeight(&nextPosition, tpf);
		collisionState = NO_COLLISION(nextPosition, GetName());
		return;
	}

	glm::vec2 noTranslation(0, 0);

	CollisionResponse collisionResponse;
	hpms::CircleInteractPolygon(nextPosition, GetScaledBoundingRadius(), noTranslation, other->GetScaledBoundingRect(), OUTSIDE, &collisionResponse);
	
	bool noCollision = !collisionResponse.AnyCollision();
	if (noCollision)
	{
		ApplyHeight(&nextPosition, tpf);
		collisionState = NO_COLLISION(nextPosition, GetName());
		return;
	}

	// If previus step was a collision and object were nearest then current, keep current as good.
	CollisionResponse collisionResponseTestPrev;
	hpms::CircleInteractPolygon(GetPosition(), GetScaledBoundingRadius(), noTranslation, other->GetScaledBoundingRect(), OUTSIDE, &collisionResponseTestPrev);
	bool prevCollision = collisionResponseTestPrev.AnyCollision();
	float distOld = hpms::DistanceVec3(GetPosition(), other->GetPosition());
	float distNew = hpms::DistanceVec3(nextPosition, other->GetPosition());
	if (prevCollision && distNew >= distOld)
	{
		ApplyHeight(&nextPosition, tpf);
		collisionState = NO_COLLISION(nextPosition, GetName());
		return;
	}


	// Double check is required because of correct position result.
	// Infact after slide the new position could be outside of perimeter.

  	bool skipCorrection = false;
	glm::vec3 lastPos = actor->GetPosition();
	glm::vec3 correctPosition;
	bool insideAgain = CorrectAndRetryCollisor(collisionResponse.collisions[0], &correctPosition, other, tpf);
	if (!insideAgain && collisionResponse.collisions.size() >= 2)
	{

		if (!CorrectAndRetryCollisor(collisionResponse.collisions[1], &correctPosition, other, tpf))
		{
			skipCorrection = true;
		}
	}

	collisionState = COLLISOR_COLLISION(correctPosition, GetName(), other->GetName(), skipCorrection);

}

bool hpms::Collisor::CorrectAndRetryCollisor(const hpms::SingleCollisionResponse& singleCollision, glm::vec3* correctPosition, hpms::Collisor* collisor, float tpf)
{
	CorrectPositionBoundingRadiusMode(singleCollision.sidePointA, singleCollision.sidePointB, correctPosition);
	glm::vec3 correctPosition2 = *correctPosition;
	UP(correctPosition2) = UP(actor->GetPosition());
	*correctPosition = correctPosition2;
	hpms::CollisionResponse collisionResponse;
	glm::vec2 noTranslation(0, 0);
	hpms::CircleInteractPolygon(*correctPosition, GetScaledBoundingRadius(), noTranslation, collisor->GetScaledBoundingRect(), OUTSIDE, &collisionResponse);
	bool noCollision = !collisionResponse.AnyCollision();
	if (noCollision)
	{
		ApplyHeight(correctPosition, tpf);
		return true;
	}
	return false;
}

hpms::CollisionInfo hpms::Collisor::DetectByBoundingRadius(float tpf)
{
	if (!GetConfig().active || IsStopped())
	{
		ApplyHeight(&nextPosition, tpf);
		return NO_COLLISION(nextPosition, GetName());
	}
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
	bool insideAgain = CorrectAndRetryWalkmap(collisionResponse.collisions[0], &correctPosition, tpf);
	if (!insideAgain && collisionResponse.collisions.size() >= 2)
	{
		if (!CorrectAndRetryWalkmap(collisionResponse.collisions[1], &correctPosition, tpf))
		{
			skipCorrection = true;
		}
	}


	return WALKMAP_COLLISION(correctPosition, GetName(), skipCorrection);
}

bool hpms::Collisor::CorrectAndRetryWalkmap(const hpms::SingleCollisionResponse& singleCollision, glm::vec3* correctPosition, float tpf)
{
	CorrectPositionBoundingRadiusMode(singleCollision.sidePointA, singleCollision.sidePointB, correctPosition);
	glm::vec3 correctPosition2 = *correctPosition;
	UP(correctPosition2) = UP(actor->GetPosition());
	*correctPosition = correctPosition2;
	hpms::CollisionResponse collisionResponse;
	walkMap->Collides(*correctPosition, config.radius, &collisionResponse);
	bool inPerimeter = !collisionResponse.AnyCollision();
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

bool hpms::Collisor::IsStopped()
{
	auto lastPosition = actor->GetPosition();
	return lastPosition == nextPosition;
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



void hpms::Collisor::CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec3* correctPosition)
{
	glm::vec2 correctPosition2D;
	CorrectPositionBoundingRadiusMode(sideA, sideB, &correctPosition2D);
	*correctPosition = V2_TO_V3(correctPosition2D);
}

void hpms::Collisor::CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec2* correctPosition)
{
	glm::vec2 n = hpms::SafeNormalize(Perpendicular(sideA - sideB));
	glm::vec3 v = nextPosition - actor->GetPosition();
	glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
	glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
	*correctPosition = ADDV3_V2(actor->GetPosition(), vt);
}

bool hpms::Collisor::RayIntersect(const glm::vec3& dir, hpms::Collisor* target)
{
	for (size_t i = 0; i < GetScaledBoundingRect().size(); i++)
	{
		size_t index1 = i;
		size_t index2 = i < GetScaledBoundingRect().size() - 1 ? i : 0;
		float res = hpms::IntersectRayLineSegment(target->GetPosition(), dir, GetScaledBoundingRect()[index1], GetScaledBoundingRect()[index2]);
		if (res != -1)
		{
			return true;
		}
	}
	return false;
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

void hpms::Collisor::UpdateBounding()
{
	float angle = UP(glm::eulerAngles((GetRotation())));
	std::string angleS = "angle: " + std::to_string(angle);
	scaledRadius = config.radius * ((GetScale().x + GetScale().y + GetScale().z) / 3);
	glm::vec2 dim = config.rect * ((GetScale().x + GetScale().y + GetScale().z) / 3);

	scaledRect.clear();
	glm::vec2 v = glm::vec2(dim.x / 2, dim.y / 2);
	glm::vec2 v1 = glm::vec2(GetPosition().x - v.x, GetPosition().y - v.y);
	glm::vec2 v2 = glm::vec2(GetPosition().x + v.x, GetPosition().y - v.y);
	glm::vec2 v3 = glm::vec2(GetPosition().x + v.x, GetPosition().y + v.y);
	glm::vec2 v4 = glm::vec2(GetPosition().x - v.x, GetPosition().y + v.y);
	glm::vec2 v5 = glm::vec2(GetPosition().x - v.x, GetPosition().y - v.y);

	scaledRect.push_back(hpms::RotateVec2(v1, angle, V3_TO_V2(GetPosition())));
	scaledRect.push_back(hpms::RotateVec2(v2, angle, V3_TO_V2(GetPosition())));
	scaledRect.push_back(hpms::RotateVec2(v3, angle, V3_TO_V2(GetPosition())));
	scaledRect.push_back(hpms::RotateVec2(v4, angle, V3_TO_V2(GetPosition())));
	scaledRect.push_back(hpms::RotateVec2(v5, angle, V3_TO_V2(GetPosition())));


}


hpms::Collisor::Collisor(hpms::ActorAdapter* actor, hpms::WalkmapAdapter* walkMap, const CollisorConfig& config) : actor(actor),
walkMap(walkMap),
config(config),
ignore(false),
outOfDate(true),
cumulatedInterpolation(0),
baseHeightDefined(false),
collisionState(CollisionInfo{})
{	
	auto checkPerimeter = [&](const glm::vec2& sideAPos, const glm::vec2& sideBPos)
	{
		perimeter.push_back(sideAPos);
		return false;
	};
	walkMap->ForEachSide(checkPerimeter);

	// Calc bounding radius/rect.
	UpdateBounding();

}

hpms::Collisor::~Collisor()
{

}