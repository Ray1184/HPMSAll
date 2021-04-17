/*!
 * File HPMSScriptAdapter.h
 */

#pragma once

#include <common/HPMSObject.h>
#include <vector>
#include <string>

namespace hpms
{
    class ScriptAdapter : public Object
    {
    public:
        inline const std::string Name() const override
        {
            return "ScriptAdapter";
        }

        inline virtual ~ScriptAdapter()
        {

        }

        virtual std::string GetContent() = 0;
    };
}