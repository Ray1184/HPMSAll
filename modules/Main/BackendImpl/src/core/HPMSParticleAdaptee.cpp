/*!
 * File HPMSParticleAdaptee.cpp
 */

#include <core/HPMSParticleAdaptee.h>

std::string hpms::ParticleAdaptee::GetName() const
{
    Check();
    return ogrePS->getName();
}

void hpms::ParticleAdaptee::SetPosition(const glm::vec3& position)
{
    Check();
    if (ogrePS->getParentSceneNode() != nullptr)
    {
        ogrePS->getParentSceneNode()->setPosition(position.x, position.y, position.z);
    } else
    {
        LOG_ERROR("Direct particle system manipulation has been removed because deprecated. You need to attach particle system to a node");
        // ogrePS->setPosition(position.x, position.y, position.z);
    }
}

glm::vec3 hpms::ParticleAdaptee::GetPosition() const
{
    return glm::vec3();
}

void hpms::ParticleAdaptee::SetRotation(const glm::quat& rotation)
{
    // Not implemented.
}

glm::quat hpms::ParticleAdaptee::GetRotation() const
{
    return glm::quat();
}

void hpms::ParticleAdaptee::SetScale(const glm::vec3& scale)
{
    // Not implemented.
}

glm::vec3 hpms::ParticleAdaptee::GetScale() const
{
    return glm::vec3();
}

void hpms::ParticleAdaptee::SetVisible(bool visible)
{
    Check();
    ogrePS->setVisible(visible);
}

bool hpms::ParticleAdaptee::IsVisible() const
{
    Check();
    return ogrePS->isVisible();
}

Ogre::MovableObject* hpms::ParticleAdaptee::GetNative()
{
    return ogrePS;
}

void hpms::ParticleAdaptee::Emit(bool flag)
{
    Check();
    ogrePS->setEmitting(flag);
}

void hpms::ParticleAdaptee::GoToTime(float time)
{
    Check();
    ogrePS->fastForward(time);
}

hpms::ParticleAdaptee::ParticleAdaptee(hpms::OgreContext* ctx, const std::string& name, const std::string& templateName, bool createNode) : AdapteeCommon(ctx), createNode(createNode)
{
    Check();    
    ogrePS = (ctx)->GetSceneManager()->createParticleSystem(name, templateName);
    if (createNode)
    {
        auto* psNode = ctx->GetSceneManager()->getRootSceneNode()->createChildSceneNode();
        psNode->attachObject(ogrePS);
    }
}

hpms::ParticleAdaptee::~ParticleAdaptee()
{
    Check();
    if (createNode)
    {
        auto* psNode = ogrePS->getParentSceneNode();
        if (psNode)
        {
            (ctx)->GetSceneManager()->destroySceneNode(psNode);
        }
    }
    (ctx)->GetSceneManager()->destroyParticleSystem(ogrePS);
}


