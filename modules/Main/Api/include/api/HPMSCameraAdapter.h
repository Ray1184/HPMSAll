/*!
 * File HPMSCameraAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>

namespace hpms
{
    class CameraAdapter : public ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "CameraAdapter/" + GetName();
        }

        inline virtual ~CameraAdapter()
        {

        }

        inline float GetNear() const {
            // Not used.
            return 0.0;
        }

        inline float GetFar() const {
            // Not used.
            return 0.0;
        }

        inline float GetFovY() const {
            // Not used.
            return 0.0;
        }

        virtual void SetNear(float near) = 0;

        virtual void SetFar(float far) = 0;

        virtual void SetFovY(float fovY) = 0;

        virtual void LookAt(glm::vec3 pos) = 0;

        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;

    };
}