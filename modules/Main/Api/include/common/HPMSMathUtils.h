/*!
 * File HPMSMathUtils.h
 */

#pragma once

#include <glm/glm.hpp>
#include <glm/ext.hpp>
#include <common/HPMSCoordSystem.h>
#include <cmath>
#include <vector>

namespace hpms
{


    float
    IntersectRayLineSegment(float originX, float originY, float dirX, float dirY, float aX, float aY, float bX,
                            float bY);


    inline float
    IntersectRayLineSegment(const glm::vec3& origin, const glm::vec2& dir, const glm::vec2& a, const glm::vec2& b)
    {
        return IntersectRayLineSegment(SD(origin), FW(origin), dir.x, dir.y, a.x, a.y, b.x, b.y);
    }

    bool IntersectCircleLineSegment(const glm::vec2& origin, float radius, const glm::vec2& pointA, const glm::vec2& pointB);

    inline bool
    IntersectCircleLineSegment(const glm::vec3& origin, float radius, const glm::vec3& pointA, const glm::vec3& pointB)
    {
        auto origin2d = glm::vec2(SD(origin), FW(origin));
        auto pointA2d = glm::vec2(SD(pointA), FW(pointA));
        auto pointB2d = glm::vec2(SD(pointB), FW(pointB));
        return IntersectCircleLineSegment(origin2d, radius, pointA2d, pointB2d);
    }

    inline bool
    IntersectCircleLineSegment(const glm::vec3& origin, float radius, const glm::vec2& pointA, const glm::vec2& pointB)
    {
        auto origin2d = glm::vec2(SD(origin), FW(origin));
        return IntersectCircleLineSegment(origin2d, radius, pointA, pointB);
    }

    inline glm::vec2 Perpendicular(const glm::vec2& origin)
    {
        return {FW(origin), -SD(origin)};
    }


    inline glm::vec3 CalcDirection(const glm::quat& rot, const glm::vec3& forward)
    {
        glm::mat3 rotMat = glm::mat3_cast(rot);
        glm::vec3 dir = rotMat * forward;
        return glm::normalize(dir);
    }

    bool PointInsideCircle(const glm::vec2& point, const glm::vec2& data, float radius);

    bool PointInsidePolygon(const glm::vec2& point, const glm::vec2& t, const std::vector<glm::vec2>& data);

}
