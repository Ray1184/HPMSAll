/*!
 * File HPMSLuaLogic.cpp
 */

#include <states/HPMSLuaLogic.h>

hpms::LuaLogic::LuaLogic() : clear(false), currentState(nullptr)
{
    vm = hpms::SafeNew<LuaVM>();
}


hpms::LuaLogic::~LuaLogic()
{
}

void hpms::LuaLogic::OnCreate()
{
    vm->RegisterAll();
    auto* script = hpms::GetScript("InitConfig.lua");
    vm->ExecuteStatement(script->GetContent());
    LuaRef config = vm->GetGlobal("config");
    std::string firstScript = config["first_script"];
    LoadState(firstScript);
}

void hpms::LuaLogic::OnUpdate(float tpf)
{
    Check();
    if (currentState->GetStatus() == hpms::Status::NEW)
    {
        currentState->Init();
        currentState->SetStatus(Status::RUNNING);
    } else if (currentState->GetStatus() == Status::RUNNING)
    {
        currentState->Update(tpf);
    } else
    {
        currentState->Cleanup();
        std::string nextScript = currentState->GetStateToSwitch();
        hpms::SafeDelete(currentState);
        LoadState(nextScript);
    }
}

void hpms::LuaLogic::OnInput(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents, unsigned int x, unsigned int y)
{
    Check();
    currentState->Input(keyEvents, mouseButtonEvents, x, y);
}

void hpms::LuaLogic::OnDestroy()
{
    if (!clear)
    {
        clear = true;
        hpms::SafeDelete(currentState);
        hpms::SafeDelete(vm);
    }
}

bool hpms::LuaLogic::TriggerStop()
{
    if (currentState->Quit())
    {
        return true;
    }
    return false;
}

void hpms::LuaLogic::LoadState(const std::string& scriptName)
{
    auto* script = hpms::GetScript(scriptName);
    vm->ExecuteStatement(script->GetContent());
    LuaRef scene = vm->GetGlobal("scene");
    std::string mode = scene["mode"];
    currentState = hpms::SafeNew<GameState>(vm);
}

