/*!
 * File HPMSOverlayTextAreaAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSImageAdapter.h>
namespace hpms
{

    class OverlayTextAreaAdapter : public ActorAdapter, public ImageAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "OverlayTextAreaAdapter/" + GetName();
        }

        inline virtual ~OverlayTextAreaAdapter()
        {

        }

        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;

        virtual void SetText(const std::string& message) = 0;

        virtual void SetColor(const glm::vec4& color) = 0;

        virtual std::string SetText(const std::string& text, int maxWidth, unsigned int maxLines) = 0;

        inline std::string GetText() const {
            // Not used.
            return std::string();
        }

        inline glm::vec4 GetColor() const {
            // Not used.
            return glm::vec4();
        }

        virtual void SetFont(const std::string& fontName) = 0;

        virtual void SetFontSize(float fontSize) = 0;

        virtual void SetBlending(BlendingType mode) = 0;

    };


}