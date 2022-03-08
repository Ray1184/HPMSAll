/*!
 * File HPMSEntityAdaptee.cpp
 */

#include <core/HPMSEntityAdaptee.h>
#include <core/HPMSEntityHelper.h>
#include <core/HPMSAnimationAdaptee.h>

#define FIRST_BUCKET 0
#define SECOND_BUCKET 1
#define THIRD_BUCKET 2
#define FOURTH_BUCKET 3
#define FIFTH_BUCKET 4
#define SIXTH_BUCKET 5
#define LAST_BUCKET 100


std::string hpms::EntityAdaptee::GetName() const
{
    Check(ogreEntity);
    return ogreEntity->getMesh()->getName();
}

void hpms::EntityAdaptee::SetPosition(const glm::vec3& position)
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        ogreEntity->getParentSceneNode()->setPosition(position.x, position.y, position.z);
    }
}

glm::vec3 hpms::EntityAdaptee::GetPosition() const
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        auto oVec = ogreEntity->getParentSceneNode()->getPosition();
        return glm::vec3(oVec.x, oVec.y, oVec.z);
    }
    return glm::vec3();
}

void hpms::EntityAdaptee::SetRotation(const glm::quat& rot)
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        ogreEntity->getParentSceneNode()->setOrientation(rot.w, rot.x, rot.y, rot.z);
    }
}

glm::quat hpms::EntityAdaptee::GetRotation() const
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        auto oQuatc = ogreEntity->getParentSceneNode()->getOrientation();
        return glm::quat(oQuatc.w, oQuatc.x, oQuatc.y, oQuatc.z);
    }
    return glm::quat();
}

void hpms::EntityAdaptee::SetScale(const glm::vec3& scale)
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        ogreEntity->getParentSceneNode()->setScale(scale.x, scale.y, scale.z);
    }
}

glm::vec3 hpms::EntityAdaptee::GetScale() const
{
    Check(ogreEntity);
    if (ogreEntity->getParentSceneNode() != nullptr)
    {
        auto oVec = ogreEntity->getParentSceneNode()->getScale();
        return glm::vec3(oVec.x, oVec.y, oVec.z);
    }
    return glm::vec3();
}

void hpms::EntityAdaptee::SetVisible(bool visible)
{
    Check(ogreEntity);
    ogreEntity->setVisible(visible);
}

bool hpms::EntityAdaptee::IsVisible() const
{
    Check(ogreEntity);
    return ogreEntity->isVisible();
}

void hpms::EntityAdaptee::SetMode(hpms::EntityMode mode)
{
    if (hpms::EntityAdaptee::mode == mode)
    {
        return;
    }
    Check(ogreEntity);
    switch (mode)
    {
        case hpms::EntityMode::DEPTH_ONLY:
            hpms::EntityHelper::SetWriteDepthOnly(ogreEntity);
            ogreEntity->setRenderQueueGroup(FIRST_BUCKET);
            break;
        case hpms::EntityMode::COLOR_ONLY:
            hpms::EntityHelper::SetWriteColorOnly(ogreEntity);
            ogreEntity->setRenderQueueGroup(LAST_BUCKET);
            break;
        case hpms::EntityMode::HIDDEN:
            hpms::EntityHelper::SetWriteNothing(ogreEntity);
            ogreEntity->setRenderQueueGroup(LAST_BUCKET);
            break;
        default:
            hpms::EntityHelper::SetWriteDepthAndColor(ogreEntity);
            ogreEntity->setRenderQueueGroup(SECOND_BUCKET);
            break;
    }
    hpms::EntityAdaptee::mode = mode;
}


std::vector<hpms::AnimationAdapter*>& hpms::EntityAdaptee::GetAllAnimations()
{
    return animList;
}

hpms::AnimationAdapter* hpms::EntityAdaptee::GetAnimationByName(const std::string& animName)
{
    auto* anim = animMap[animName];
    if (anim == nullptr)
    {
        std::stringstream ss;
        ss << "No animation state with name '" << animName << "' found for entity " << GetName();
        LOG_ERROR(ss.str().c_str());
    }
    return anim;
}

void hpms::EntityAdaptee::AttachObjectToBone(const std::string& boneName, hpms::ActorAdapter* object,
                                             const glm::vec3& offsetPosition, const glm::quat& offsetOrientation)
{
    Check(ogreEntity);
    Ogre::Vector3 posOff(offsetPosition.x, offsetPosition.y, offsetPosition.z);
    Ogre::Quaternion rotOff(offsetOrientation.w, offsetOrientation.x, offsetOrientation.y, offsetOrientation.z);
    if (auto* a = dynamic_cast<AttachableItem*>(object))
    {
        ogreEntity->attachObjectToBone(boneName, a->GetNative(), rotOff, posOff);
    }
}

void hpms::EntityAdaptee::DetachObjectFromBone(const std::string& boneName, hpms::ActorAdapter* object)
{
    Check(ogreEntity);
    if (auto* a = dynamic_cast<AttachableItem*>(object))
    {
        ogreEntity->detachObjectFromBone(a->GetNative());
    }
}

Ogre::MovableObject* hpms::EntityAdaptee::GetNative()
{
    return ogreEntity;
}

std::string hpms::EntityAdaptee::GetActiveAnimation() const
{
    return activeAnimation;
}

std::string hpms::EntityAdaptee::GetLastAnimation() const
{
    return lastAnimation;
}

void hpms::EntityAdaptee::SetActiveAnimation(const std::string& activeAnimation)
{
    hpms::EntityAdaptee::lastAnimation = hpms::EntityAdaptee::activeAnimation;
    hpms::EntityAdaptee::activeAnimation = activeAnimation;
}


hpms::EntityAdaptee::EntityAdaptee(hpms::OgreContext* ctx, const std::string& name) : AdapteeCommon(ctx),
                                                                                      mode(hpms::EntityMode::COLOR_AND_DEPTH),
                                                                                      activeAnimation(NO_ANIM),
                                                                                      lastAnimation(NO_ANIM)
{
    Check();
    ogreEntity = ctx->GetSceneManager()->createEntity(name);
    if (ogreEntity->getAllAnimationStates() != nullptr)
    {
        for (auto& it : ogreEntity->getAllAnimationStates()->getAnimationStates())
        {
            auto* animAdaptee = hpms::SafeNew<hpms::AnimationAdaptee>(it.second);
            animList.push_back(animAdaptee);
            animMap[it.first] = animAdaptee;
        }
    }

}

hpms::EntityAdaptee::~EntityAdaptee()
{
    for (auto* animAdaptee : animList)
    {
        hpms::SafeDelete(animAdaptee);
    }
    (ctx)->GetSceneManager()->destroyEntity(ogreEntity);
}



