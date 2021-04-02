/*!
 * File HPMSLightAdaptee.h
 */

#pragma once

#include <api/HPMSLightAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSCameraAdaptee.h>
#include <core/HPMSAttachableItem.h>

namespace hpms
{
    class LightAdaptee : public LightAdapter, public AdapteeCommon, public AttachableItem
    {
    private:
        Ogre::Light* ogreLight;
    public:
        LightAdaptee(hpms::OgreContext* ctx);

        virtual ~LightAdaptee();
        
        virtual std::string GetName() override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() const override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() const override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;

        virtual void SetColor(const glm::vec3& rgb) override;

        virtual Ogre::MovableObject* GetNative() override;
    };
}
