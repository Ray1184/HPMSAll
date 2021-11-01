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

bool hpms::CircleLineIntersect(const glm::vec2 &pointA, const glm::vec2 &pointB, const glm::vec2 &origin, float radius)
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
    if (disc < 0)
    {
        return false;
    }
    float tmpSqrt = std::sqrt(disc);
    float abScalingFactor = -pBy2 + tmpSqrt;
    glm::vec2 pointC = glm::vec2(pointA.x - baX * abScalingFactor, pointA.y - baY * abScalingFactor);
    return IsBetween(pointA, pointB, pointC);
}

bool hpms::IsBetween(const glm::vec2 &pt1, const glm::vec2 &pt2, const glm::vec2 &pt)
{
    const float epsilon = 0.001f;

    if (pt.x - std::max(pt1.x, pt2.x) > epsilon ||
        std::min(pt1.x, pt2.x) - pt.x > epsilon ||
        pt.y - std::max(pt1.y, pt2.y) > epsilon ||
        std::min(pt1.y, pt2.y) - pt.y > epsilon)
        return false;

    if (std::abs(pt2.x - pt1.x) < epsilon)
        return std::abs(pt1.x - pt.x) < epsilon || std::abs(pt2.x - pt.x) < epsilon;
    if (std::abs(pt2.y - pt1.y) < epsilon)
        return std::abs(pt1.y - pt.y) < epsilon || std::abs(pt2.y - pt.y) < epsilon;

    float x = pt1.x + (pt.y - pt1.y) * (pt2.x - pt1.x) / (pt2.y - pt1.y);
    float y = pt1.y + (pt.x - pt1.x) * (pt2.y - pt1.y) / (pt2.x - pt1.x);

    return std::abs(pt.x - x) < epsilon || std::abs(pt.y - y) < epsilon;
}

bool hpms::PointInsideCircle(const glm::vec2 &point, const glm::vec2 &t, float radius)
{
    return std::pow(point.x - t.x, 2) + std::pow(point.y - t.y, 2) < std::pow(radius, 2);
}

bool hpms::PointInsidePolygon(const glm::vec2 &point, const glm::vec2 &t, const std::vector<glm::vec2> &polygon)
{

    float x = point.x - t.x;
    float y = point.y - t.y;
    unsigned int j = polygon.size() - 1;
    bool oddNodes = false;

    for (unsigned int i = 0; i < polygon.size(); i++)
    {
        if ((polygon[i].y + t.y < y && polygon[j].y + t.y >= y || polygon[j].y + t.y < y && polygon[i].y + t.y >= y) && (polygon[i].x + t.x <= x || polygon[j].x + t.x <= x))
        {
            oddNodes ^= (polygon[i].x + t.x + (y - polygon[i].y + t.y) / (polygon[j].y + t.y - polygon[i].y + t.y) * (polygon[j].x + t.x - polygon[i].x + t.x) < x);
        }
        j = i;
    }

    return oddNodes;
}

void hpms::CircleInteractPolygon(const glm::vec2 &point, float radius, const glm::vec2 &t, const std::vector<glm::vec2> &polygon, SideMode sideMode, CollisionResponse *response)
{
    response->collided = false;
    bool inside = PointInsidePolygon(point, t, polygon);

    if ((!inside && sideMode == INSIDE) || (inside && sideMode == OUTSIDE))
    {
        return;
    }

    for (int i = 0; i < polygon.size() - 1; i++)
    {
        glm::vec2 translatedCenter = point + t;
        if (CircleLineIntersect(polygon[i], polygon[i + 1], translatedCenter, radius))
        {
            response->collided = true;
            response->sidePointA = polygon[i];
            response->sidePointB = polygon[i + 1];
            return;
        }
    }
}
