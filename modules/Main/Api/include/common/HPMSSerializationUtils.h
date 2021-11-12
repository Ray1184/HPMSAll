/*!
 * File HPMSSerializationUtils.h
 */

#pragma once

#include <vector>
#include <glm/glm.hpp>
#include <pods/pods.h>
#include <pods/buffers.h>
#include <pods/binary.h>

namespace hpms
{
    struct Vec2Wrapper
    {
        glm::vec2 data;

        PODS_SERIALIZABLE(
            1,
            PODS_OPT(data.x),
            PODS_OPT(data.y)

        );
    };

    inline std::vector<Vec2Wrapper> SerializableOf(const std::vector<glm::vec2> &input)
    {
        std::vector<Vec2Wrapper> ret;
        for (auto v : input)
        {
            Vec2Wrapper wrapper{v};
            ret.push_back(wrapper);
        }
        return ret;
    }

}
