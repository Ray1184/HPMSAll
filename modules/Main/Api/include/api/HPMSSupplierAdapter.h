/*!
 * File HPMSSupplierAdapter.h
 */

#pragma once

#include <api/HPMSEntityAdapter.h>
#include <api/HPMSSceneNodeAdapter.h>
#include <api/HPMSEntityAdapter.h>
#include <api/HPMSBackgroundImageAdapter.h>
#include <api/HPMSOverlayImageAdapter.h>
#include <api/HPMSOverlayTextAreaAdapter.h>
#include <api/HPMSCameraAdapter.h>
#include <api/HPMSLightAdapter.h>
#include <api/HPMSParticleAdapter.h>
#include <api/HPMSWalkmapAdapter.h>
#include <string>

namespace hpms
{


    struct WindowSettings
    {
        unsigned int width{320};
        unsigned int height{200};
        bool fullScreen{false};
        unsigned int pixelRatio{1};
        std::string name{"HPMS Template"};
    };

    class SupplierAdapter : public hpms::Object
    {
    public:

        inline virtual const std::string Name() const override
        {
            return "SupplierAdapter";
        }

        inline virtual ~SupplierAdapter()
        {

        }

        virtual std::string GetImplName() = 0;

        virtual hpms::EntityAdapter* CreateEntity(const std::string& path) = 0;

        virtual hpms::SceneNodeAdapter* GetRootSceneNode() = 0;

        virtual hpms::CameraAdapter* GetCamera() = 0;

        virtual hpms::LightAdapter* CreateLight(float r, float g, float b) = 0;

        virtual hpms::ParticleAdapter* CreateParticleSystem(const std::string& name, const std::string& templateName) = 0;

        virtual hpms::BackgroundImageAdapter* CreateBackgroundImage(const std::string& path) = 0;

        virtual hpms::OverlayImageAdapter* CreateOverlayImage(const std::string& path, int x,
                                                              int y, int zOrder) = 0;

        virtual hpms::OverlayTextAreaAdapter* CreateTextArea(const std::string& message, const std::string& fontName, float fontSize, int x,
                                                             int y, int width, int height, int zOrder) = 0;

        virtual void SetAmbientLight(const glm::vec3& rgb) = 0;

        virtual hpms::WalkmapAdapter* CreateWalkmap(const std::string& name) = 0;

        virtual void CleanupPending() = 0;

    };
}