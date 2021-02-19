/*!
 * File HPMSEngineFacade.cpp
 */

#include <facade/HPMSEngineFacade.h>
#include <core/HPMSRenderToTexture.h>

hpms::OgreContext* gContext = nullptr;
hpms::RenderToTexture* gRtt = nullptr;

void hpms::InitContext(hpms::WindowSettings& windowSettings, unsigned int pixelRatio)
{
    try
    {
        hpms::OgreWindowSettings ogreSettings;
        ogreSettings.name = windowSettings.name;
        ogreSettings.width = windowSettings.width;
        ogreSettings.height = windowSettings.height;
        if (gContext == nullptr)
        {
            gContext = hpms::SafeNew<hpms::OgreContext>(ogreSettings);
            float fbWidth = ogreSettings.width / pixelRatio;
            float fbHeight = ogreSettings.height / pixelRatio;
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


hpms::SupplierAdapter* hpms::CreateSupplier()
{
    try
    {
        return hpms::SafeNew<hpms::SupplierAdaptee>(gContext);
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

hpms::SimulatorAdapter* hpms::CreateSimulator(hpms::CustomLogic* logic)
{
    try
    {
        return hpms::SafeNew<hpms::SimulatorAdaptee>(gContext, logic);
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
