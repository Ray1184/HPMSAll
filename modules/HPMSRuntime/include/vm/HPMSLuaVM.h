/*!
 * File LuaVM.h
 */

#pragma once

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include <string>


#include <glm/glm.hpp>
#include <vm/HPMSLuaRegister.h>
#include <common/HPMSUtils.h>
#include <facade/HPMSApiFacade.h>

namespace hpms
{
    class LuaVM : Object
    {

    public:
        LuaVM();

        virtual ~LuaVM();

        void ExecuteScript(const std::string& path);

        void ExecuteStatement(const std::string& stat);

        LuaRef GetGlobal(const std::string& name);

        void RegisterAll();

        void Close();

        const std::string Name() const override;

    private:
        lua_State* state;
        bool closed;
    };
}
