/*!
 * File HPMSCalcUtils.cpp
 */

#include <utils/HPMSCalcUtils.h>

bool hpms::Is2DPointInside3DSector(const hpms::Triangle& sec, const glm::vec2& pos, float tolerance)
{
    float dX = pos.x - sec.SD3;
    float dY = pos.y - sec.FW3;
    float dX21 = sec.SD3 - sec.SD2;
    float dY12 = sec.FW2 - sec.FW3;
    float d = dY12 * (sec.SD1 - sec.SD3) + dX21 * (sec.FW1 - sec.FW3);
    float s = dY12 * dX + dX21 * dY;
    float t = (sec.FW3 - sec.FW1) * dX + (sec.SD1 - sec.SD3) * dY;
    bool inside;
    if (d < 0)
    {
        inside = s <= 0 && t <= 0 && s + t >= d;
    } else
    {
        inside = s >= 0 && t >= 0 && s + t <= d;
    }
    return inside;
}

bool hpms::TestSidesOverlap(const hpms::Triangle& t, const hpms::Triangle& o, unsigned int side)
{
    switch (side)
    {
        case 0:
            return (t.x1 == o.x2 && t.z1 == o.z2 && t.y1 == o.y2 && t.x2 == o.x1 && t.z2 == o.z1 && t.y2 == o.y1) ||
                   (t.x1 == o.x1 && t.z1 == o.z1 && t.y1 == o.y1 && t.x2 == o.x3 && t.z2 == o.z3 && t.y2 == o.y3) ||
                   (t.x1 == o.x3 && t.z1 == o.z3 && t.y1 == o.y3 && t.x2 == o.x2 && t.z2 == o.z2 && t.y2 == o.y2);
        case 1:
            return (t.x2 == o.x2 && t.z2 == o.z2 && t.y2 == o.y2 && t.x3 == o.x1 && t.z3 == o.z1 && t.y3 == o.y1) ||
                   (t.x2 == o.x1 && t.z2 == o.z1 && t.y2 == o.y1 && t.x3 == o.x3 && t.z3 == o.z3 && t.y3 == o.y3) ||
                   (t.x2 == o.x3 && t.z2 == o.z3 && t.y2 == o.y2 && t.x3 == o.x2 && t.z3 == o.z2 && t.y3 == o.y2);
        case 2:
            return (t.x3 == o.x2 && t.z3 == o.z2 && t.y3 == o.y2 && t.x1 == o.x1 && t.z1 == o.z1 && t.y1 == o.y1) ||
                   (t.x3 == o.x1 && t.z3 == o.z1 && t.y3 == o.y1 && t.x1 == o.x3 && t.z1 == o.z3 && t.y1 == o.y3) ||
                   (t.x3 == o.x3 && t.z3 == o.z3 && t.y3 == o.y3 && t.x1 == o.x2 && t.z1 == o.z2 && t.y1 == o.y2);
        default:
            return false;
    }
}

std::vector<hpms::Side>
hpms::CalculatePerimetralSides(const hpms::Triangle& t, const std::vector<hpms::Triangle>& triangles)
{
    std::vector<hpms::Side> sides;

    bool check12 = false;
    bool check23 = false;
    bool check31 = false;

    for (const auto& o : triangles)
    {
        if (o == t)
        {
            continue;
        }
        check12 = check12 || TestSidesOverlap(t, o, 0);
        check23 = check23 || TestSidesOverlap(t, o, 1);
        check31 = check31 || TestSidesOverlap(t, o, 2);
    }

    if (!check12)
    {
        sides.emplace_back(1, 2);
    }

    if (!check23)
    {
        sides.emplace_back(2, 3);
    }

    if (!check31)
    {
        sides.emplace_back(3, 1);
    }

    return sides;
}
