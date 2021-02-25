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
#include <vm/LuaRegister.h>
#include <common/HPMSUtils.h>
#include <facade/HPMSApiFacade.h>

namespace hpms
{
    class LuaVM : Object
    {

    public:
        LuaVM();

        virtual ~LuaVM();

        inline void ExecuteScript(const std::string& path);

        inline void ExecuteStatement(const std::string& stat);

        inline LuaRef GetGlobal(const std::string& name);


        inline void RegisterAll();

        inline void Close();

        inline const std::string Name() const override;

    private:
        lua_State* state;
        bool closed;
    };
}
