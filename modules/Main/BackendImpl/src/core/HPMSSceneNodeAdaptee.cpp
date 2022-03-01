/*!
 * File HPMSSceneNodeAdaptee.cpp
 */

#include <core/HPMSSceneNodeAdaptee.h>
#include <core/HPMSEntityAdaptee.h>
#include <core/HPMSBackgroundImageAdaptee.h>

std::string hpms::SceneNodeAdaptee::GetName() const
{
    Check(ogreNode);
    return ogreNode->getName();
}

void hpms::SceneNodeAdaptee::SetPosition(const glm::vec3& position)
{
    Check(ogreNode);
    ogreNode->setPosition(position.x, position.y, position.z);
}

glm::vec3 hpms::SceneNodeAdaptee::GetPosition() const
{
    Check(ogreNode);
    auto oVec = ogreNode->getPosition();
    return glm::vec3(oVec.x, oVec.y, oVec.z);
}

void hpms::SceneNodeAdaptee::SetRotation(const glm::quat& rot)
{
    Check(ogreNode);
    ogreNode->setOrientation(rot.w, rot.x, rot.y, rot.z);
}

glm::quat hpms::SceneNodeAdaptee::GetRotation() const
{
    Check(ogreNode);
    auto oQuatc = ogreNode->getOrientation();
    return glm::quat(oQuatc.w, oQuatc.x, oQuatc.y, oQuatc.z);
}

void hpms::SceneNodeAdaptee::SetScale(const glm::vec3& scale)
{
    Check(ogreNode);
    ogreNode->setScale(scale.x, scale.y, scale.z);
}

glm::vec3 hpms::SceneNodeAdaptee::GetScale() const
{
    Check(ogreNode);
    auto oVec = ogreNode->getScale();
    return glm::vec3(oVec.x, oVec.y, oVec.z);
}

void hpms::SceneNodeAdaptee::SetVisible(bool visible)
{
    // Nothing to do.
}

bool hpms::SceneNodeAdaptee::IsVisible() const
{
    return true;
}


hpms::SceneNodeAdapter* hpms::SceneNodeAdaptee::CreateChild(const std::string& name)
{
    Check(ogreNode);
    if (ctx->GetSceneManager()->hasSceneNode(name))
    {
        auto* rawChildNode = dynamic_cast<Ogre::SceneNode*>(ogreNode->getChild(name));
        auto* childNodeAdaptee = hpms::SafeNew<hpms::SceneNodeAdaptee>(ctx, rawChildNode, name, this);
        return childNodeAdaptee;
    }
    auto* rawChildNode = ogreNode->createChildSceneNode(name);
    auto* childNodeAdaptee = hpms::SafeNew<hpms::SceneNodeAdaptee>(ctx, rawChildNode, name, this);
    return childNodeAdaptee;
}

void hpms::SceneNodeAdaptee::AttachObject(hpms::ActorAdapter* actor)
{
    Check(ogreNode);
    if (auto* a = dynamic_cast<AttachableItem*>(actor))
    {
        ogreNode->attachObject(a->GetNative());
        if (auto* e = dynamic_cast<EntityAdaptee*>(actor))
        {
            allAttachedEntities.push_back(e);
            allAttachedEntitiesInTree.push_back(e);
            auto* currParent = parent;
            while (currParent)
            {
                std::vector<EntityAdapter*> entitiesInTree = currParent->GetAttachedEntitiesInTree();
                entitiesInTree.push_back(e);
                currParent = parent->GetParent();
            }
        }

    }


}

void hpms::SceneNodeAdaptee::DetachObject(hpms::ActorAdapter* actor)
{
    Check(ogreNode);
    if (auto* a = dynamic_cast<AttachableItem*>(actor))
    {
        ogreNode->detachObject(a->GetNative());
        if (auto* e = dynamic_cast<EntityAdaptee*>(actor))
        {
            auto it = std::find(allAttachedEntities.begin(), allAttachedEntities.end(), e);
            auto itTree = std::find(allAttachedEntitiesInTree.begin(), allAttachedEntitiesInTree.end(), e);
            if (it != allAttachedEntities.end())
            {
                allAttachedEntities.erase(it);
            }

            if (itTree != allAttachedEntities.end())
            {
                allAttachedEntities.erase(itTree);
            }

            auto* currParent = parent;
            while (currParent)
            {
                std::vector<EntityAdapter*> parentEntitesTree = currParent->GetAttachedEntitiesInTree();
                auto itTreeParent = std::find(parentEntitesTree.begin(), parentEntitesTree.end(), e);
                if (itTreeParent != parentEntitesTree.end())
                {
                    parentEntitesTree.erase(it);
                }
                currParent = parent->GetParent();
            }
        }
    }

}


hpms::SceneNodeAdapter* hpms::SceneNodeAdaptee::RemoveChild(const std::string& name)
{
    Check(ogreNode);
    ogreNode->removeChild(name);
    return nullptr;
}


hpms::SceneNodeAdapter* hpms::SceneNodeAdaptee::GetParent()
{
    return parent;
}


hpms::SceneNodeAdaptee::SceneNodeAdaptee(hpms::OgreContext* ctx, const std::string& name) : AdapteeCommon(ctx), parent(nullptr)
{
    HPMS_ASSERT(ctx->GetSceneManager(), "Scene manager cannot be null");
    ogreNode = ctx->GetSceneManager()->getRootSceneNode()->createChildSceneNode(name);
}

hpms::SceneNodeAdaptee::SceneNodeAdaptee(hpms::OgreContext* ctx, Ogre::SceneNode* ogreSceneNode, const std::string& name, SceneNodeAdapter* parent, bool root)
        : AdapteeCommon(ctx),
          ogreNode(ogreSceneNode),
          parent(parent),
          root(root)
{
}

hpms::SceneNodeAdaptee::~SceneNodeAdaptee()
{
    Check();
    if (!root)
    {
        (ctx)->GetSceneManager()->destroySceneNode(ogreNode);
    }
}

std::vector<hpms::EntityAdapter*> hpms::SceneNodeAdaptee::GetAttachedEntities()
{
    return allAttachedEntities;
}

std::vector<hpms::EntityAdapter*> hpms::SceneNodeAdaptee::GetAttachedEntitiesInTree()
{
    return allAttachedEntitiesInTree;
}

Ogre::SceneNode* hpms::SceneNodeAdaptee::GetNativeNode()
{
    return ogreNode;
}

