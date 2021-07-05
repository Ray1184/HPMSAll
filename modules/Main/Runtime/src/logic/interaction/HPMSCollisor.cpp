/*!
 * File HPMSCollisor.cpp
 */

#include <logic/interaction/HPMSCollisor.h>

void hpms::Collisor::Update()
{
    if (!active || !outOfDate)
    {
        return;
    }

    outOfDate = false;
    DetectBySector();

}

// Slower, high precision (NOT WORKING)
void hpms::Collisor::DetectByBoundingRadius()
{
    bool intersect = false;
    currentTriangle = walkMap->SampleTriangle(nextPosition, 0);
    auto collisionProcess = [&](hpms::TriangleAdapter* tri)
    {
        for (auto* side : tri->GetPerimetralSides())
        {
            std::pair<glm::vec2, glm::vec2> sidePair = walkMap->GetSideCoordsFromTriangle(tri, side);
            if (hpms::IntersectCircleLineSegment(nextPosition, actor->GetBoundingRadius(), sidePair.first, sidePair.second))
            {
                CorrectPositionAfterCollision(sidePair);
                intersect = true;
                return;
            }
        }
    };
    walkMap->Visit(collisionProcess);
    if (!intersect)
    {
        actor->SetPosition(nextPosition);
    }
}

// Faster, low precision (ACTUALLY USED)
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
        if (currentTriangle == nullptr) {
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
                CorrectPositionAfterCollision(sidePair);
                return;
            }
        }
    }
}

void hpms::Collisor::CorrectPositionAfterCollision(const std::pair<glm::vec2, glm::vec2>& sidePair)
{
    glm::vec2 n = glm::normalize(Perpendicular(sidePair.first - sidePair.second));
    glm::vec3 v = nextPosition - actor->GetPosition();
    glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
    glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
    glm::vec3 correctPosition = ADDV3_V2(actor->GetPosition(), vt);

    auto* correctTriangle = walkMap->SampleTriangle(correctPosition, tolerance);

    if (correctTriangle != nullptr)
    {
        // Calculated position is good, move actor to calculated position.
        actor->SetPosition(correctPosition);

        // Assign for safe, but correctTriangle should be the original.
        currentTriangle = correctTriangle;
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


