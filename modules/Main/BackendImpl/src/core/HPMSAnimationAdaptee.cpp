/*!
 * File HPMSAnimationAdaptee.cpp
 */

#include <core/HPMSAnimationAdaptee.h>
#include <iostream>

void hpms::AnimationAdaptee::Update(float tpf)
{
    Check(ogreAnim);
    ogreAnim->addTime(tpf);
    normalizedTime += tpf;
    float length = ogreAnim->getLength();
    if (normalizedTime >= length) {
        normalizedTime = 0.0f;
        cycleTerminated = true;
    }
    else
    {
        cycleTerminated = false;
    }
}

void hpms::AnimationAdaptee::Zero()
{
    Check(ogreAnim);
    ogreAnim->setTimePosition(0);
    cycleTerminated = false;
}

bool hpms::AnimationAdaptee::IsPlaying() const
{
    Check(ogreAnim);
    return ogreAnim->getEnabled();
}

void hpms::AnimationAdaptee::SetPlaying(bool playing)
{
    Check(ogreAnim);
    ogreAnim->setEnabled(playing);
}

bool hpms::AnimationAdaptee::IsLoop() const
{
    Check(ogreAnim);
    return ogreAnim->getLoop();
}

void hpms::AnimationAdaptee::SetLoop(bool loop)
{
    Check(ogreAnim);
    ogreAnim->setLoop(loop);
}

hpms::AnimationAdaptee::AnimationAdaptee(Ogre::AnimationState* ogreAnim) : AdapteeCommon(nullptr),
                                                                           normalizedTime(0.0f),
                                                                           cycleTerminated(false),
                                                                           ogreAnim(ogreAnim)
{

}

hpms::AnimationAdaptee::~AnimationAdaptee()
{

}

bool hpms::AnimationAdaptee::CycleTerminated()
{
    return cycleTerminated;
}
