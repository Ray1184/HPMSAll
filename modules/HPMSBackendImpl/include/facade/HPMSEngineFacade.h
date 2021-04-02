/*!
 * File HPMSEngineFacade.h
 */

#pragma once

#include <core/HPMSSupplierAdaptee.h>
#include <core/HPMSOgreContext.h>
#include <core/HPMSSimulatorAdaptee.h>
#include <core/HPMSScriptAdaptee.h>

namespace hpms {

    void InitContext(const hpms::WindowSettings& windowSettings, hpms::CustomLogic* logic);

    void DestroyContext();

    SupplierAdapter* GetSupplier();

    SimulatorAdapter* GetSimulator();

    ScriptAdapter* LoadScript(const std::string& name);

    void DestroyScript(ScriptAdapter* script);

    // DEBUG USE ONLY
    OgreContext* GetContext();


}
