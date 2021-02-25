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
            return "CameraAdapter";
        }

        inline virtual ~CameraAdapter()
        {

        }

        virtual void SetNear(float near) = 0;

        virtual void SetFar(float far) = 0;

        virtual void SetFovY(float fovY) = 0;

        virtual void LookAt(glm::vec3 pos) = 0;



    };
}