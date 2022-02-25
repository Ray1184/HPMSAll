/*!
 * File HPMSGuiText.h
 */

#include <logic/gui/HPMSGuiText.h>

hpms::GuiText::GuiText(const std::string& boxName, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder, const glm::vec4& color) : width(width)
{
    textArea = hpms::GetSupplier()->CreateTextArea(boxName, fontName, fontSize, x, y, width, height, zOrder);
    textArea->SetColor(color);
}

hpms::GuiText::~GuiText()
{
    hpms::SafeDelete(textArea);
}

void hpms::GuiText::SetText(const std::string& text)
{
    textArea->SetText(text);
}

std::string hpms::GuiText::DrawTextStream(const std::string& text, unsigned int maxLines)
{
    return textArea->SetText(text, width, maxLines);
}

void hpms::GuiText::SetPosition(const glm::vec3& position)
{
    textArea->SetPosition(position);
}

glm::vec3 hpms::GuiText::GetPosition() const
{
    return glm::vec3();
}

void hpms::GuiText::SetVisible(bool visible)
{
    if (visible)
    {
        textArea->Show();
    } 
    else
    {
        textArea->Hide();
    }
}

bool hpms::GuiText::IsVisible() const
{
    return textArea->IsVisible();
}

void hpms::GuiText::SetColor(const glm::vec4& color)
{

}




