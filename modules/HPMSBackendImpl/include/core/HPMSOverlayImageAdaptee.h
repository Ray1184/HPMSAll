/*!
 * File HPMSOverlayImageAdaptee.h
 */

#pragma once

#include <api/HPMSOverlayImageAdapter.h>
#include <glm/gtc/quaternion.hpp>
#include <OgreOverlayContainer.h>
#include <OgreOverlayManager.h>
#include <OgreOverlay.h>
#include <core/HPMSMaterialHelper.h>
#include <map>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSAttachableItem.h>

namespace hpms
{
    class OverlayImageAdaptee : public OverlayImageAdapter, public AdapteeCommon
    {
    private:
        Ogre::OverlayContainer* ogrePanel;
        Ogre::Overlay* overlay;
        std::string name;
        bool enabled;
    public:
        OverlayImageAdaptee(const std::string& imagePath, int x, int y, int zOrder, OgreContext* ctx);

        virtual ~OverlayImageAdaptee();

        virtual std::string GetName() override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() const override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() const override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;

        virtual void SetBlending(BlendingType mode) override;

        virtual void Show() override;

        virtual void Hide() override;
    };
}

