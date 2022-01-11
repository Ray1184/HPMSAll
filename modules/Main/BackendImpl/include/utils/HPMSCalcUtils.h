/*!
 * File HPMSCalcUtils.h
 */

#pragma once

#include <glm/glm.hpp>
#include <resource/HPMSWalkmap.h>

namespace hpms
{    

    bool Is2DPointInside3DSector(const Triangle& sec, const glm::vec2& pos, float tolerance = 0);

    bool TestSidesOverlap(const hpms::Triangle& t, const hpms::Triangle& o, unsigned int side);

    std::vector<hpms::Side>
    CalculatePerimetralSides(const hpms::Triangle& t, const std::vector<hpms::Triangle>& triangles);



}
