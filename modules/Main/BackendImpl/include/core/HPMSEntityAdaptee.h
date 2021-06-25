/*!
 * File HPMSEntityAdaptee.h
 */


#pragma once

#include <api/HPMSEntityAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <common/HPMSUtils.h>
#include <glm/glm.hpp>
#include <glm/gtc/quaternion.hpp>
#include <Ogre.h>
#include <core/HPMSOgreContext.h>
#include <vector>
#include <map>
#include <core/HPMSAttachableItem.h>

namespace hpms
{
    class AABBAdaptee : public AABBAdapter
    {
    private:
        Ogre::AxisAlignedBox ogreAABB;
    public:

        explicit AABBAdaptee(Ogre::Entity* entity = nullptr);

        virtual ~AABBAdaptee();

        inline const Ogre::AxisAlignedBox& GetOgreAabb() const
        {
            return ogreAABB;
        }

        inline void SetOgreAabb(const Ogre::AxisAlignedBox& ogreAabb)
        {
            ogreAABB = ogreAabb;
        }

        glm::vec3 GetCorner(Corner corner) override;
    };

    class EntityAdaptee : public EntityAdapter, public AdapteeCommon, public AttachableItem
    {
    private:
        Ogre::Entity* ogreEntity;
        AABBAdaptee* aabb;
        hpms::EntityMode mode;
        std::map<std::string, hpms::AnimationAdapter*> animMap;
        std::vector<hpms::AnimationAdapter*> animList;

    public:
        EntityAdaptee(hpms::OgreContext* ctx, const std::string& name);

        virtual ~EntityAdaptee();

        std::string GetName() override;

        void SetPosition(const glm::vec3& position) override;

        glm::vec3 GetPosition() const override;

        void SetRotation(const glm::quat& rotation) override;

        glm::quat GetRotation() const override;

        void SetScale(const glm::vec3& scale) override;

        glm::vec3 GetScale() const override;

        void SetVisible(bool visible) override;

        bool IsVisible() const override;

        void SetMode(EntityMode mode) override;

        virtual std::vector<hpms::AnimationAdapter*>& GetAllAnimations() override;

        virtual AnimationAdapter* GetAnimationByName(const std::string& animName) override;

        virtual void
        AttachObjectToBone(const std::string& boneName, hpms::ActorAdapter* object, const glm::vec3& offsetPosition,
                           const glm::quat& offsetOrientation) override;

        virtual void
        DetachObjectFromBone(const std::string& boneName, hpms::ActorAdapter* object) override;


        virtual Ogre::MovableObject* GetNative() override;

        AABBAdapter* GetAABB() override;

        void NotifyAttached();

        void NotifyDetached();
    };
}
