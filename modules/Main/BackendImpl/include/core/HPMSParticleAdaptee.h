/*!
 * File HPMSParticleAdaptee.h
 */

#pragma once

#include <api/HPMSParticleAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSCameraAdaptee.h>
#include <core/HPMSAttachableItem.h>

namespace hpms
{
    class ParticleAdaptee : public ParticleAdapter, public AdapteeCommon, public AttachableItem
    {
    private:
        Ogre::ParticleSystem* ogrePS;
        Ogre::MaterialPtr instanceMaterial;
        bool createNode;
    public:
        ParticleAdaptee(hpms::OgreContext* ctx, const std::string& name, const std::string& templateName);

        virtual ~ParticleAdaptee();
        
        virtual std::string GetName() const override;

        virtual void SetPosition(const glm::vec3& position) override;

        virtual glm::vec3 GetPosition() const override;

        virtual void SetRotation(const glm::quat& rotation) override;

        virtual glm::quat GetRotation() const override;

        virtual void SetScale(const glm::vec3& scale) override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;

        virtual void Emit(bool flag) override;

        virtual void GoToTime(float time) override;

        virtual Ogre::MovableObject* GetNative() override;

        virtual void InitAnimatedParticle(const std::string& textureBaseName) override;

        virtual void UpdateNoLoopAnimatedParticle(const std::string& textureBaseName) override;
    };
}
