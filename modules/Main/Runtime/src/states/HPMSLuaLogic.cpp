/*!
 * File HPMSLuaLogic.cpp
 */

#include <states/HPMSLuaLogic.h>
#include <sstream>

#define ENTRY_POINT "InitConfig.lua"

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
    auto* script = hpms::LoadScript(ENTRY_POINT);
    vm->ExecuteStatement(script->GetContent());
    hpms::DestroyScript(script);
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
    if (currentState->GetStatus() == RUNNING)
    {
        currentState->Input(keyEvents, mouseButtonEvents, x, y);
    }
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
    return currentState->Quit();
}

void hpms::LuaLogic::LoadState(const std::string& scriptName)
{
    vm->ClearState();
    auto* script = hpms::LoadScript(scriptName);
    vm->ExecuteStatement(script->GetContent());
    std::stringstream ss;
    ss << "Script " << scriptName << " loaded in LUA context.";
    LOG_DEBUG(ss.str().c_str());
    hpms::DestroyScript(script);
    loadedDeps.clear();
    this->SolveLuaDependencies();
    currentState = hpms::SafeNew<GameState>(vm);
}

void hpms::LuaLogic::SolveLuaDependencies()
{

    LuaRef dependencies = vm->GetGlobal("dependencies");
    if (dependencies)
    {
        for (unsigned int i = 1; i < dependencies.length() + 1; i++)
        {
            auto dep = dependencies[i].tostring();
            if (std::find(loadedDeps.begin(), loadedDeps.end(), dep) != loadedDeps.end())
            {
                // Skip dependency if already loaded in LUA context.
                continue;
            }
            std::stringstream ss;
            ss << "Dependency " << dep << " loaded in LUA context.";
            LOG_DEBUG(ss.str().c_str());
            auto* script = hpms::LoadScript(dep);
            vm->ExecuteStatement(script->GetContent());
            hpms::DestroyScript(script);
            loadedDeps.push_back(dep);
            SolveLuaDependencies();

        }
    }
}

