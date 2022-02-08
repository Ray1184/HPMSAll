/*!
 * File HPMSCameraAdaptee.cpp
 */

#include <core/HPMSCameraAdaptee.h>
#include <iostream>
#include <string>

std::string hpms::CameraAdaptee::GetName() const
{
    Check(ogreCamera);
    return ogreCamera->getName();
}

void hpms::CameraAdaptee::SetPosition(const glm::vec3 &position)
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        ogreCamera->getParentSceneNode()->setPosition(position.x, position.y, position.z);
    }
    else
    {
        LOG_ERROR("Direct camera manipulation has been removed because deprecated. You need to attach camera to a node");
        // ogreCamera->setPosition(position.x, position.y, position.z);
    }
}

glm::vec3 hpms::CameraAdaptee::GetPosition() const
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        auto ogrePos = ogreCamera->getParentSceneNode()->getPosition();
        return glm::vec3(ogrePos.x, ogrePos.y, ogrePos.z);
    }
    else
    {
        LOG_ERROR("Direct camera manipulation has been removed because deprecated. You need to attach camera to a node");
        // auto ogrePos = ogreCamera->getPosition();
        return glm::vec3();
    }
}

void hpms::CameraAdaptee::SetRotation(const glm::quat &rotation)
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode())
    {
        ogreCamera->getParentSceneNode()->setOrientation(rotation.w, rotation.x, rotation.y, rotation.z);
    }
    else
    {
        LOG_ERROR("Direct camera manipulation has been removed because deprecated. You need to attach camera to a node");
        // ogreCamera->setOrientation(Ogre::Quaternion(rotation.w, rotation.x, rotation.y, rotation.z));
    }
}

glm::quat hpms::CameraAdaptee::GetRotation() const
{
    Check(ogreCamera);
    if (ogreCamera->getParentSceneNode() != nullptr)
    {
        auto oQuatc = ogreCamera->getParentSceneNode()->getOrientation();
        return glm::quat(oQuatc.w, oQuatc.x, oQuatc.y, oQuatc.z);
    }
    else
    {
        LOG_ERROR("Direct camera manipulation has been removed because deprecated. You need to attach camera to a node");
        // auto oQuatc = ogreCamera->getOrientation();
        return glm::quat();
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
    }
    else
    {
        LOG_ERROR("Direct camera manipulation has been removed because deprecated. You need to attach camera to a node");
        // ogreCamera->lookAt(position.x, position.y, position.z);
    }
}

void hpms::CameraAdaptee::SetScale(const glm::vec3 &scale)
{
    // Not implemented.
}

glm::vec3 hpms::CameraAdaptee::GetScale() const
{
    return glm::vec3();
}

void hpms::CameraAdaptee::SetVisible(bool visible)
{
    // Not implemented.
}

bool hpms::CameraAdaptee::IsVisible() const
{
    return true;
}

Ogre::MovableObject *hpms::CameraAdaptee::GetNative()
{
    return ogreCamera;
}

hpms::CameraAdaptee::CameraAdaptee(hpms::OgreContext *ctx, const std::string &name) : AdapteeCommon(ctx)
{
    Check();
    ogreCamera = ctx->GetCamera();
    auto* cameraNode = ctx->GetSceneManager()->getRootSceneNode()->createChildSceneNode();
    cameraNode->attachObject(ogreCamera);
}

hpms::CameraAdaptee::~CameraAdaptee()
{
    Check();
    auto *cameraNode = ogreCamera->getParentSceneNode();
    if (cameraNode)
    {
        (ctx)->GetSceneManager()->destroySceneNode(cameraNode);
    }
    (ctx)->GetSceneManager()->destroyCamera(ogreCamera);
}
