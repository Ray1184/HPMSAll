/*!
 * File HPMSCollisionAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <vector>
#include <string>
#include <glm/glm.hpp>
#include <functional>
#include <api/HPMSEntityAdapter.h>

namespace hpms
{

    struct CollisionTriangle
    {

        glm::vec3 v1;

        glm::vec3 v2;

        glm::vec3 v3;
    };

    struct CollisionResponse
    {

        bool hasCollision;

        glm::vec3 collisionPoint;

        EntityAdapter* collidedEntity;

        float closestDistance;

        bool hasCollisionTriInfo;

        CollisionTriangle collisionTriInfo;
    };

    enum CollisionLevel
    {
        BOX,
        SHPERE,
        MESH

    };

    enum CollisionEntityMode
    {
        DYNAMIC,
        STATIC

    };

    struct CollisionRay
    {
        CollisionRay(const glm::vec3& origin, const glm::vec3& direction) : origin(origin), direction(direction)
        {}

        glm::vec3 origin;
        glm::vec3 direction;

    };

    struct CollisionOptions
    {
        CollisionOptions() : maxDistance(10), toIgnore(std::vector<EntityAdapter*>()), flags(0xFFFFFFFF)
        {}

        CollisionOptions(float maxDistance, const std::vector<EntityAdapter*>& toIgnore) : maxDistance(maxDistance), toIgnore(toIgnore), flags(0xFFFFFFFF)
        {}

        float maxDistance;
        std::vector<EntityAdapter*> toIgnore;
        unsigned int flags;


    };

    class CollisionAdapter : public Object
    {
    public:
        inline const std::string Name() const override
        {
            return "CollisionAdapter";
        }

        inline virtual ~CollisionAdapter()
        {

        }

        virtual void RegisterEntity(EntityAdapter* entity, CollisionEntityMode entityMode, CollisionLevel collisionLevel = MESH) = 0;

        virtual void UnregisterEntity(EntityAdapter* entity) = 0;

        virtual CollisionResponse CheckRayCollision(ActorAdapter* sender, const CollisionRay& ray, const CollisionOptions& options) = 0;


    };

}