/*!
 * File HPMSParticleAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>

namespace hpms
{
    class ParticleAdapter : public hpms::ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "ParticleAdapter/" + GetName();
        }

        inline virtual ~ParticleAdapter()
        {

        }


        virtual void SetPosition(const glm::vec3& position) override = 0;

        virtual glm::vec3 GetPosition() const override = 0;

        virtual void SetRotation(const glm::quat& rotation) override = 0;

        virtual glm::quat GetRotation() const override = 0;

        virtual void SetScale(const glm::vec3& scale) override = 0;

        virtual glm::vec3 GetScale() const override = 0;

        virtual void SetVisible(bool visible) override = 0;

        virtual bool IsVisible() const override = 0;

        virtual void Emit(bool flag) = 0;

        virtual void GoToTime(float time) = 0;

        virtual void InitAnimatedParticle(const std::string& textureBaseName) = 0;

        virtual void UpdateNoLoopAnimatedParticle(const std::string& textureBaseName) = 0;

    };
}