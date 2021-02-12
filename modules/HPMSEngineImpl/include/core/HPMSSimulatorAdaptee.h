/*!
 * File HPMSSimulatorAdaptee.h
 */

#pragma once

#include <api/HPMSSimulatorAdapter.h>
#include <core/HPMSAdapteeCommon.h>
#include <core/HPMSOgreContext.h>

namespace hpms
{
    class SimulatorAdaptee : public hpms::SimulatorAdapter, hpms::AdapteeCommon, Ogre::FrameListener
    {
    private:

        CustomLogic* logic;
        hpms::InputHandler inputHandler;
        std::vector<KeyEvent> keyStates{};
        std::vector<MouseEvent> mouseButtonStates{};
        unsigned int x;
        unsigned int y;

        virtual bool frameRenderingQueued(const Ogre::FrameEvent& evt) override;

    public:
        SimulatorAdaptee(hpms::OgreContext* ctx, hpms::CustomLogic* logic);

        virtual ~SimulatorAdaptee();

        virtual void Run() override;

    };
}
