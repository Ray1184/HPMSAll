/*!
 * File HPMSLuaVM.cpp
 */

#include <vm/HPMSLuaVM.h>

hpms::LuaVM::LuaVM() : closed(false)
{
    state = luaL_newstate();
    luaL_openlibs(state);
}

hpms::LuaVM::~LuaVM()
{
    if (!closed)
    {
        Close();
    }
}

void hpms::LuaVM::ExecuteScript(const std::string& path)
{
    luaL_dofile(state, path.c_str());
    lua_pcall(state, 0, 0, 0);

}

void hpms::LuaVM::ExecuteStatement(const std::string& stat)
{
    luaL_dostring(state, stat.c_str());
    lua_pcall(state, 0, 0, 0);

}

LuaRef hpms::LuaVM::GetGlobal(const std::string& name)
{
    return getGlobal(state, name.c_str());
}

void hpms::LuaVM::RegisterAll()
{
    hpms::LuaRegister::RegisterCommonMath(state);
    hpms::LuaRegister::RegisterVector2(state);
    hpms::LuaRegister::RegisterVector3(state);
    hpms::LuaRegister::RegisterVector4(state);
    hpms::LuaRegister::RegisterMatrix4(state);
    hpms::LuaRegister::RegisterKeyEvent(state);
    hpms::LuaRegister::RegisterKeyList(state);
    hpms::LuaRegister::RegisterQuaternion(state);
    hpms::LuaRegister::RegisterEntity(state);
    hpms::LuaRegister::RegisterNode(state);
    hpms::LuaRegister::RegisterPicture(state);
    hpms::LuaRegister::RegisterAssetManager(state);
    hpms::LuaRegister::RegisterScene(state);
    hpms::LuaRegister::RegisterCamera(state);
    hpms::LuaRegister::RegisterWalkMap(state);
    hpms::LuaRegister::RegisterTriangle(state);
    hpms::LuaRegister::RegisterCollisor(state);
    hpms::LuaRegister::RegisterAnimator(state);
    hpms::LuaRegister::RegisterLogic(state);
}

void hpms::LuaVM::Close()
{
    lua_close(state);
    closed = true;
}

const std::string hpms::LuaVM::Name() const
{
    return "LuaVM";
}
