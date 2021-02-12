/*!
 * File HPMSLightAdaptee.h
 */

#pragma once

#include <api/HPMSLightAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSCameraAdaptee.h>

namespace hpms
{
    class LightAdaptee : public LightAdapter, public AdapteeCommon
    {
    private:
        Ogre::Light* ogreLight;
    public:
        LightAdaptee(hpms::OgreContext* ctx);

        virtual ~LightAdaptee();
        
        virtual std::string GetName() override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() override;

        virtual void SetColor(const glm::vec3& rgb) override;
    };
}
