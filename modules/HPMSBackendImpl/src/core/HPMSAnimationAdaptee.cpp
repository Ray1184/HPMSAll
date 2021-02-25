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
    Check(ogreAnim);
    return ogreAnim->getEnabled();
}

void hpms::AnimationAdaptee::SetPlaying(bool playing)
{
    Check(ogreAnim);
    ogreAnim->setEnabled(playing);
}

bool hpms::AnimationAdaptee::IsLoop()
{
    Check(ogreAnim);
    return ogreAnim->getLoop();
}

void hpms::AnimationAdaptee::SetLoop(bool loop)
{
    Check(ogreAnim);
    ogreAnim->setLoop(loop);
}

hpms::AnimationAdaptee::AnimationAdaptee(Ogre::AnimationState* ogreAnim) : AdapteeCommon(nullptr), ogreAnim(ogreAnim)
{

}

hpms::AnimationAdaptee::~AnimationAdaptee()
{

}

void hpms


