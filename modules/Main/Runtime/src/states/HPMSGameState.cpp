/*!
 * File HPMSGameState.cpp
 */

#include <states/HPMSGameState.h>

hpms::GameState::GameState(hpms::LuaVM* pvm) : vm(pvm), clear(false)
{
    status = NEW;
}

hpms::GameState::~GameState()
{
    Cleanup();
}

void hpms::GameState::Init()
{
    LuaRef sceneFun = vm->GetGlobal("scene");
    LuaRef initFunc = sceneFun["setup"];
    initFunc();
}

void hpms::GameState::Update(float tpf)
{
    LuaRef sceneFun = vm->GetGlobal("scene");
    LuaRef updateFunc = sceneFun["update"];
    updateFunc(tpf);
    LuaRef finished = sceneFun["finished"];
    if (finished.isBool() && finished)
    {
        LuaRef next = sceneFun["next"];
        SetStateToSwitch(next.tostring());
        status = FINISHED;
    }
}

void hpms::GameState::Cleanup()
{
    if (!clear)
    {
        clear = true;
        LuaRef sceneFun = vm->GetGlobal("scene");
        LuaRef cleanup = sceneFun["cleanup"];
        cleanup();
    }
}

void hpms::GameState::Input(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents, unsigned int x, unsigned int y)
{
    LuaRef sceneFun = vm->GetGlobal("scene");
    LuaRef inputFunc = sceneFun["input"];
    inputFunc(&keyEvents, &mouseButtonEvents, x, y);
}

bool hpms::GameState::Quit()
{

        LuaRef scene = vm->GetGlobal("scene");
        return scene["quit"];
}

const std::string hpms::GameState::Name() const
{
    return "GameState";
}
