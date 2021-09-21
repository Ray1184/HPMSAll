/*!
 * File HPMSCollisionAdaptee.cpp
 */

#include <core/HPMSCollisionAdaptee.h>
#include <core/HPMSEntityAdaptee.h>
#include <core/HPMSSceneNodeAdaptee.h>
#include <utils/HPMSImplUtils.h>

void hpms::CollisionAdaptee::RegisterEntity(hpms::EntityAdapter* entity, hpms::CollisionEntityMode entityMode, hpms::CollisionLevel collisionLevel)
{
    auto* entityAdaptee = dynamic_cast<hpms::EntityAdaptee*>(entity);
    auto* ogreEntity = dynamic_cast<Ogre::Entity*>(entityAdaptee->GetNative());
    Collision::ECollisionType ogreCollisionLevel;
    switch (collisionLevel)
    {
        case BOX:
            ogreCollisionLevel = Collision::ECollisionType::COLLISION_BOX;
            break;
        case SHPERE:
            ogreCollisionLevel = Collision::ECollisionType::COLLISION_SPHERE;
            break;
        default:
            ogreCollisionLevel = Collision::ECollisionType::COLLISION_ACCURATE;
            break;
    }
    switch (entityMode)
    {
        case STATIC:
            collisionTools->register_static_entity(ogreEntity, hpms::Vec3ApiToImpl(entityAdaptee->GetPosition()),
                                                   hpms::QuatApiToImpl(entityAdaptee->GetRotation()),
                                                   hpms::Vec3ApiToImpl(entityAdaptee->GetScale()),
                                                   ogreCollisionLevel);
            break;
        default:
            collisionTools->register_entity(ogreEntity, ogreCollisionLevel);
            break;
    }

    registeredEntities.insert({ogreEntity->getName(), entity});
}

void hpms::CollisionAdaptee::UnregisterEntity(EntityAdapter* entity)
{
    auto* entityAdaptee = dynamic_cast<hpms::EntityAdaptee*>(entity);
    auto* ogreEntity = dynamic_cast<Ogre::Entity*>(entityAdaptee->GetNative());
    if (registeredEntities.count(ogreEntity->getName()))
    {
        collisionTools->remove_entity(ogreEntity);
        registeredEntities.erase(ogreEntity->getName());
    }
}

hpms::CollisionResponse hpms::CollisionAdaptee::CheckRayCollision(ActorAdapter* sender, const hpms::CollisionRay& ray, const hpms::CollisionOptions& options)
{
    Ogre::Ray ogreRay(hpms::Vec3ApiToImpl(ray.origin), hpms::Vec3ApiToImpl(ray.direction));
    auto ret = collisionTools->check_ray_collision(ogreRay, GetIgnoreListByActor(sender, options.toIgnore), options.flags, options.maxDistance);
    auto* entityAdapter = registeredEntities[ret.entity->getName()];
    CollisionTriangle triInfo{};
    if (ret.hasTriInfo)
    {
        triInfo.v1 = hpms::Vec3ImplToApi(ret.triInfo.v1);
        triInfo.v2 = hpms::Vec3ImplToApi(ret.triInfo.v2);
        triInfo.v3 = hpms::Vec3ImplToApi(ret.triInfo.v3);
    }
    return CollisionResponse{ret.collided, hpms::Vec3ImplToApi(ret.position), entityAdapter, ret.closest_distance, ret.hasTriInfo, triInfo};
}

hpms::CollisionAdaptee::CollisionAdaptee(hpms::OgreContext* ctx) : AdapteeCommon(ctx)
{
    collisionTools = hpms::SafeNewRaw<Collision::CollisionTools>();

}

hpms::CollisionAdaptee::~CollisionAdaptee()
{
    hpms::SafeDeleteRaw(collisionTools);
}

const std::vector<Ogre::Entity*>& hpms::CollisionAdaptee::GetIgnoreListByActor(hpms::ActorAdapter* sender, std::vector<EntityAdapter*> toIgnore) const
{
    if (toIgnoreCache.count(sender->GetName())) {
        std::vector<Ogre::Entity*> ogreIgnores;
        for (auto* entity : toIgnore) {
            auto* entityImpl = dynamic_cast<EntityAdaptee*>(entity);
            ogreIgnores.push_back(dynamic_cast<Ogre::Entity*>(entityImpl->GetNative()));
        }
    }
    return toIgnoreCache.at(sender->GetName());
}

