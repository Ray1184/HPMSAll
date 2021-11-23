#include <sstream>
#include <windows.h>
#include <api/HPMSSimulatorAdapter.h>
#include <facade/HPMSEngineFacade.h>
#include <states/HPMSLuaLogic.h>

#define WIDTH 320
#define HEIGHT 200

void Dump()
{
#ifdef HPMS_DEBUG
    hpms::MemoryDump();    
#endif
}

#if defined(_WIN32) || defined(WIN32)

INT WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR cmdLine, INT)
#else
int main(int argc, char *argv[])
#endif
{
    try
    {
        hpms::LogBuffer::Instance().Open();
        hpms::WindowSettings s;
        s.name = "HPMSDemo";
        s.width = WIDTH;
        s.height = HEIGHT;
        s.pixelRatio = WIDTH / 320;
        s.fullScreen = false;
        auto* customLogic = hpms::SafeNew<hpms::LuaLogic>();
        hpms::InitContext(s, customLogic);
        std::stringstream ss;
        ss << "Rendering engine implementation: " << hpms::GetSupplier()->GetImplName();
        LOG_INFO(ss.str().c_str());
        hpms::GetSimulator()->Run();
        hpms::SafeDelete(customLogic);
        hpms::DestroyContext();
        Dump();
        hpms::LogBuffer::Instance().Close();
        return 0;
    } catch (std::exception& e)
    {
        std::stringstream ss;
        ss << "Runtime stopped with error: " << e.what();
        LOG_ERROR(ss.str().c_str());
    }
}