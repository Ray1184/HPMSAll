/*!
 * File HPMSScriptAdaptee.cpp
 */

#include <core/HPMSScriptAdaptee.h>
#include <resource/HPMSLuaScriptManager.h>

std::string hpms::ScriptAdaptee::GetContent()
{
    return content;
}

hpms::ScriptAdaptee::ScriptAdaptee(const std::string& scriptName) : AdapteeCommon(nullptr)
{
    hpms::LuaScriptPtr luaScript = hpms::LuaScriptManager::GetSingleton().Create(scriptName);
    content = luaScript->GetScriptContent();
}

hpms::ScriptAdaptee::~ScriptAdaptee()
{
    content.clear();
}
