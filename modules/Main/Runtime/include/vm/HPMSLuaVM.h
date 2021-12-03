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

		void ClearState();

		void RegisterAll();

		void Close();

		const std::string Name() const override;

		inline std::string BuildStackTrace()
		{
			std::stringstream ss;
			int top = lua_gettop(state);
			for (int i = 1; i <= top; i++) {
				ss << std::to_string(i) << "\t" << luaL_typename(state, i) << "\t";
				switch (lua_type(state, i)) {
				case LUA_TNUMBER:
					ss << std::to_string(lua_tonumber(state, i));
					break;
				case LUA_TSTRING:
					ss << lua_tostring(state, i);
					break;
				case LUA_TBOOLEAN:
					ss << (lua_toboolean(state, i) ? "true" : "false");
					break;
				case LUA_TNIL:
					ss << "nil";
					break;
				default:
					ss << lua_topointer(state, i);
					break;
				}
			}
			return ss.str();
		}

	private:
		lua_State* state;
		bool closed;
	};
}
