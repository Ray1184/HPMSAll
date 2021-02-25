/*!
 * File HPMSBackgroundImageAdaptee.cpp
 */

#include <core/HPMSBackgroundImageAdaptee.h>
#include <common/HPMSUtils.h>

std::string hpms::BackgroundImageAdaptee::GetName()
{
    return name;
}

void hpms::BackgroundImageAdaptee::SetPosition(const glm::vec3& position)
{
    // Not implementend.
}

glm::vec3 hpms::BackgroundImageAdaptee::GetPosition()
{
    return glm::vec3(0, 0, 0);
}

void hpms::BackgroundImageAdaptee::SetRotation(const glm::quat& rotation)
{
    // Not implementend.
}

glm::quat hpms::BackgroundImageAdaptee::GetRotation()
{
    // Not implementend.
    return glm::quat();
}

void hpms::BackgroundImageAdaptee::SetScale(const glm::vec3& scale)
{
    // Not implementend.
}

glm::vec3 hpms::BackgroundImageAdaptee::GetScale()
{
    // Not implementend.
    return glm::vec3();
}

void hpms::BackgroundImageAdaptee::SetVisible(bool visible)
{
    Check(ogreBackground);
    ogreBackground->setVisible(visible);
}

bool hpms::BackgroundImageAdaptee::IsVisible()
{
    Check(ogreBackground);
    return ogreBackground->getVisible();
}

void hpms::BackgroundImageAdaptee::Show()
{
    Check();
    if (!enabled)
    {
        enabled = true;
        ctx->GetSceneManager()->getRootSceneNode()->attachObject(ogreBackground);
    }
}

void hpms::BackgroundImageAdaptee::Hide()
{
    Check();
    if (enabled)
    {
        enabled = false;
        ctx->GetSceneManager()->getRootSceneNode()->detachObject(ogreBackground);
    }
}

hpms::BackgroundImageAdaptee::BackgroundImageAdaptee(const std::string& imagePath, OgreContext* ctx) : name(imagePath), AdapteeCommon(ctx), enabled(false)
{
    auto backgroundMaterial = hpms::MaterialHelper::CreateTexturedMaterial(imagePath);
    ogreBackground = hpms::SafeNewRaw<Ogre::Rectangle2D>(true);
    ogreBackground->setCorners(-1.0, 1.0, 1.0, -1.0);
    ogreBackground->setMaterial(backgroundMaterial);
    ogreBackground->setRenderQueueGroup(Ogre::RENDER_QUEUE_BACKGROUND);
    Hide();
}


hpms::BackgroundImageAdaptee::~BackgroundImageAdaptee()
{
    hpms::SafeDeleteRaw(ogreBackground);
}




