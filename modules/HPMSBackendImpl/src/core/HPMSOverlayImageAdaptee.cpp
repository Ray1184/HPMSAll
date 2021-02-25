/*!
 * File HPMSOverlayImageAdaptee.cpp
 */

#include <core/HPMSOverlayImageAdaptee.h>


std::string hpms::OverlayImageAdaptee::GetName()
{
    return name;
}

void hpms::OverlayImageAdaptee::SetPosition(const glm::vec3& position)
{
    Check();
    Check(ogrePanel);
    int z = (int) ogrePanel->getZOrder();
    ogrePanel->setPosition(position.x, position.y);
    if (z != (int) position.z)
    {
        std::string newOverlayName = "Overlay_" + std::to_string((int) position.z);
        std::string oldOverlayName = "Overlay_" + std::to_string(z);
        Ogre::OverlayManager* overlayManager = ctx->GetOverlayManager();
        Ogre::Overlay* newOverlay = overlayManager->create(newOverlayName);
        Ogre::Overlay* oldOverlay = overlayManager->create(oldOverlayName);
        oldOverlay->remove2D(ogrePanel);
        newOverlay->setZOrder((int) position.z);
        newOverlay->add2D(ogrePanel);
        newOverlay->show();
    }


}

glm::vec3 hpms::OverlayImageAdaptee::GetPosition()
{
    return glm::vec3(ogrePanel->getLeft(), ogrePanel->getTop(), ogrePanel->getZOrder());
}

void hpms::OverlayImageAdaptee::SetRotation(const glm::quat& rotation)
{
    // Not implementend.
}

glm::quat hpms::OverlayImageAdaptee::GetRotation()
{
    // Not implementend.
    return glm::quat();
}

void hpms::OverlayImageAdaptee::SetScale(const glm::vec3& scale)
{
    // Not implementend.
}

glm::vec3 hpms::OverlayImageAdaptee::GetScale()
{
    // Not implementend.
    return glm::vec3();
}

void hpms::OverlayImageAdaptee::SetVisible(bool visible)
{
    Check(ogrePanel);
    ogrePanel->setEnabled(visible);

}

bool hpms::OverlayImageAdaptee::IsVisible()
{
    Check(ogrePanel);
    return ogrePanel->isEnabled();
}

void hpms::OverlayImageAdaptee::SetBlending(BlendingType mode)
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

void hpms::OverlayImageAdaptee::Show()
{
    Check();
    if (!enabled)
    {
        enabled = true;
        ogrePanel->show();
    }
}

void hpms::OverlayImageAdaptee::Hide()
{
    Check();
    if (enabled)
    {
        enabled = false;
        ogrePanel->hide();
    }
}
hpms::OverlayImageAdaptee::OverlayImageAdaptee(const std::string& imagePath, unsigned int x, unsigned int y, int zOrder, OgreContext* ctx) : name(imagePath),
                                                                                                                                             AdapteeCommon(ctx)
{
    Check();
    Ogre::OverlayManager* overlayManager = ctx->GetOverlayManager();
    ogrePanel = dynamic_cast<Ogre::OverlayContainer*>(overlayManager->createOverlayElement("Panel", "Overlay_" + imagePath));
    unsigned int width, height;
    auto material = hpms::MaterialHelper::CreateTexturedMaterial(imagePath, &width, &height);
    ogrePanel->setMaterial(material);
    ogrePanel->setPosition(x, y);
    unsigned int pixelation = ctx->GetSettings().pixelRatio;

    // NOTE: Overlay doesn't work well with RTT, so are excluded and pixelated manually (see HPMSRenderToTexture.cpp).
    ogrePanel->setDimensions(width * pixelation, height * pixelation);
    ogrePanel->setMetricsMode(Ogre::GMM_PIXELS);
    std::string overlayName = "Overlay_" + std::to_string(zOrder);
    Ogre::Overlay* overlay = overlayManager->create(overlayName);
    overlay->setZOrder(zOrder);
    overlay->add2D(ogrePanel);
    SetBlending(BlendingType::NORMAL);
    overlay->show();
    Hide();

}

hpms::OverlayImageAdaptee::~OverlayImageAdaptee()
{
}



