/*!
 * File HPMSEntityAdapter.h
 */


#pragma once

#define NO_ANIM "__NO_ANIM_DATA__"

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSAnimationAdapter.h>
#include <vector>

namespace hpms
{

    enum EntityMode
    {
        COLOR_AND_DEPTH = 0,
        DEPTH_ONLY = 1,
        COLOR_ONLY = 2,
        HIDDEN = 3
    };

    class EntityAdapter : public hpms::ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "EntityAdapter/" + GetName();
        }

        inline virtual ~EntityAdapter()
        {

        }

        virtual void SetMode(EntityMode mode) = 0;

        virtual void AttachObjectToBone(const std::string& boneName, hpms::ActorAdapter* object,
                                        const glm::vec3& offsetPosition, const glm::quat& offsetOrientation,
                                        const glm::vec3& scale) = 0;

        virtual void
        DetachObjectFromBone(const std::string& boneName, hpms::ActorAdapter* object) = 0;

        virtual std::vector<hpms::AnimationAdapter*>& GetAllAnimations() = 0;

        virtual hpms::AnimationAdapter* GetAnimationByName(const std::string& animName) = 0;

        virtual std::string GetActiveAnimation() const = 0;

        virtual std::string GetLastAnimation() const = 0;

        virtual void SetActiveAnimation(const std::string& activeAnimation) = 0;

        virtual glm::vec3 GetWorldPosition() const = 0;

        inline virtual void SetWorldPosition(const glm::vec3& v)
        {
            // Not implemented.
        }

        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;


    };
}