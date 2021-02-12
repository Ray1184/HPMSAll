/*!
 * File HPMSCameraAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>

namespace hpms
{
    class CameraAdapter : public Object
    {
    public:
        inline const std::string Name() const override
        {
            return "CameraAdapter";
        }

        inline virtual ~CameraAdapter()
        {

        }

        virtual void SetPosition(const glm::vec3& position) = 0;

        virtual glm::vec3 GetPosition() = 0;

        virtual void SetRotation(const glm::quat& rotation) = 0;

        virtual glm::quat GetRotation() = 0;

        virtual void SetNear(float near) = 0;

        virtual void SetFar(float far) = 0;

        virtual void SetFovY(float fovY) = 0;

        virtual void LookAt(glm::vec3 pos) = 0;

    };
}