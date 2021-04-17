/*!
 * File HPMSLightAdaptee.cpp
 */

#include <core/HPMSLightAdaptee.h>

std::string hpms::LightAdaptee::GetName()
{
    Check();
    return ogreLight->getName();
}

void hpms::LightAdaptee::SetPosition(const glm::vec3& position)
{
    Check();
    if (ogreLight->getParentSceneNode() != nullptr)
    {
        ogreLight->getParentSceneNode()->setPosition(position.x, position.y, position.z);
    } else
    {
        ogreLight->setPosition(position.x, position.y, position.z);
    }
}

glm::vec3 hpms::LightAdaptee::GetPosition() const
{
    return glm::vec3();
}

void hpms::LightAdaptee::SetRotation(const glm::quat& rotation)
{
    // Not implemented.
}

glm::quat hpms::LightAdaptee::GetRotation() const
{
    return glm::quat();
}

void hpms::LightAdaptee::SetScale(const glm::vec3& scale)
{
    // Not implemented.
}

glm::vec3 hpms::LightAdaptee::GetScale() const
{
    return glm::vec3();
}

void hpms::LightAdaptee::SetVisible(bool visible)
{
    Check();
    ogreLight->setVisible(visible);
}

bool hpms::LightAdaptee::IsVisible() const
{
    Check();
    return ogreLight->isVisible();
}

void hpms::LightAdaptee::SetColor(const glm::vec3& rgb)
{
    Check();
    ogreLight->setDiffuseColour(Ogre::ColourValue(rgb.x, rgb.y, rgb.z));
}

Ogre::MovableObject* hpms::LightAdaptee::GetNative()
{
    return ogreLight;
}

hpms::LightAdaptee::LightAdaptee(hpms::OgreContext* ctx) : AdapteeCommon(ctx)
{
    Check();
    ogreLight = (ctx)->GetSceneManager()->createLight();
}

hpms::LightAdaptee::~LightAdaptee()
{
    Check();
    (ctx)->GetSceneManager()->destroyLight(ogreLight);
}


