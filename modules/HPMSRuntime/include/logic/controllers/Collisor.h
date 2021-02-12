/*!
 * File Collisor.h
 */

#pragma once

#include <core/Actor.h>
#include <logic/items/WalkMap.h>
#include <logic/SectorUtils.h>
#include <glm/gtx/perpendicular.hpp>
#include <logic/controllers/Controller.h>

#define VEC_FORWARD glm::vec3(0, 0, 1)

namespace hpms
{
    class Collisor : public Actor, public Controller
    {
    private:
        hpms::Actor* actor;
        hpms::WalkMap* walkMap;
        float tolerance;
        bool ignore;
        glm::vec3 nextPosition{};
        glm::vec2 direction{};
        bool outOfDate;
        hpms::Triangle currentTriangle{};
    public:



        Collisor(Actor* actor, WalkMap* walkMap, float tolerance) : actor(actor), walkMap(walkMap),
                                                                    tolerance(tolerance), ignore(false), outOfDate(false)
        {}


        inline void SetPosition(const glm::vec3& position) override
        {
            glm::vec3 dir3 = hpms::CalcDirection(actor->GetRotation(), VEC_FORWARD);
            glm::vec2 dir2(dir3.x, dir3.z);
            Move(position, dir2);
        }

        inline const glm::vec3& GetPosition() const override
        {
            return actor->GetPosition();
        }

        inline void SetRotation(const glm::quat& rotation) override
        {
            actor->SetRotation(rotation);
        }

        inline const glm::quat& GetRotation() const override
        {
            return actor->GetRotation();
        }

        inline void SetScale(const glm::vec3& scale) override
        {
            actor->SetScale(scale);
        }

        inline const glm::vec3& GetScale() const override
        {
            return actor->GetScale();
        }

        inline const glm::mat4& GetWorldTransform() const override
        {
            return actor->GetWorldTransform();
        }

        inline void SetWorldTransform(const glm::mat4& worldTransform) override
        {
            actor->SetWorldTransform(worldTransform);
        }

        inline const std::string Name() const override
        {
            return "Collisor";
        }

        inline void Move(const glm::vec3& nextPosition, const glm::vec2 direction)
        {
            if (Collisor::nextPosition != nextPosition)
            {
                outOfDate = true;
            }
            Collisor::nextPosition = nextPosition;
            Collisor::direction = direction;


        }

        inline const Triangle& GetCurrentTriangle() const
        {
            return currentTriangle;
        }

        inline void SetCurrentTriangle(const Triangle& currentTriangle)
        {
            LOG_ERROR("Cannot change collisor sector from script.");
        }

        void Update() override;


    };
}
