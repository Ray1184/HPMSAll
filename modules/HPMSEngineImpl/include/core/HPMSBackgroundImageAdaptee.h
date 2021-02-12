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

namespace hpms
{
    class BackgroundImageAdaptee : public BackgroundImageAdapter, public AdapteeCommon
    {
    private:
        Ogre::Rectangle2D* ogreBackground;
        Ogre::Image backgroundImage;
        std::string name;

    public:
        BackgroundImageAdaptee(const std::string& imagePath, unsigned int width, unsigned int height);

        virtual ~BackgroundImageAdaptee();

        virtual std::string GetName() override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() override;
    };
}
