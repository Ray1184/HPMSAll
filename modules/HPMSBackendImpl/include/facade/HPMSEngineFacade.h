/*!
 * File HPMSEngineFacade.h
 */

#pragma once

#include <core/HPMSSupplierAdaptee.h>
#include <core/HPMSOgreContext.h>
#include <core/HPMSSimulatorAdaptee.h>
#include <core/HPMSScriptAdaptee.h>

namespace hpms {

    void InitContext(hpms::WindowSettings& windowSettings);

    void DestroyContext();

    SupplierAdapter* GetSupplier();

    void DestroySupplier(hpms::SupplierAdapter*& supplier);

    SimulatorAdapter* GetSimulator(hpms::CustomLogic* logic);

    void DestroySimulator(hpms::SimulatorAdapter* simulator);

    ScriptAdapter* GetScript(const std::string& name);

    void DestroyScript(ScriptAdapter* script);


}
