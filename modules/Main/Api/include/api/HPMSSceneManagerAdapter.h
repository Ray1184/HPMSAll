/*!
 * File HPMSSceneManagerAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <glm/glm.hpp>
#include <api/HPMSSceneNodeAdapter.h>
#include <api/HPMSEntityAdapter.h>
#include <api/HPMSLightAdapter.h>

namespace hpms
{
    class SceneManagerAdapter : public hpms::Object
    {
    public:
        inline virtual const std::string Name() const override
        {
            return "SceneManagerAdapter";
        }

        inline virtual ~SceneManagerAdapter()
        {

        }

        virtual hpms::EntityAdapter* CreateEntity(const std::string& path) = 0;

        virtual hpms::SceneNodeAdapter* GetRootSceneNode() = 0;

        virtual hpms::LightAdapter* CreateLight() = 0;

        virtual void SetAmbientLight(const glm::vec3& rgb) = 0;
    };
}