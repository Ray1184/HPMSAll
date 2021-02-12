/*!
 * File HPMSLightAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>

namespace hpms
{
    class LightAdapter : public hpms::ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "LightAdapter";
        }

        inline virtual ~LightAdapter()
        {

        }

        virtual void SetColor(const glm::vec3& rgb) = 0;

    };
}