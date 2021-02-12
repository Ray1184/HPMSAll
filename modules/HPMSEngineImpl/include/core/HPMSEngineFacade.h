/*!
 * File HPMSEngineFacade.h
 */

#pragma once

#include <core/HPMSSupplierAdaptee.h>
#include <core/HPMSOgreContext.h>
#include <core/HPMSSimulatorAdaptee.h>

namespace hpms {

    void InitContext(hpms::WindowSettings& windowSettings, unsigned int pixelRatio = 1.0);

    void DestroyContext();

    SupplierAdapter* CreateSupplier();

    void DestroySupplier(hpms::SupplierAdapter*& supplier);

    SimulatorAdapter* CreateSimulator(hpms::CustomLogic* logic);

    void DestroySimulator(hpms::SimulatorAdapter* simulator);
}
