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

        virtual void DrawLine(const glm::vec3& p1, const glm::vec3& p2) = 0;

        inline virtual ~NativeAdapter()
        {

        }
    };
}
