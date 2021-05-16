/*!
 * File HPMSMathUtils.h
 */

#pragma once

#include <glm/glm.hpp>
#include <glm/ext.hpp>
#include <common/HPMSCoordSystem.h>

namespace hpms {
    float
    IntersectRayLineSegment(float originX, float originY, float dirX, float dirY, float aX, float aY, float bX,
                            float bY);


    inline float
    IntersectRayLineSegment(const glm::vec3& origin, const glm::vec2& dir, const glm::vec2& a, const glm::vec2& b)
    {
        return IntersectRayLineSegment(SD(origin), FW(origin), dir.x, dir.y, a.x, a.y, b.x, b.y);
    }

    inline glm::vec2 Perpendicular(const glm::vec2 origin)
    {
        return {FW(origin), -SD(origin)};
    }


    inline glm::vec3 CalcDirection(const glm::quat& rot, const glm::vec3& forward)
    {
        glm::mat3 rotMat = glm::mat3_cast(rot);
        glm::vec3 dir = rotMat * forward;
        return glm::normalize(dir);
    }
}
