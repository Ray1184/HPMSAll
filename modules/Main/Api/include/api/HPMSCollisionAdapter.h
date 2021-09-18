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

        EntityAdapter* collisionEntityName;

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

        glm::vec3 origin;
        glm::vec3 direction;

    };

    struct CollisionOptions
    {
        unsigned int flags = 0xFFFFFFFF;
        EntityAdapter* toIgnore;
        float maxDistance;

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

        virtual CollisionResponse CheckRayCollision(const CollisionRay& ray, const CollisionOptions& options) = 0;


    };

}