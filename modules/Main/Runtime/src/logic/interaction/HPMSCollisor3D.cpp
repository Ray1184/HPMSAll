/*!
 * File HPMSCollisor3D.cpp
 */

#include <logic/interaction/HPMSCollisor3D.h>
#include <common/HPMSUtils.h>
#include <sstream>


void hpms::Collisor3D::Update()
{
    if (!active)
    {
        return;
    }

    auto* collisionManager = hpms::GetSupplier()->GetCollisionManager();
    CollisionRay ray(GetPosition(), V2_TO_V3(direction));
    auto resp = collisionManager->CheckRayCollision(this, ray, opts);
    std::stringstream ss;
    std::string closDist = "N/D";
    std::string collEnt = "N/D";
    if (resp.hasCollision)
    {
        closDist = resp.closestDistance;
        collEnt = resp.collidedEntity->GetName();
    }
    ss << "Ray collision: " << resp.hasCollision << "\nDistance: " << closDist << "\nactor Collided: " << collEnt;
    LOG_DEBUG(ss.str().c_str());

}


void hpms::Collisor3D::CorrectPositionAfterCollision(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle)
{
//    glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
//    glm::vec3 v = nextPosition - actor->GetPosition();
//    glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
//    glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
//    glm::vec3 correctPosition = ADDV3_V2(actor->GetPosition(), vt);
//
//    if (resampleTriangle)
//    {
//
//        auto* correctTriangle = walkMap->SampleTriangle(correctPosition, tolerance);
//
//        if (correctTriangle != nullptr)
//        {
//            // Calculated position is good, move actor to calculated position.
//            actor->SetPosition(correctPosition);
//
//            // Assign for safe, but correctTriangle should be the original.
//            currentTriangle = correctTriangle;
//        }
//    } else
//    {
//        actor->SetPosition(correctPosition);
//    }
}

void hpms::Collisor3D::Move(const glm::vec3& nextPosition, const glm::vec2 direction)
{
    if (Collisor3D::nextPosition != nextPosition)
    {
        outOfDate = true;
    }
    Collisor3D::nextPosition = nextPosition;
    Collisor3D::direction = direction;


}

std::string hpms::Collisor3D::GetName()
{
    return actor->GetName();
}

glm::vec3 hpms::Collisor3D::GetPosition() const
{
    return actor->GetPosition();
}

glm::quat hpms::Collisor3D::GetRotation() const
{
    return actor->GetRotation();
}

glm::vec3 hpms::Collisor3D::GetScale() const
{
    return actor->GetScale();
}

void hpms::Collisor3D::SetVisible(bool visible)
{

}

bool hpms::Collisor3D::IsVisible() const
{
    return false;
}

const std::string hpms::Collisor3D::Name() const
{
    return "Collisor3D";
}

void hpms::Collisor3D::SetScale(const glm::vec3& scale)
{
    actor->SetScale(scale);
}

void hpms::Collisor3D::SetRotation(const glm::quat& rotation)
{
    actor->SetRotation(rotation);
}

void hpms::Collisor3D::SetPosition(const glm::vec3& position)
{
    glm::vec3 dir3 = hpms::CalcDirection(actor->GetRotation(), VEC_FORWARD);
    glm::vec2 dir2(dir3.x, dir3.z);
    Move(position, dir2);
}


hpms::Collisor3D::Collisor3D(hpms::ActorAdapter* actor, float tolerance) : actor(actor),
                                                                           tolerance(tolerance),
                                                                           ignore(false),
                                                                           outOfDate(true)
{
    opts.maxDistance = MAX_DIST;
    if (auto* e = dynamic_cast<hpms::EntityAdapter*>(actor))
    {
        opts.toIgnore.push_back(e);
    }

    if (auto* n = dynamic_cast<hpms::SceneNodeAdapter*>(actor))
    {
        for (auto* e: n->GetAttachedEntitiesInTree())
        {
            opts.toIgnore.push_back(e);
        }
    }
}
