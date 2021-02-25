/*!
 * File HPMSEntityAdapter.h
 */


#pragma once

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
        COLOR_ONLY = 2
    };

    class EntityAdapter : public hpms::ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "EntityAdapter";
        }

        inline virtual ~EntityAdapter()
        {

        }

        virtual void SetMode(EntityMode mode) = 0;

        virtual void AttachObjectToBone(const std::string& boneName, hpms::ActorAdapter* object,
                                        const glm::vec3& offsetPosition, const glm::quat& offsetOrientation) = 0;

        virtual void
        DetachObjectFromBone(const std::string& boneName, hpms::ActorAdapter* object) = 0;

        virtual std::vector<hpms::AnimationAdapter*>& GetAllAnimations() = 0;

        virtual hpms::AnimationAdapter* GetAnimationByName(const std::string& animName) = 0;

    };
}