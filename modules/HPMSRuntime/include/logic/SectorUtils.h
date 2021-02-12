/*!
 * File InteractionUtils.h
 */

#pragma once

#include <logic/RoomModelItem.h>
#include <logic/items/WalkMap.h>
#include <common/Utils.h>
#include <logic/CalcUtils.h>
#include <core/Actor.h>

namespace hpms
{
    Triangle SampleTriangle(const glm::vec3& pos, hpms::WalkMap* walkMap, float tolerance);

    inline Triangle SampleTriangle(hpms::Actor* actor, hpms::WalkMap* walkMap, float tolerance)
    {
        return SampleTriangle(actor->GetPosition(), walkMap, tolerance);
    }

    inline bool
    ActorInsideSector(hpms::Actor* actor, const hpms::Sector& sector, hpms::WalkMap* walkMap, float tolerance)
    {
        return ActorInsideSector(actor, sector.GetId(), walkMap, tolerance);
    }

    inline bool
    ActorInsideSector(hpms::Actor* actor, const std::string& sectorName, hpms::WalkMap* walkMap, float tolerance)
    {
        return sectorName == SampleTriangle(actor, walkMap, tolerance).GetSectorId();
    }



    glm::vec2 GetSideCoordFromSideIndex(const hpms::Triangle& tri, unsigned int idx);

    std::pair<glm::vec2, glm::vec2> GetSideCoordsFromTriangle(const hpms::Triangle& tri, const hpms::Side& side);
}
