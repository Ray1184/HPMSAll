/*!
 * File HPMSSceneNodeAdaptee.h
 */


#pragma once

#include <api/HPMSSceneNodeAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSEntityAdaptee.h>
#include <common/HPMSUtils.h>
#include <glm/glm.hpp>
#include <glm/gtc/quaternion.hpp>
#include <Ogre.h>
#include <core/HPMSOgreContext.h>
#include <vector>

namespace hpms
{
	class SceneNodeAdaptee : public SceneNodeAdapter, public AdapteeCommon 
	{
	private:
		Ogre::SceneNode* ogreNode;
		SceneNodeAdapter* parent;
		std::vector<hpms::EntityAdapter*> allAttachedEntities;
		std::vector<hpms::EntityAdapter*> allAttachedEntitiesInTree;

		bool root;

	public:
		SceneNodeAdaptee(hpms::OgreContext* ctx, const std::string& name);

		SceneNodeAdaptee(hpms::OgreContext* ctx, Ogre::SceneNode* ogreSceneNode, const std::string& name, SceneNodeAdapter* parent, bool root = false);

		virtual ~SceneNodeAdaptee();

		std::string GetName() const override;

		void SetPosition(const glm::vec3& position) override;

		glm::vec3 GetPosition() const override;

		void SetRotation(const glm::quat& rotation) override;

		glm::quat GetRotation() const override;

		void SetScale(const glm::vec3& scale) override;

		glm::vec3 GetScale() const override;

		void SetVisible(bool visible) override;

		bool IsVisible() const override;

		virtual SceneNodeAdapter* CreateChild(const std::string& name) override;

		virtual void AttachObject(ActorAdapter* actor) override;

		virtual void DetachObject(ActorAdapter* actor) override;

		virtual SceneNodeAdapter* RemoveChild(const std::string& name) override;

		virtual SceneNodeAdapter* GetParent() override;		

		virtual std::vector<EntityAdapter*> GetAttachedEntities() override;

		virtual std::vector<EntityAdapter*> GetAttachedEntitiesInTree() override;

		virtual Ogre::SceneNode* GetNativeNode();

	};
}
