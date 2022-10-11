/*!
 * File HPMSMathUtils.h
 */

#pragma once

#include <glm/glm.hpp>
#include <glm/ext.hpp>
#include <common/HPMSCoordSystem.h>
#include <common/HPMSUtils.h>
#include <cmath>
#include <vector>

#define HPMS_EPSILON 0.0001f
#define CCW(A, B, C) ((C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x))

namespace hpms
{

	inline bool FloatEquals(float f1, float f2)
	{
		return std::fabs(f1 - f2) < HPMS_EPSILON;
	}

	inline glm::vec2 RotateVec2(const glm::vec2& in, float angle, const glm::vec2& t)
	{
		glm::vec2 v = glm::vec2(in.x - t.x, in.y - t.y);
		float x = v.x * std::cos(angle) - v.y * std::sin(angle);
		float y = v.x * std::sin(angle) + v.y * std::cos(angle);
		return glm::vec2(x + t.x, y + t.y);
	}

	inline glm::vec4 SafeNormalize(const glm::vec4& v)
	{
		if (v.x == 0.0f && v.y == 0.0f && v.z == 0.0f && v.w == 0.0f)
		{
			return v;
		}
		return glm::normalize(v);
	}

	inline glm::vec3 SafeNormalize(const glm::vec3& v)
	{
		if (v.x == 0.0f && v.y == 0.0f && v.z == 0.0f)
		{
			return v;
		}
		return glm::normalize(v);
	}

	inline glm::vec2 SafeNormalize(const glm::vec2& v)
	{
		if (v.x == 0.0f && v.y == 0.0f)
		{
			return v;
		}
		return glm::normalize(v);
	}

	struct SingleCollisionResponse
	{
		bool collided;
		glm::vec2 sidePointA;
		glm::vec2 sidePointB;

		inline void CopyFrom(const SingleCollisionResponse& copy)
		{
			SingleCollisionResponse::collided = copy.collided;
			SingleCollisionResponse::sidePointA = copy.sidePointA;
			SingleCollisionResponse::sidePointB = copy.sidePointB;
		}

		inline bool Equals(const SingleCollisionResponse& copy)
		{
			return FloatEquals(SingleCollisionResponse::sidePointA.x, copy.sidePointA.x) &&
				FloatEquals(SingleCollisionResponse::sidePointA.y, copy.sidePointA.y) &&
				FloatEquals(SingleCollisionResponse::sidePointB.x, copy.sidePointB.x) &&
				FloatEquals(SingleCollisionResponse::sidePointB.y, copy.sidePointB.y);
		}
	};

	struct CollisionResponse
	{
		std::vector<SingleCollisionResponse> collisions;
		inline bool AnyCollision()
		{
			for (const auto& coll : collisions)
			{
				if (coll.collided)
				{
					return true;
				}
			}
			return false;
		}
	};

	enum SideMode
	{
		INSIDE,
		OUTSIDE
	};

	struct IntersectInfo
	{
		bool intersect{ false };
		glm::vec2 intersectionPoint;
	};

	float
		IntersectRayLineSegment(float originX, float originY, float dirX, float dirY, float aX, float aY, float bX,
			float bY);

	inline float
		IntersectRayLineSegment(const glm::vec3& origin, const glm::vec2& dir, const glm::vec2& a, const glm::vec2& b)
	{
		return IntersectRayLineSegment(SD(origin), FW(origin), dir.x, dir.y, a.x, a.y, b.x, b.y);
	}

	bool CircleLineIntersect(const glm::vec2& pointA, const glm::vec2& pointB, const glm::vec2& origin, float radius);

	inline bool
		IntersectCircleLineSegment(const glm::vec3& pointA, const glm::vec3& pointB, const glm::vec3& origin, float radius)
	{
		auto origin2d = glm::vec2(SD(origin), FW(origin));
		auto pointA2d = glm::vec2(SD(pointA), FW(pointA));
		auto pointB2d = glm::vec2(SD(pointB), FW(pointB));
		return CircleLineIntersect(pointA2d, pointB2d, origin2d, radius);
	}

	inline bool
		IntersectCircleLineSegment(const glm::vec2& pointA, const glm::vec2& pointB, const glm::vec3& origin, float radius)
	{
		auto origin2d = glm::vec2(SD(origin), FW(origin));
		return CircleLineIntersect(pointA, pointB, origin2d, radius);
	}

	inline glm::vec2 Perpendicular(const glm::vec2& origin)
	{
		return { FW(origin), -SD(origin) };
	}

	inline glm::vec3 CalcDirection(const glm::quat& rot, const glm::vec3& forward)
	{
		glm::mat3 rotMat = glm::mat3_cast(rot);
		glm::vec3 dir = rotMat * forward;
		return hpms::SafeNormalize(dir);
	}

	bool PointInsideCircle(const glm::vec2& point, const glm::vec2& data, float radius);

	bool PointInsidePolygon(const glm::vec2& point, const glm::vec2& t, const std::vector<glm::vec2>& polygon);

	void CircleInteractPolygon(const glm::vec2& point, float radius, const glm::vec2& t, const std::vector<glm::vec2>& polygon, SideMode sideMode, CollisionResponse* response);

	bool IsBetween(const glm::vec2& pt1, const glm::vec2& pt2, const glm::vec2& pt);

	float CalcHeightOf2DPointInside3DSector(float fw1, float fw2, float fw3, float sd1, float sd2,
		float sd3, float up1, float up2, float up3, const glm::vec2& pos);

	inline glm::vec2 MultVec2Mat4(const glm::vec2& v, const glm::mat4& m)
	{
		return glm::vec2(m[0][0] * v.x + m[1][0] * v.y + m[3][0], m[0][1] * v.x + m[1][1] * v.y + m[3][1]);
	}

	inline float DistanceVec3(const glm::vec3& v1, const glm::vec3& v2)
	{
		return std::sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + pow(v2.z - v1.z, 2));
	}

	inline float DistanceVec2(const glm::vec2& v1, const glm::vec2& v2)
	{
		return std::sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2));
	}

	inline void IntersectBetweenVectors(const glm::vec2& start1, const glm::vec2& end1, const glm::vec2& start2, const glm::vec2& end2, IntersectInfo* intersectInfo)
	{
		float a1 = end1.y - start1.y;
		float b1 = start1.x - end1.x;
		float c1 = a1 * start1.x + b1 * start1.y;
		
		float a2 = end2.y - start2.y;
		float b2 = start2.x - end2.x;
		float c2 = a2 * start2.x + b2 * start2.y;

		float det = a1 * b2 - a2 * b1;
		if (det == 0) 
		{
			return;
		}

		float x = (b2 * c1 - b1 * c2) / det;
		float y = (a1 * c2 - a2 * c1) / det;

		intersectInfo->intersect = true;
		intersectInfo->intersectionPoint = glm::vec2(x, y);
	}

}
