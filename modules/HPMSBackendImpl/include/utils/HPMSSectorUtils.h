/*!
 * File HPMSSectorUtils.h
 */

#pragma once

#include <resource/HPMSWalkmap.h>
#include <common/HPMSUtils.h>
#include <utils/HPMSCalcUtils.h>

namespace hpms
{
    void SampleTriangle(const glm::vec3& pos, const hpms::WalkmapPtr& walkMap, float tolerance, hpms::Triangle* res);

    glm::vec2 GetSideCoordFromSideIndex(const hpms::Triangle& tri, unsigned int idx);

    std::pair<glm::vec2, glm::vec2> GetSideCoordsFromTriangle(const hpms::Triangle& tri, const hpms::Side& side);
}
