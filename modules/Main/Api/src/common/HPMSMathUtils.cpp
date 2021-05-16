/*!
 * File HPMSMathUtils.cpp
 */



#include <common/HPMSMathUtils.h>

float hpms::IntersectRayLineSegment(float originX, float originY, float dirX, float dirY, float aX, float aY, float bX,
                                    float bY)
{
    float v1X = originX - aX;
    float v1Y = originY - aY;
    float v2X = bX - aX;
    float v2Y = bY - aY;
    float invV23 = 1.0f / (v2Y * dirX - v2X * dirY);
    float t1 = (v2X * v1Y - v2Y * v1X) * invV23;
    float t2 = (v1Y * dirX - v1X * dirY) * invV23;
    if (t1 >= 0.0f && t2 >= 0.0f && t2 <= 1.0f)
    {
        return t1;
    }
    return -1.0f;
}
