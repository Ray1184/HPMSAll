/*!
 * File HPMSSceneNodeAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSEntityAdapter.h>
#include <vector>

namespace hpms
{
    class SceneNodeAdapter : public hpms::ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "SceneNodeAdapter";
        }

        inline virtual ~SceneNodeAdapter()
        {

        }

        virtual SceneNodeAdapter* CreateChild(const std::string& name) = 0;

        virtual void AttachObject(ActorAdapter* actor) = 0;

        virtual void DetachObject(ActorAdapter* actor) = 0;

        virtual SceneNodeAdapter* RemoveChild(const std::string& name) = 0;

        virtual SceneNodeAdapter* GetParent() = 0;

        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;

        virtual std::vector<EntityAdapter*> GetAttachedEntities() = 0;

        virtual std::vector<EntityAdapter*> GetAttachedEntitiesInTree() = 0;
    };
}