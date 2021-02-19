/*!
 * File HPMSCameraAdaptee.cpp
 */

#include <core/HPMSCameraAdaptee.h>

void hpms::CameraAdaptee::SetPosition(const glm::vec3& position)
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        ogreCamera->getParentSceneNode()->setPosition(position.x, position.y, position.z);
    } else
    {
        ogreCamera->setPosition(position.x, position.y, position.z);
    }

}

glm::vec3 hpms::CameraAdaptee::GetPosition()
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        auto ogrePos = ogreCamera->getParentSceneNode()->getPosition();
        return glm::vec3(ogrePos.x, ogrePos.y, ogrePos.z);
    } else
    {
        auto ogrePos = ogreCamera->getPosition();
        return glm::vec3(ogrePos.x, ogrePos.y, ogrePos.z);
    }
}

void hpms::CameraAdaptee::SetRotation(const glm::quat& rotation)
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        ogreCamera->getParentSceneNode()->setOrientation(rotation.w, rotation.x, rotation.y, rotation.z);
    } else
    {
        ogreCamera->setOrientation(Ogre::Quaternion(rotation.w, rotation.x, rotation.y, rotation.z));
    }
}

glm::quat hpms::CameraAdaptee::GetRotation()
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode() != nullptr)
    {
        auto oQuatc = ogreCamera->getParentSceneNode()->getOrientation();
        return glm::quat(oQuatc.w, oQuatc.x, oQuatc.y, oQuatc.z);
    } else {
        auto oQuatc = ogreCamera->getOrientation();
        return glm::quat(oQuatc.w, oQuatc.x, oQuatc.y, oQuatc.z);
    }

}

void hpms::CameraAdaptee::SetNear(float near)
{
    Check(ogreCamera);
    ogreCamera->setNearClipDistance(Ogre::Real(near));
}

void hpms::CameraAdaptee::SetFar(float far)
{
    Check(ogreCamera);
    ogreCamera->setFarClipDistance(Ogre::Real(far));
}

void hpms::CameraAdaptee::SetFovY(float fovY)
{
    Check(ogreCamera);
    ogreCamera->setFOVy(Ogre::Radian(fovY));
}

void hpms::CameraAdaptee::LookAt(glm::vec3 position)
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        ogreCamera->getParentSceneNode()->lookAt(Ogre::Vector3(position.x, position.y, position.z),
                                                 Ogre::Node::TS_PARENT);
    } else
    {
        ogreCamera->lookAt(position.x, position.y, position.z);
    }
}

hpms::CameraAdaptee::CameraAdaptee(hpms::OgreContext* ctx, const std::string& name) : AdapteeCommon(ctx)
{
    Check();
    ogreCamera = ctx->GetCamera();
}

hpms::CameraAdaptee::~CameraAdaptee()
{
    Check();
    ((OgreContext*) ctx)->GetSceneManager()->destroyCamera(ogreCamera);
}


