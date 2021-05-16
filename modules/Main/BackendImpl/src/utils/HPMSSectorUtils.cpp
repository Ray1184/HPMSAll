/*!
 * File HPMSSectorUtils.cpp
 */

#include <utils/HPMSSectorUtils.h>

void hpms::SampleTriangle(const glm::vec3& pos, const hpms::WalkmapPtr& walkMap, float tolerance, hpms::Triangle* res)
{
    for (const auto& sector : walkMap->GetData()->GetSectors())
    {
        for (const auto& tri : sector.GetTriangles())
        {
            if (hpms::Is2DPointInside3DSector(tri, glm::vec2(SD(pos), FW(pos)), tolerance))
            {
                *res = tri;
                return;
            }
        }
    }

}

glm::vec2 hpms::GetSideCoordFromSideIndex(const hpms::Triangle* tri, unsigned int idx)
{
    switch (idx)
    {
        case 1:
            return glm::vec2(tri->SD1, tri->FW1);
        case 2:
            return glm::vec2(tri->SD2, tri->FW2);
        case 3:
            return glm::vec2(tri->SD3, tri->FW3);
        default:
            std::stringstream ss;
            ss << "Index id " << idx << " not allowed for external side" << std::endl;
            LOG_ERROR(ss.str().c_str());
            return glm::vec2();
    }
}

std::pair<glm::vec2, glm::vec2> hpms::GetSideCoordsFromTriangle(const hpms::Triangle* tri, const hpms::Side* side)
{
    for (const auto& s : tri->GetPerimetralSides())
    {
        if (s == *side)
        {
            return std::make_pair(GetSideCoordFromSideIndex(tri, s.idx1), GetSideCoordFromSideIndex(tri, s.idx2));
        }
    }
    return std::make_pair(glm::vec2(), glm::vec2());
}

