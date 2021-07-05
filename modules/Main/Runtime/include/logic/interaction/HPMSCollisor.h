/*!
 * File HPMSCollisor.h
 */

#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <api/HPMSActorAdapter.h>
#include <common/HPMSMathUtils.h>
#include <glm/gtx/perpendicular.hpp>
#include <logic/HPMSController.h>
#include <common/HPMSUtils.h>

#define VEC_FORWARD glm::vec3(0, 1, 0)

namespace hpms
{
    class Collisor : public ActorAdapter, public Controller
    {
    private:
        hpms::ActorAdapter* actor;
        hpms::WalkmapAdapter* walkMap;
        float tolerance;
        bool ignore;
        glm::vec3 nextPosition{};
        glm::vec2 direction{};
        bool outOfDate;
        hpms::TriangleAdapter* currentTriangle{nullptr};
    public:



        Collisor(ActorAdapter* actor, WalkmapAdapter* walkMap, float tolerance) : actor(actor), walkMap(walkMap),
                                                                    tolerance(tolerance), ignore(false), outOfDate(true)
        {}


        void SetPosition(const glm::vec3& position) override;

        virtual std::string GetName() override;

        virtual glm::vec3 GetPosition() const override;

        virtual glm::quat GetRotation() const override;

        virtual glm::vec3 GetScale() const override;

        virtual void SetVisible(bool visible) override;

        virtual bool IsVisible() const override;


        void SetRotation(const glm::quat& rotation) override;


        void SetScale(const glm::vec3& scale) override;


        const std::string Name() const override;

        void Move(const glm::vec3& nextPosition, const glm::vec2 direction);

        inline TriangleAdapter* GetCurrentTriangle() const
        {
            return currentTriangle;
        }

        inline void SetCurrentTriangle(const TriangleAdapter* currentTriangle)
        {
            // Not implemented.
            LOG_WARN("Cannot set sampled triangle inside script.");
        }

        void Update() override;

    private:
        void DetectBySector();
        void DetectByBoundingRadius();

        void CorrectPositionAfterCollision(const std::pair<glm::vec2, glm::vec2>& sidePair);
    };
}
