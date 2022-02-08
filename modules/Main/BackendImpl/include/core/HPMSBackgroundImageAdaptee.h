/*!
 * File HPMSBackgroundImageAdaptee.h
 */

#pragma once

#include <api/HPMSBackgroundImageAdapter.h>
#include <glm/gtc/quaternion.hpp>
#include <Ogre.h>
#include <OgreRectangle2D.h>
#include <core/HPMSMaterialHelper.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSAttachableItem.h>

namespace hpms
{
    class BackgroundImageAdaptee : public BackgroundImageAdapter, public AdapteeCommon
    {
    private:
        Ogre::Rectangle2D* ogreBackground;
        std::string name;
        bool enabled;

    public:
        BackgroundImageAdaptee(const std::string& imagePath, OgreContext* ctx);

        virtual ~BackgroundImageAdaptee();

        virtual std::string GetName() const override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() const override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() const override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;

        virtual void Show() override;

        virtual void Hide() override;
    };
}
