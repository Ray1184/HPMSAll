/*!
 * File HPMSAnimationAdaptee.cpp
 */

#include <core/HPMSAnimationAdaptee.h>

void hpms::AnimationAdaptee::Update(float tpf)
{
    Check(ogreAnim);
    ogreAnim->addTime(tpf);
}

bool hpms::AnimationAdaptee::IsPlaying()
{
    return ogreAnim->getEnabled();
}

void hpms::AnimationAdaptee::SetPlaying(bool playing)
{
    ogreAnim->setEnabled(playing);
}

bool hpms::AnimationAdaptee::IsLoop()
{
    return ogreAnim->getLoop();
}

void hpms::AnimationAdaptee::SetLoop(bool loop)
{
    ogreAnim->setLoop(loop);
}

hpms::AnimationAdaptee::AnimationAdaptee(Ogre::AnimationState* ogreAnim) : AdapteeCommon(nullptr), ogreAnim(ogreAnim)
{

}

hpms::AnimationAdaptee::~AnimationAdaptee()
{

}


