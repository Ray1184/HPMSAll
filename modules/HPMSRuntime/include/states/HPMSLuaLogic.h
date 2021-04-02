/*!
 * File HPMSLuaLogic.h
 */

#pragma once

#include <facade/HPMSApiFacade.h>
#include <unordered_map>
#include <string>
#include <vm/HPMSLuaVM.h>
#include <states/HPMSGameState.h>

namespace hpms
{
    class LuaLogic : public CustomLogic
    {
    private:
        LuaVM* vm;
        GameState* currentState;
        bool clear;
    public:
        LuaLogic();

        virtual ~LuaLogic() override;

        virtual void OnCreate() override;

        virtual void OnUpdate(float tpf) override;

        virtual void OnInput(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents, unsigned int x, unsigned int y) override;

        virtual void OnDestroy() override;

        virtual bool TriggerStop() override;

        void LoadState(const std::string& scriptName);

        inline void Check()
        {
            HPMS_ASSERT(currentState, "Current state cannot e null.");
        }
    };
}