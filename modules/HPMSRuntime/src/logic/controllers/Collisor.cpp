/*!
 * File Collisor.cpp
 */

#include <logic/controllers/Collisor.h>

void hpms::Collisor::Update()
{
    if (!active || !outOfDate)
    {
        return;
    }

    outOfDate = false;
    Triangle nextTriangle = hpms::SampleTriangle(nextPosition, walkMap, tolerance);

    if (nextTriangle.GetSectorId() != UNDEFINED_SECTOR || ignore || walkMap->DummyMap())
    {
        // No collision, go to next triangle.
        actor->SetPosition(nextPosition);
        currentTriangle = nextTriangle;
        return;
    } else
    {
        // Check potential collisions.
        for (const auto& side : currentTriangle.GetPerimetralSides())
        {
            std::pair<glm::vec2, glm::vec2> sidePair = hpms::GetSideCoordsFromTriangle(currentTriangle, side);
            float t = hpms::IntersectRayLineSegment(actor->GetPosition(), direction, sidePair.first, sidePair.second);
            // Correct side.
            if (t > -1)
            {
                glm::vec2 n = glm::normalize(hpms::Perpendicular(sidePair.first - sidePair.second));
                glm::vec3 v = nextPosition - actor->GetPosition();
                glm::vec2 vn = n * glm::dot(glm::vec2(v.x, v.z), n);
                glm::vec2 vt = glm::vec2(v.x, v.z) - vn;
                glm::vec3 correctPosition = glm::vec3(actor->GetPosition().x + vt.x, actor->GetPosition().y,
                                                      actor->GetPosition().z + vt.y);

                Triangle correctTriangle = hpms::SampleTriangle(correctPosition, walkMap, tolerance);

                if (correctTriangle.GetSectorId() != UNDEFINED_SECTOR)
                {
                    // Calculated position is good, move actor to calculated position.
                    actor->SetPosition(correctPosition);

                    // Assign for safe, but correctTriangle should be the original.
                    currentTriangle = correctTriangle;
                }
                return;
            }
        }
    }
}

