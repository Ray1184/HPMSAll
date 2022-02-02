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

void hpms::LuaVM::ExecuteStatement(const std::string& stat, const std::string& name)
{
    std::string desc("@" + name);
    luaL_loadbuffer(state, stat.c_str(), stat.length(), desc.c_str());
    lua_pcall(state, 0, 0, 0);
}

LuaRef hpms::LuaVM::GetGlobal(const std::string& name)
{
    return getGlobal(state, name.c_str());
}

void hpms::LuaVM::ClearState()
{
    int stackSize = lua_gettop(state);
    lua_pop(state, stackSize);
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
    hpms::LuaRegister::RegisterMouseEvent(state);
    hpms::LuaRegister::RegisterMouseList(state);
    hpms::LuaRegister::RegisterQuaternion(state);
    hpms::LuaRegister::RegisterEntity(state);
    hpms::LuaRegister::RegisterNode(state);
    hpms::LuaRegister::RegisterBackgroundImage(state);
    hpms::LuaRegister::RegisterOverlayImage(state);
    hpms::LuaRegister::RegisterTextArea(state);
    hpms::LuaRegister::RegisterLight(state);
    hpms::LuaRegister::RegisterAssetManager(state);
    hpms::LuaRegister::RegisterCamera(state);
    hpms::LuaRegister::RegisterWalkMap(state);
    hpms::LuaRegister::RegisterTriangle(state);
    hpms::LuaRegister::RegisterCollisor(state);
    hpms::LuaRegister::RegisterCollisionEnv(state);
    hpms::LuaRegister::RegisterCollisionState(state);
    hpms::LuaRegister::RegisterCollisorConfig(state);
    hpms::LuaRegister::RegisterAnimation(state);
    hpms::LuaRegister::RegisterLogic(state);
    hpms::LuaRegister::RegisterSysLogic(state);
    hpms::LuaRegister::RegisterDebug(state);
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


