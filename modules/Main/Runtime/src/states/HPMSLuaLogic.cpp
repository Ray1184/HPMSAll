/*!
 * File HPMSLuaLogic.cpp
 */

#include <states/HPMSLuaLogic.h>
#include <sstream>

#define ENTRY_POINT "sys/Init.lua"
#define STATE_CONTEXT "sys/Context.lua"
#define UTILS "sys/Utils.lua"

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
    auto* scriptUtils = hpms::LoadScript(UTILS);
    vm->ExecuteStatement(scriptUtils->GetContent(), UTILS);
    hpms::DestroyScript(scriptUtils);
    auto* scriptCtx = hpms::LoadScript(STATE_CONTEXT);
    vm->ExecuteStatement(scriptCtx->GetContent(), STATE_CONTEXT);
    hpms::DestroyScript(scriptCtx);
    auto* scriptEp = hpms::LoadScript(ENTRY_POINT);
    vm->ExecuteStatement(scriptEp->GetContent(), ENTRY_POINT);
    hpms::DestroyScript(scriptEp);    
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

        // Run first update after init, in order to avoid 1 black frame.
        currentState->Update(tpf);
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
    auto* script = hpms::LoadScript(scriptName);
    vm->ExecuteStatement(script->GetContent(), scriptName);
    std::stringstream ss;
    ss << "Script " << scriptName << " loaded in LUA context";
    LOG_DEBUG(ss.str().c_str());
    hpms::DestroyScript(script);
    loadedDeps.clear();
    this->SolveLuaDependencies();
    std::stringstream ss2;
    ss2 << "All dependencies solved for script " << scriptName;
    LOG_DEBUG(ss2.str().c_str());
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
                std::stringstream ss;
                ss << "Skipping dependency " << dep << ", already present in LUA context";
                LOG_DEBUG(ss.str().c_str());
                continue;
            }
            std::stringstream ss;
            ss << "Dependency " << dep << " loaded in LUA context";
            LOG_DEBUG(ss.str().c_str());
            auto* script = hpms::LoadScript(dep);
            vm->ExecuteStatement(script->GetContent(), dep);
            hpms::DestroyScript(script);
            loadedDeps.push_back(dep);
            SolveLuaDependencies();

        }
    }
}

