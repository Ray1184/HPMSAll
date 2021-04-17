#include <sstream>
#include <windows.h>
#include <api/HPMSSimulatorAdapter.h>
#include <facade/HPMSEngineFacade.h>
#include <states/HPMSLuaLogic.h>

#define WIDTH 960
#define HEIGHT 600

void Dump()
{
#if !defined(_DEBUG) && !defined(NDEBUG)
    std::stringstream ss;
    ss << "Start memory dump report.\n------------------------------" << std::endl;
    int leaks = 0;
    for (const auto& pair : hpms::AllocCounter::Instance().allocMap)
    {
        ss << pair.first << ": " << pair.second << std::endl;
        leaks += pair.second;
    }
    ss << std::endl;
    if (leaks == 0)
    {
        ss << "OK, no potential memory leaks detected!" << std::endl;
    } else if (leaks > 0)
    {
        ss << "WARNING, potential memory leaks detected! " << leaks << " allocations not set free." << std::endl;
    } else
    {
        ss << "WARNING, unnecessary memory dealloc detected! " << -leaks << " useless de-allocations." << std::endl;
    }
    ss << "------------------------------";
    LOG_RAW(ss.str().c_str());
    LOG_RAW("End memory dump report.");
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

        hpms::WindowSettings s;
        s.name = "HPMSDemo";
        s.width = WIDTH;
        s.height = HEIGHT;
        s.pixelRatio = WIDTH / 320;
        auto* customLogic = hpms::SafeNew<hpms::LuaLogic>();
        hpms::InitContext(s, customLogic);
        std::stringstream ss;
        ss << "Rendering engine implementation: " << hpms::GetSupplier()->GetImplName();
        LOG_INFO(ss.str().c_str());
        hpms::GetSimulator()->Run();
        hpms::SafeDelete(customLogic);
        hpms::DestroyContext();
        Dump();

        return 0;
    } catch (std::exception& e)
    {
        std::stringstream ss;
        ss << "Runtime stopped with error: " << e.what();
        LOG_ERROR(ss.str().c_str());
    }
}