/*!
 * File HPMSCollisor.cpp
 */

#include <logic/interaction/HPMSCollisor.h>

#define CHECK_COLLISIONS DetectBySector()

void hpms::Collisor::Update()
{
    if (!active || !outOfDate)
    {
        return;
    }

    outOfDate = false;
    CHECK_COLLISIONS;

}

void hpms::Collisor::DetectByBoundingRadius()
{
    if (!hpms::PointInsidePolygon(nextPosition, glm::vec2(0, 0), perimeter))
    {
        LOG_DEBUG("OUTSIDE PERIMETER");
    } else {
        LOG_DEBUG("WITHIN PERIMETER");
    }
    /*bool intersect = false;
    auto collisionProcess = [&](const glm::vec2& sideAPos, const glm::vec2& sideBPos)
    {
        if (hpms::IntersectCircleLineSegment(nextPosition, actor->GetBoundingRadius(), sideAPos, sideBPos))
        {
            CorrectPositionAfterCollision(sideAPos, sideBPos, false);
            intersect = true;
            return true;
        }
        return false;
    };
    walkMap->ForEachSide(collisionProcess);
    if (!intersect)
    {
        actor->SetPosition(nextPosition);
    }*/

    actor->SetPosition(nextPosition);

}

void hpms::Collisor::DetectBySector()
{
    auto* nextTriangle = walkMap->SampleTriangle(nextPosition, tolerance);

    if (nextTriangle)
    {
        // No collision, go to next triangle.
        actor->SetPosition(nextPosition);
        currentTriangle = nextTriangle;
        return;
    } else
    {
        // No sampling.
        if (currentTriangle == nullptr)
        {
            return;
        }

        // Check potential collisions.
        for (auto* side : currentTriangle->GetPerimetralSides())
        {
            std::pair<glm::vec2, glm::vec2> sidePair = walkMap->GetSideCoordsFromTriangle(currentTriangle, side);
            float t = IntersectRayLineSegment(actor->GetPosition(), direction, sidePair.first, sidePair.second);
            // Correct side.
            if (t > -1)
            {
                CorrectPositionAfterCollision(sidePair.first, sidePair.second, true);
                return;
            }
        }
    }
}

void hpms::Collisor::CorrectPositionAfterCollision(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle)
{
    glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
    glm::vec3 v = nextPosition - actor->GetPosition();
    glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
    glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
    glm::vec3 correctPosition = ADDV3_V2(actor->GetPosition(), vt);

    if (resampleTriangle)
    {

        auto* correctTriangle = walkMap->SampleTriangle(correctPosition, tolerance);

        if (correctTriangle != nullptr)
        {
            // Calculated position is good, move actor to calculated position.
            actor->SetPosition(correctPosition);

            // Assign for safe, but correctTriangle should be the original.
            currentTriangle = correctTriangle;
        }
    } else
    {
        actor->SetPosition(correctPosition);
    }
}

void hpms::Collisor::Move(const glm::vec3& nextPosition, const glm::vec2 direction)
{
    if (Collisor::nextPosition != nextPosition)
    {
        outOfDate = true;
    }
    Collisor::nextPosition = nextPosition;
    Collisor::direction = direction;


}

std::string hpms::Collisor::GetName()
{
    return actor->GetName();
}

glm::vec3 hpms::Collisor::GetPosition() const
{
    return actor->GetPosition();
}

glm::quat hpms::Collisor::GetRotation() const
{
    return actor->GetRotation();
}

glm::vec3 hpms::Collisor::GetScale() const
{
    return actor->GetScale();
}

void hpms::Collisor::SetVisible(bool visible)
{

}

bool hpms::Collisor::IsVisible() const
{
    return false;
}

const std::string hpms::Collisor::Name() const
{
    return "Collisor";
}

void hpms::Collisor::SetScale(const glm::vec3& scale)
{
    actor->SetScale(scale);
}

void hpms::Collisor::SetRotation(const glm::quat& rotation)
{
    actor->SetRotation(rotation);
}

void hpms::Collisor::SetPosition(const glm::vec3& position)
{
    glm::vec3 dir3 = hpms::CalcDirection(actor->GetRotation(), VEC_FORWARD);
    glm::vec2 dir2(dir3.x, dir3.z);
    Move(position, dir2);
}

hpms::Collisor::Collisor(hpms::ActorAdapter* actor, hpms::WalkmapAdapter* walkMap, float tolerance) : actor(actor),
                                                                                                      walkMap(walkMap),
                                                                                                      tolerance(tolerance),
                                                                                                      ignore(false),
                                                                                                      outOfDate(true)
{

    auto checkPerimeter = [&](const glm::vec2& sideAPos, const glm::vec2& sideBPos)
    {
        perimeter.push_back(sideAPos);
        return false;
    };
    walkMap->ForEachSide(checkPerimeter);
}


