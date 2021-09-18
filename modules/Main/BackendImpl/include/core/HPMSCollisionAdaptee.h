/*!
 * File HPMSCollisionAdaptee.h
 */


#pragma once

#include <api/HPMSCollisionAdapter.h>
#include <Ogre.h>
#include <core/HPMSAdapteeCommon.h>
#include <api/HPMSEntityAdapter.h>
#include <thirdparty/TPNewMOC.h>
#include <unordered_map>

namespace hpms
{
    class CollisionAdaptee : public CollisionAdapter, public AdapteeCommon {
    private:
        Collision::CollisionTools* collisionTools;
        std::unordered_map<std::string, hpms::EntityAdapter*> registeredEntities;
    public:
        CollisionAdaptee(OgreContext* ctx);

        virtual ~CollisionAdaptee();

        void RegisterEntity(EntityAdapter* entity, CollisionEntityMode entityMode, CollisionLevel collisionLevel = MESH) override;

        void UnregisterEntity(EntityAdapter* entity) override;

        CollisionResponse CheckRayCollision(const CollisionRay& ray, const CollisionOptions& options) override;
    };
}