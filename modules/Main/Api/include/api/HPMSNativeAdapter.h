/*!
 * File HPMSNativeAdapter.h
 */

#pragma once

#include <glm/glm.hpp>
#include <common/HPMSObject.h>

namespace hpms
{
    class NativeAdapter : public Object
    {
    public:
        inline virtual const std::string Name() const override
        {
            return "NativeAdapter";
        }

        virtual void Clear() = 0;

        virtual void BeginDraw(const glm::vec4& ambient, const glm::vec4& diffuse) = 0;

        virtual void DrawLine(const glm::vec3& p1, const glm::vec3& p2) = 0;

        virtual void DrawCircle(const glm::vec3& center, float radius) = 0;

        virtual void EndDraw() = 0;

        inline virtual ~NativeAdapter()
        {

        }
    };
}
