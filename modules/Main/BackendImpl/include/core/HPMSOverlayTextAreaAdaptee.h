/*!
 * File HPMSOverlayTextAreaAdaptee.h
 */

#pragma once

#include <api/HPMSOverlayTextAreaAdapter.h>
#include <glm/gtc/quaternion.hpp>
#include <OgreOverlayContainer.h>
#include <OgreOverlayManager.h>
#include <OgreOverlay.h>
#include <OgreTextAreaOverlayElement.h>
#include <core/HPMSMaterialHelper.h>
#include <map>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSAttachableItem.h>
#include <core/HPMSOverlayImageAdaptee.h>

namespace hpms
{

    class OverlayTextAreaAdaptee : public OverlayTextAreaAdapter, public AdapteeCommon
    {
    private:
        Ogre::OverlayContainer* ogrePanel;
        Ogre::TextAreaOverlayElement* textArea;
        Ogre::Overlay* overlay;
        std::string name;
        bool enabled;
    public:
        
        OverlayTextAreaAdaptee(const std::string& boxName, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder, OgreContext* ctx);

        virtual ~OverlayTextAreaAdaptee();

        virtual std::string GetName() const override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() const override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() const override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;

        virtual void Show() override;

        virtual void Hide() override;

        virtual void SetText(const std::string& message) override;

        virtual void SetFont(const std::string& fontName) override;

        virtual void SetFontSize(float fontSize) override;

        virtual void SetBlending(BlendingType mode) override;

        virtual void SetColor(const glm::vec4& color) override;

        virtual glm::vec4 GetColor() const override;

        virtual std::string SetText(const std::string& text, int maxWidth, unsigned int maxLines) override;

        std::string ProcessLine(const std::string& text, float maxWidth, const Ogre::FontPtr& font, unsigned int* finished);

        void SetCaptionSafe(const std::string& text);


    };
}