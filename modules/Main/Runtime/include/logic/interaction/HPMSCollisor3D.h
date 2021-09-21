/*!
 * File HPMSCollisor3D.h
 */

#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <api/HPMSActorAdapter.h>
#include <common/HPMSMathUtils.h>
#include <glm/gtx/perpendicular.hpp>
#include <logic/HPMSController.h>
#include <common/HPMSUtils.h>
#include <facade/HPMSApiFacade.h>
#include <vector>

#define VEC_FORWARD glm::vec3(0, 1, 0)
#define MAX_DIST 10

namespace hpms
{
    class Collisor3D : public ActorAdapter, public Controller
    {
    private:
        hpms::ActorAdapter* actor;
        float tolerance;
        bool ignore;
        glm::vec3 nextPosition{};
        glm::vec2 direction{};
        CollisionOptions opts{};
        bool outOfDate;


    public:

        Collisor3D(ActorAdapter* actor, float tolerance);

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

        void Update() override;

    private:
        void DetectBySector();
        void DetectByBoundingRadius();

        void CorrectPositionAfterCollision(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle);
    };
}
