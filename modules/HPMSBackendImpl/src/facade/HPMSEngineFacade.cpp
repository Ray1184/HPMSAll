/*!
 * File HPMSEngineFacade.cpp
 */

#include <facade/HPMSEngineFacade.h>
#include <core/HPMSRenderToTexture.h>

hpms::OgreContext* gContext = nullptr;
hpms::RenderToTexture* gRtt = nullptr;
hpms::SupplierAdapter* gSupplier = nullptr;
hpms::SimulatorAdapter* gSimulator = nullptr;

void hpms::InitContext(hpms::WindowSettings& windowSettings)
{
    try
    {
        hpms::OgreWindowSettings ogreSettings;
        ogreSettings.name = windowSettings.name;
        ogreSettings.width = windowSettings.width;
        ogreSettings.height = windowSettings.height;
        ogreSettings.fullScreen = windowSettings.fullScreen;
        ogreSettings.pixelRatio = windowSettings.pixelRatio;
        if (gContext == nullptr)
        {
            gContext = hpms::SafeNew<hpms::OgreContext>(ogreSettings);
            float fbWidth = ogreSettings.width / ogreSettings.pixelRatio;
            float fbHeight = ogreSettings.height / ogreSettings.pixelRatio;
            gRtt = hpms::SafeNew<hpms::RenderToTexture>(gContext, fbWidth, fbHeight);
        }

    } catch (std::exception& e)
    {
        LOG_ERROR(e.what());
    }

}

void hpms::DestroyContext()
{
    hpms::SafeDelete(gRtt);
    hpms::SafeDelete(gContext);
}


hpms::SupplierAdapter* hpms::GetSupplier()
{
    try
    {
        if (!gSupplier)
        {
            HPMS_ASSERT(gContext, "Context cannot be null.");
            gSupplier = hpms::SafeNew<hpms::SupplierAdaptee>(gContext);
        }
        return gSupplier;
    } catch (std::exception& e)
    {
        LOG_ERROR(e.what());
    }
    return nullptr;
}

void hpms::DestroySupplier(hpms::SupplierAdapter*& supplier)
{
    hpms::SafeDelete(supplier);
}

hpms::SimulatorAdapter* hpms::GetSimulator(hpms::CustomLogic* logic)
{
    try
    {
        if (!gSimulator)
        {
            HPMS_ASSERT(gContext, "Context cannot be null.");
            gSimulator = hpms::SafeNew<hpms::SimulatorAdaptee>(gContext, logic);
        }
        return gSimulator;
    } catch (std::exception& e)
    {
        LOG_ERROR(e.what());
    }
    return nullptr;
}

void hpms::DestroySimulator(hpms::SimulatorAdapter* simulator)
{
    hpms::SafeDelete(simulator);
}

hpms::ScriptAdapter* hpms::GetScript(const std::string& name)
{
    return hpms::SafeNew<ScriptAdaptee>(name);
}

void hpms::DestroyScript(hpms::ScriptAdapter* script)
{
    hpms::SafeDelete(script);
}
