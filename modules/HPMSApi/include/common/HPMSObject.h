/*!
 * File HPMSObject.h
 */

#pragma once

#include <string>

namespace hpms
{
    class Object
    {
    public:
        virtual const std::string Name() const = 0;
    };
}
