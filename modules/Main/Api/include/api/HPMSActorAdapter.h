/*!
 * File HPMSActorAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <glm/glm.hpp>
#include <array>

namespace hpms
{
    class AABBAdapter : public hpms::Object
    {
    public:

        enum Corner {
            FAR_LEFT_BOTTOM = 0,
            FAR_LEFT_TOP = 1,
            FAR_RIGHT_TOP = 2,
            FAR_RIGHT_BOTTOM = 3,
            NEAR_RIGHT_TOP = 4,
            NEAR_LEFT_TOP = 5,
            NEAR_LEFT_BOTTOM = 6,
            NEAR_RIGHT_BOTTOM = 7

        };



        typedef std::array<glm::vec3, 8> Corners;

        inline virtual const std::string Name() const override
        {
            return "AABBAdapter";
        }

        virtual glm::vec3 GetCorner(Corner corner) = 0;
    };

    class ActorAdapter : public hpms::Object
    {
    public:
        inline virtual const std::string Name() const override
        {
            return "ActorAdapter";
        }

        inline virtual ~ActorAdapter()
        {

        }

        virtual AABBAdapter* GetAABB() {
            return nullptr;
        }

        virtual std::string GetName() = 0;

        virtual void SetPosition(const glm::vec3& position) = 0;

        virtual glm::vec3 GetPosition() const = 0;

        virtual void SetRotation(const glm::quat& rotation) = 0;

        virtual glm::quat GetRotation() const = 0;

        virtual void SetScale(const glm::vec3& scale) = 0;

        virtual glm::vec3 GetScale() const = 0;

        virtual void SetVisible(bool visible) = 0;

        virtual bool IsVisible() const = 0;
    };
}