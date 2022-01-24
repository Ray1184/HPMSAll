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

namespace hpms
{
    struct CollisorConfig
    {
        float gravityAffection{9.81f};
        float maxStepHeight{0.1f};
    };

    class Collisor : public ActorAdapter, public Controller
    {
    private:
        hpms::ActorAdapter* actor;
        hpms::WalkmapAdapter* walkMap;
        hpms::CollisionResponse* collisionResponse;
        float tolerance;
        bool ignore;
        float baseHeight;
        bool baseHeightDefined;
        glm::vec3 nextPosition{};
        glm::vec2 direction{};
        bool outOfDate;
        hpms::TriangleAdapter* currentTriangle{ nullptr };
        std::vector<glm::vec2> perimeter;
        CollisorConfig config;
        float currentVerticalSpeed;
    public:



        Collisor(ActorAdapter* actor, WalkmapAdapter* walkMap, float tolerance, const CollisorConfig& config = CollisorConfig{});

        virtual ~Collisor();
    

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
            LOG_WARN("Cannot set sampled triangle inside script");
        }

        inline void SetTolerance(float tolerance)
        {
            Collisor::tolerance = tolerance;
        }

        inline float GetTolerance()
        {
            return tolerance;
        }

        inline void SetVerticalSpeed(float verticalSpeed)
        {
            // Not implemented.
            LOG_WARN("Cannot change collisor vertical speed from script");
        }

        inline float GetVerticalSpeed() const
        {
            return currentVerticalSpeed;
        }

        void Update(float tpf) override;

    private:
        void DetectBySector();
        void DetectByBoundingRadius(float tpf);
        void CorrectPositionBoundingRadiusMode(const glm::vec2 &sideA, const glm::vec2 &sideB, glm::vec3* correctPosition);
        void CorrectPositionBoundingRadiusMode(const glm::vec2 &sideA, const glm::vec2 &sideB, glm::vec2* correctPosition);
        void CorrectPositionSectorMode(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle);
        void ApplyGravity(const glm::vec3& nextPosition, float tpf);
        float GetHeightInMap();
    };
}
