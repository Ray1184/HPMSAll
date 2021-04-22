/*!
 * File HPMSEngineFacade.cpp
 */

#include <facade/HPMSEngineFacade.h>
#include <core/HPMSRenderToTexture.h>
#include <core/HPMSNativeAdaptee.h>

hpms::OgreContext* gContext = nullptr;
hpms::RenderToTexture* gRtt = nullptr;
hpms::SupplierAdapter* gSupplier = nullptr;
hpms::SimulatorAdapter* gSimulator = nullptr;
hpms::NativeAdapter* gNative = nullptr;

void hpms::InitContext(const hpms::WindowSettings& windowSettings, hpms::CustomLogic* logic)
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
            gSupplier = hpms::SafeNew<hpms::SupplierAdaptee>(gContext);
            gSimulator = hpms::SafeNew<hpms::SimulatorAdaptee>(gContext, logic);
            gNative = hpms::SafeNew<hpms::NativeAdaptee>(gContext);
        }

    } catch (std::exception& e)
    {
        LOG_ERROR(e.what());
    }

}

void hpms::DestroyContext()
{
    hpms::SafeDelete(gNative);
    hpms::SafeDelete(gSimulator);
    hpms::SafeDelete(gSupplier);
    hpms::SafeDelete(gRtt);
    hpms::SafeDelete(gContext);
}


hpms::SupplierAdapter* hpms::GetSupplier()
{
    HPMS_ASSERT(gContext, "Context must be initialized.");
    return gSupplier;
}


hpms::SimulatorAdapter* hpms::GetSimulator()
{
    HPMS_ASSERT(gContext, "Context must be initialized.");
    return gSimulator;
}

hpms::ScriptAdapter* hpms::LoadScript(const std::string& name)
{
    return hpms::SafeNew<ScriptAdaptee>(name);
}

void hpms::DestroyScript(hpms::ScriptAdapter* script)
{
    hpms::SafeDelete(script);
}

hpms::OgreContext* hpms::GetContext()
{
    return gContext;
}
