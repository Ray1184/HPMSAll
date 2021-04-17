/*!
 * File HPMSGuiText.h
 */

#pragma once

#include <facade/HPMSApiFacade.h>

namespace hpms
{
    class GuiText : public Object
    {
    private:
        OverlayTextAreaAdapter* textArea;
        int width;

    public:
        GuiText(const std::string& boxName, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder, const glm::vec4& color = glm::vec4(1.0, 1.0, 1.0, 1.0));

        virtual ~GuiText();

        void SetText(const std::string& text);

        std::string DrawTextStream(const std::string& text, unsigned int maxLines);

        void SetPosition(const glm::vec3& position);

        glm::vec3 GetPosition() const;

        void SetVisible(bool visible);

        bool IsVisible() const;

        void SetColor(const glm::vec4& color);

        inline std::string GetText() const {
            // Not used.
            return std::string();
        }

        inline glm::vec4 GetColor() const {
            // Not used.
            return glm::vec4();
        }

        inline const std::string Name() const override
        {
            return "GuiText";
        }



    };
}
