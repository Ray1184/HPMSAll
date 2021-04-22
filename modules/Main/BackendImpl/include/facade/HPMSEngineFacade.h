/*!
 * File HPMSEngineFacade.h
 */

#pragma once

#include <core/HPMSSupplierAdaptee.h>
#include <core/HPMSOgreContext.h>
#include <core/HPMSSimulatorAdaptee.h>
#include <core/HPMSScriptAdaptee.h>
#include <api/HPMSNativeAdapter.h>

namespace hpms {

    void InitContext(const hpms::WindowSettings& windowSettings, hpms::CustomLogic* logic);

    void DestroyContext();

    SupplierAdapter* GetSupplier();

    SimulatorAdapter* GetSimulator();

    ScriptAdapter* LoadScript(const std::string& name);

    NativeAdapter* GetNative();

    void DestroyScript(ScriptAdapter* script);

    // DEBUG USE ONLY
    OgreContext* GetContext();


}
