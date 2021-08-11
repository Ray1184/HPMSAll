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

bool hpms::IntersectCircleLineSegment(const glm::vec2& origin, float radius, const glm::vec2& pointA, const glm::vec2& pointB)
{
    float baX = pointB.x - pointA.x;
    float baY = pointB.y - pointA.y;
    float caX = origin.x - pointA.x;
    float caY = origin.y - pointA.y;

    float a = baX * baX + baY * baY;
    float bBy2 = baX * caX + baY * caY;
    float c = caX * caX + caY * caY - radius * radius;

    float pBy2 = bBy2 / a;
    float q = c / a;

    float disc = pBy2 * pBy2 - q;
    return disc >= 0;
}

bool hpms::PointInsideCircle(const glm::vec2& point, const glm::vec2& t, float radius)
{
    return std::pow(point.x - t.x, 2) + std::pow(point.y - t.y, 2) < std::pow(radius, 2);
}

bool hpms::PointInsidePolygon(const glm::vec2& point, const glm::vec2& t, const std::vector<glm::vec2>& data)
{
    float x1, y1, x2, y2;
    size_t len = data.size();
    x2 = data[len].x + t.x;
    y2 = data[len].y + t.y;
    int wn = 0;
    for (size_t idx = 0; idx < len; idx++)
    {
        x1 = x2;
        y1 = y2;
        x2 = data[idx].x + t.x;
        y2 = data[idx].y + t.y;
        if (y1 > point.y)
        {
            if ((y2 <= point.y) && (x1 - point.x) * (y2 - point.y) < (x2 - point.x) * (y1 - point.y))
            {
                wn++;
            } else if ((y2 > point.y) && (x1 - point.x) * (y2 - point.y) > (x2 - point.x) * (y1 - point.y))
            {
                wn--;
            }
        }
    }
    return wn % 2 != 0;
}

