/*!
 * File HPMSOverlayTextAreaAdaptee.cpp
 */

#include <core/HPMSOverlayTextAreaAdaptee.h>
#include <OgreFontManager.h>
#include <iostream>

#define CODE_FINISHED 0
#define CODE_WORKING 1

std::string hpms::OverlayTextAreaAdaptee::GetName() const
{
    return name;
}

void hpms::OverlayTextAreaAdaptee::SetPosition(const glm::vec3& position)
{
    Check();
    Check(ogrePanel);
    int z = (int) ogrePanel->getZOrder();
    ogrePanel->setPosition(position.x, position.y);
    if (z != (int) position.z)
    {

        overlay->setZOrder((unsigned int) position.z);
    }


}

glm::vec3 hpms::OverlayTextAreaAdaptee::GetPosition() const
{
    return glm::vec3(ogrePanel->getLeft(), ogrePanel->getTop(), ogrePanel->getZOrder());
}

void hpms::OverlayTextAreaAdaptee::SetRotation(const glm::quat& rotation)
{
    // Not implementend.
}

glm::quat hpms::OverlayTextAreaAdaptee::GetRotation() const
{
    // Not implementend.
    return glm::quat();
}

void hpms::OverlayTextAreaAdaptee::SetScale(const glm::vec3& scale)
{
    // Not implementend.
}

glm::vec3 hpms::OverlayTextAreaAdaptee::GetScale() const
{
    // Not implementend.
    return glm::vec3();
}

void hpms::OverlayTextAreaAdaptee::SetVisible(bool visible)
{
    Check(ogrePanel);
    ogrePanel->setEnabled(visible);

}

bool hpms::OverlayTextAreaAdaptee::IsVisible() const
{
    Check(ogrePanel);
    return ogrePanel->isEnabled();
}

void hpms::OverlayTextAreaAdaptee::SetBlending(BlendingType mode)
{
    switch (mode)
    {
        case BlendingType::OVERLAY:
            hpms::MaterialHelper::SetMaterialTextureAddMode(ogrePanel->getMaterial());
            break;
        default:
            hpms::MaterialHelper::SetMaterialTextureStandardMode(ogrePanel->getMaterial());
    }
}

void hpms::OverlayTextAreaAdaptee::Show()
{
    Check();
    if (!enabled)
    {
        enabled = true;
        ogrePanel->show();
    }
}

void hpms::OverlayTextAreaAdaptee::Hide()
{
    Check();
    if (enabled)
    {
        enabled = false;
        ogrePanel->hide();
    }
}

void hpms::OverlayTextAreaAdaptee::SetText(const std::string& message)
{
    Check();
    SetCaptionSafe(message);
}

void hpms::OverlayTextAreaAdaptee::SetColor(const glm::vec4& color)
{
    Check();
    textArea->setColour(Ogre::ColourValue(color.x, color.y, color.z, color.w));
}


void hpms::OverlayTextAreaAdaptee::SetFont(const std::string& fontName)
{
    // Not implemented.
}

void hpms::OverlayTextAreaAdaptee::SetFontSize(float fontSize)
{
    // Not implemented.
}

std::string hpms::OverlayTextAreaAdaptee::SetText(const std::string& text, int maxWidth, unsigned int maxLines)
{
    Check();


    auto font = textArea->getFont();
    std::stringstream textBuffer;
    std::stringstream finalBuffer;

    unsigned int code = CODE_WORKING;
    unsigned int lines = 0;

    std::string textToProcess = text;
    while (code == CODE_WORKING && lines < maxLines)
    {
        std::string token = ProcessLine(textToProcess, maxWidth, font, &code);
        textToProcess = textToProcess.substr(token.length(), textToProcess.length() - 1);
        finalBuffer << hpms::Trim(token) << "\n";
        lines++;
    }
    std::string finalText = finalBuffer.str();
    SetCaptionSafe(finalText);
    return textToProcess;


}

std::string hpms::OverlayTextAreaAdaptee::ProcessLine(const std::string& text, float maxWidth, const Ogre::FontPtr& font, unsigned int* finished)
{
    std::stringstream sub;
    std::stringstream tmpSub;
    float textWidth = 0;
    for (char i : text)
    {
        if (textWidth >= maxWidth)
        {
            *finished = CODE_WORKING;
            return sub.str();
        }
        if (i == 0x0020)
        {
            textWidth += font->getGlyphAspectRatio(0x0030) * textArea->getCharHeight();
            sub << tmpSub.str();
            tmpSub.str("");
            tmpSub << " ";

        } else
        {
            textWidth += font->getGlyphAspectRatio(i) * textArea->getCharHeight();
            tmpSub << i;
        }
    }
    *finished = CODE_FINISHED;
    sub << tmpSub.str();
    return sub.str();
}


hpms::OverlayTextAreaAdaptee::OverlayTextAreaAdaptee(const std::string& boxName, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder, hpms::OgreContext* ctx) : name(boxName),
                                                                                                                                                                                                         AdapteeCommon(ctx),
                                                                                                                                                                                                         ogrePanel(nullptr),
                                                                                                                                                                                                         overlay(nullptr)
{
    Check();
    std::string name = boxName + "_" + std::to_string(x) + std::to_string(y) + std::to_string(zOrder);
    Ogre::OverlayManager* overlayManager = ctx->GetOverlayManager();
    overlay = overlayManager->getByName("OverlayText_" + name);
    if (overlay == nullptr)
    {
        overlay = overlayManager->create("OverlayText_" + name);


        ogrePanel = dynamic_cast<Ogre::OverlayContainer*>(overlayManager->createOverlayElement("Panel", "OverlayElementText_" + name));
        auto material = hpms::MaterialHelper::CreateGuiMaterial();
        ogrePanel->setMetricsMode(Ogre::GMM_PIXELS);
        ogrePanel->setPosition(x, y);
        ogrePanel->setDimensions(width, height);
        ogrePanel->setMaterial(material);


        textArea = dynamic_cast<Ogre::TextAreaOverlayElement*>(overlayManager->createOverlayElement("TextArea", "OverlayElementTextArea_" + name));
        textArea->setMetricsMode(Ogre::GMM_PIXELS);
        textArea->setPosition(0, 0);
        textArea->setDimensions(width, height);
        textArea->setCharHeight(fontSize);
        textArea->setColour(Ogre::ColourValue(1.0, 1.0, 1.0));
        textArea->setFontName(fontName);

        // Default material texture filtering is ignored for text area overlays, force here.
        textArea->getMaterial()->setTextureFiltering(Ogre::TextureFilterOptions::TFO_NONE);
        ogrePanel->addChild(textArea);
        overlay->add2D(ogrePanel);
    } else
    {
        ogrePanel = overlay->getChild("OverlayElementText_" + name);
        textArea = dynamic_cast<Ogre::TextAreaOverlayElement*>(ogrePanel->getChild("OverlayElementTextArea_" + name));
    }
    ogrePanel->show();
    textArea->show();
    overlay->setZOrder(zOrder);
    SetBlending(BlendingType::NORMAL);
    overlay->show();

}

hpms::OverlayTextAreaAdaptee::~OverlayTextAreaAdaptee()
{
    overlay->hide();
    ogrePanel->hide();
    textArea->setCaption("");
    textArea->hide();
}

void hpms::OverlayTextAreaAdaptee::SetCaptionSafe(const std::string& text)
{
    Check();
    hpms::ReplaceAll(text, "ograve;", "\u00A2");
    textArea->setCaption(text);
}


