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

bool hpms::IntersectCircleLineSegment(const glm::vec2& origin, float radius, glm::vec2& pointA, glm::vec2& pointB)
{
    double baX = pointB.x - pointA.x;
    double baY = pointB.y - pointA.y;
    double caX = origin.x - pointA.x;
    double caY = origin.y - pointA.y;

    double a = baX * baX + baY * baY;
    double bBy2 = baX * caX + baY * caY;
    double c = caX * caX + caY * caY - radius * radius;

    double pBy2 = bBy2 / a;
    double q = c / a;

    double disc = pBy2 * pBy2 - q;
    return disc >= 0;
}
