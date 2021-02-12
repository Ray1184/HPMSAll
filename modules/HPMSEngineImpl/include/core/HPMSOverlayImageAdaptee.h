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

namespace hpms
{
    class OverlayImageAdaptee : public OverlayImageAdapter, public AdapteeCommon
    {
    private:
        Ogre::OverlayContainer* ogrePanel;
        Ogre::Image panelImage;
        std::string name;
    public:
        OverlayImageAdaptee(const std::string& imagePath, unsigned int width, unsigned int height, unsigned int x,
                            unsigned int y, int zOrder);

        virtual ~OverlayImageAdaptee();

        virtual std::string GetName() override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() override;

        virtual void SetBlending(BlendingType mode) override;
    };
}

