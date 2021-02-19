/*!
 * File HPMSSupplierAdaptee.h
 */

#pragma once

#include <api/HPMSSupplierAdapter.h>
#include <core/HPMSCameraAdaptee.h>
#include <core/HPMSLightAdaptee.h>
#include <core/HPMSEntityAdaptee.h>
#include <core/HPMSSceneNodeAdaptee.h>
#include <vector>

namespace hpms
{
    class SupplierAdaptee : public hpms::SupplierAdapter, public AdapteeCommon
    {
    private:

        std::vector<EntityAdapter*> entities;
        SceneNodeAdapter* rootNode;
        CameraAdapter* camera;

    public:
        explicit SupplierAdaptee(hpms::OgreContext* ctx);

        virtual ~SupplierAdaptee();

        virtual EntityAdapter* CreateEntity(const std::string& path) override;

        virtual SceneNodeAdapter* GetRootSceneNode() override;

        virtual hpms::CameraAdapter* GetCamera() override;

        virtual hpms::LightAdapter* CreateLight(float r, float g, float b) override;

        virtual BackgroundImageAdapter*
        CreateBackgroundImage(const std::string& path, unsigned int width, unsigned int height) override;

        virtual OverlayImageAdapter*
        CreateOverlayImage(const std::string& path, unsigned int width, unsigned int height, unsigned int x,
                           unsigned int y, int zOrder) override;

        virtual void SetAmbientLight(const glm::vec3& rgb) override;

        virtual WalkmapAdapter* CreateWalkmap(const std::string& name) override;

        virtual std::string GetImplName() override;

    };
}