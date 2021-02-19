/*!
 * File HPMSScriptAdaptee.h
 */

#pragma once

#include <core/HPMSAdapteeCommon.h>
#include <api/HPMSScriptAdapter.h>

namespace hpms
{
    class ScriptAdaptee : public hpms::ScriptAdapter, public hpms::AdapteeCommon
    {
    private:
        std::string content;
    public:
        explicit ScriptAdaptee(const std::string& scriptName);

        virtual ~ScriptAdaptee();

        virtual std::string GetContent() override;
    };
}
