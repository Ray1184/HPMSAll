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
        float normalizedTime;
        float frameDuration;
        bool cycleTerminated;
    public:
        explicit AnimationAdaptee(Ogre::AnimationState* ogreAnim);

        virtual ~AnimationAdaptee();

        virtual void Update(float tpf) override;

        virtual void Zero() override;

        virtual bool IsPlaying() const override;

        virtual void SetPlaying(bool playing) override;

        virtual bool IsLoop() const override;

        virtual void SetLoop(bool loop) override;

        virtual bool CycleTerminated() override;

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

