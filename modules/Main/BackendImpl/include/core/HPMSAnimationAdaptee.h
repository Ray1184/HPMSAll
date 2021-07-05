/*!
 * File HPMSAnimationAdaptee.h
 */

#pragma once

#include <api/HPMSAnimationAdapter.h>
#include <Ogre.h>
#include <core/HPMSAdapteeCommon.h>

namespace hpms
{
    class AnimationAdaptee : public hpms::AnimationAdapter, public AdapteeCommon
    {
    private:
        Ogre::AnimationState* ogreAnim;
        size_t currentFrameIndex;
        float frameDuration;
    public:
        explicit AnimationAdaptee(Ogre::AnimationState* ogreAnim);

        virtual ~AnimationAdaptee();

        virtual void Update(float tpf) override;

        virtual void Zero() override;

        virtual bool IsPlaying() override;

        virtual void SetPlaying(bool playing) override;

        virtual bool IsLoop() override;

        virtual void SetLoop(bool loop) override;

        virtual size_t GetCurrentFrameIndex() override;

        inline float GetFrameDuration() const
        {
            return frameDuration;
        }

        inline void SetFrameDuration(float frameDuration)
        {
            AnimationAdaptee::frameDuration = frameDuration;
        }
    };
}

