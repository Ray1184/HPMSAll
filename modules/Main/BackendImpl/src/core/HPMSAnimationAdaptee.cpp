/*!
 * File HPMSAnimationAdaptee.cpp
 */

#include <core/HPMSAnimationAdaptee.h>
#include <iostream>

void hpms::AnimationAdaptee::Update(float tpf)
{
    Check(ogreAnim);
    ogreAnim->addTime(tpf);
    cycleTerminated = false;
    animTerminated = false;    
    normalizedTime += tpf;
    float realLength = ogreAnim->getLength();
    float length = realLength / sliceFactor;
    if (normalizedTime >= length) {
        normalizedTime = 0.0f;
        cycleTerminated = true;
        if (normalizedTime >= realLength) {
            animTerminated = true;
        }
    }

}

void hpms::AnimationAdaptee::Zero()
{
    Check(ogreAnim);
    if (animTerminated)
    {
        ogreAnim->setTimePosition(0);
    }
    cycleTerminated = false;
    animTerminated = false;
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

int hpms::AnimationAdaptee::GetSliceFactor() const
{
    return sliceFactor;
}

void hpms::AnimationAdaptee::SetSliceFactor(int sliceFactor)
{
    AnimationAdaptee::sliceFactor = sliceFactor;
}

bool hpms::AnimationAdaptee::CycleTerminated()
{
    return cycleTerminated;
}

float hpms::AnimationAdaptee::GetWeight() const
{
    Check(ogreAnim);
    return ogreAnim->getWeight();
}

void hpms::AnimationAdaptee::SetWeight(float weight)
{
    Check(ogreAnim);
    ogreAnim->setWeight(weight);
}

float hpms::AnimationAdaptee::GetLength() const
{
    Check(ogreAnim);
    return ogreAnim->getLength();
}


hpms::AnimationAdaptee::AnimationAdaptee(Ogre::AnimationState* ogreAnim) : AdapteeCommon(nullptr),
                                                                           normalizedTime(0.0f),
                                                                           cycleTerminated(false),
                                                                           animTerminated(false),
                                                                           sliceFactor(1),
                                                                           ogreAnim(ogreAnim)
{

}

hpms::AnimationAdaptee::~AnimationAdaptee()
{

}

