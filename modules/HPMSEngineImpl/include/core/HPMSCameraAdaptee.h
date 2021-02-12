/*!
 * File HPMSCameraAdaptee.h
 */

#pragma once

#include <api/HPMSCameraAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSOgreContext.h>
#include <glm/gtc/quaternion.hpp>

namespace hpms
{
    class CameraAdaptee : public hpms::CameraAdapter, public AdapteeCommon
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

        virtual void SetNear(float near) override;

        virtual void SetFar(float far) override;

        virtual void SetFovY(float fovY) override;

        virtual void LookAt(glm::vec3 pos) override;

    };
}
