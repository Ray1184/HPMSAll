/*!
 * File HPMSOverlayImageAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSImageAdapter.h>
#include <api/HPMSSceneNodeAdapter.h>
namespace hpms
{

    class OverlayImageAdapter : public ActorAdapter, public ImageAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "OverlayImageAdapter/" + GetName();
        }

        inline virtual ~OverlayImageAdapter()
        {

        }

        virtual void SetAlpha(float alpha) = 0;

        virtual void SetBlending(BlendingType mode) = 0;

        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;

        virtual void AddNode(hpms::SceneNodeAdapter* node) = 0;

        virtual void RemoveNode(hpms::SceneNodeAdapter* node) = 0;

    };
}