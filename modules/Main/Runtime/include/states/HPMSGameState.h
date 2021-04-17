/*!
 * File HPMSGameState.h
 */

#pragma once

#include <string>
#include <vector>
#include <vm/HPMSLuaVM.h>
#include <common/HPMSObject.h>
#include <api/HPMSInputUtils.h>

namespace hpms
{

    enum Status
    {
        NEW = 0,
        RUNNING = 1,
        FINISHED = 2
    };

    class GameState : public Object
    {
    private:

        Status status;
        std::string stateToSwitch;
        LuaVM* vm;
        bool clear;
    public:

        explicit GameState(LuaVM* pvm);

        virtual ~GameState();

        virtual const std::string Name() const override;

        void Init();

        void Update(float tpf);

        void Cleanup();

        void Input(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents, unsigned int x, unsigned int y);

        bool Quit();

        inline Status GetStatus() const
        {
            return status;
        }

        inline void SetStatus(Status status)
        {
            GameState::status = status;
        }


        inline const std::string& GetStateToSwitch() const
        {
            return stateToSwitch;
        }

        inline void SetStateToSwitch(const std::string& stateToSwitch)
        {
            GameState::stateToSwitch = stateToSwitch;
        }
    };
}
