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

        virtual void BeginLine(const glm::vec4& ambient, const glm::vec4& diffuse) = 0;

        virtual void DrawLine(const glm::vec3& p1, const glm::vec3& p2) = 0;

        virtual void EndLine() = 0;

        inline virtual ~NativeAdapter()
        {

        }
    };
}
