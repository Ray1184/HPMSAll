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
    Check(ogrePanel);
    int z = (int) ogrePanel->getZOrder();
    ogrePanel->setPosition(position.x, position.y);
    if (z != (int) position.z)
    {
        std::string newOverlayName = "Overlay_" + std::to_string((int) position.z);
        std::string oldOverlayName = "Overlay_" + std::to_string(z);
        Ogre::OverlayManager& overlayManager = Ogre::OverlayManager::getSingleton();
        Ogre::Overlay* newOverlay = overlayManager.create(newOverlayName);
        Ogre::Overlay* oldOverlay = overlayManager.create(oldOverlayName);
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
            hpms::MaterialHelper::SetMaterialTextureAddMode(ogrePanel->getMaterial());
    }
}

hpms::OverlayImageAdaptee::OverlayImageAdaptee(const std::string& imagePath, unsigned int width, unsigned int height,
                                               unsigned int x, unsigned int y, int zOrder) : name(imagePath),
                                                                                             AdapteeCommon(nullptr)
{
    Ogre::OverlayManager& overlayManager = Ogre::OverlayManager::getSingleton();
    ogrePanel = dynamic_cast<Ogre::OverlayContainer*>(overlayManager.createOverlayElement("Panel",
                                                                                          imagePath));
    panelImage.load(imagePath, Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
    auto material = hpms::MaterialHelper::CreateTexturedMaterial(panelImage, width, height);
    ogrePanel->setMaterial(material);
    ogrePanel->setPosition(x, y);
    ogrePanel->setDimensions(width, height);
    ogrePanel->setMetricsMode(Ogre::GMM_PIXELS);
    std::string overlayName = "Overlay_" + std::to_string(zOrder);
    Ogre::Overlay* overlay = overlayManager.create(overlayName);
    overlay->setZOrder(zOrder);
    overlay->add2D(ogrePanel);
    overlay->show();

}

hpms::OverlayImageAdaptee::~OverlayImageAdaptee()
{
    panelImage.freeMemory();
}
