/*!
 * File HPMSCameraAdaptee.h
 */

#pragma once

#include <api/HPMSCameraAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSOgreContext.h>
#include <core/HPMSAttachableItem.h>
#include <glm/gtc/quaternion.hpp>

namespace hpms
{
    class CameraAdaptee : public hpms::CameraAdapter, public AdapteeCommon, public AttachableItem
    {
    private:
        Ogre::Camera* ogreCamera;
    public:
        CameraAdaptee(hpms::OgreContext* ctx, const std::string& name);

        virtual ~CameraAdaptee();

        virtual void SetPosition(const glm::vec3& position) override;

        virtual  glm::vec3 GetPosition()  override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual  glm::quat GetRotation()  override;

        virtual std::string GetName() override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() override;

        virtual void SetNear(float near) override;

        virtual void SetFar(float far) override;

        virtual void SetFovY(float fovY) override;

        virtual void LookAt(glm::vec3 pos) override;

        virtual Ogre::MovableObject* GetNative() override;

    };
}
