#include <sstream>
#include <api/HPMSSimulatorAdapter.h>
#include <facade/HPMSEngineFacade.h>
#include <states/HPMSLuaLogic.h>

#include <glm/glm.hpp>
#include <common/HPMSMathUtils.h>

#define RATIO 3
#define WIDTH 320 * RATIO
#define HEIGHT 200 * RATIO

#if defined(_WIN32) || defined(WIN32)
#include <windows.h>
int APIENTRY wWinMain(_In_ HINSTANCE hInstance, _In_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
#else
int main(int argc, char* argv[])
#endif
{
	
	hpms::LogBuffer::Instance().Open();
	hpms::WindowSettings s;
	s.name = "HPMSDemo";
	s.width = WIDTH;
	s.height = HEIGHT;
	s.pixelRatio = RATIO;
	s.fullScreen = false;
	auto* customLogic = hpms::SafeNew<hpms::LuaLogic>();
	hpms::InitContext(s, customLogic);
	std::stringstream ss;
	ss << "Rendering engine implementation: " << hpms::GetSupplier()->GetImplName();
	LOG_INFO(ss.str().c_str());
	try
	{
		hpms::GetSimulator()->Run();
		hpms::SafeDelete(customLogic);
		hpms::DestroyContext();
#ifdef HPMS_DEBUG
		hpms::MemoryDump();
#endif
		hpms::LogBuffer::Instance().Close();
		return 0;
	}
	catch (std::exception& e)
	{
		std::stringstream ss;
		ss << "Runtime stopped with error: " << e.what() << std::endl;
		LOG_ERROR(ss.str().c_str());
		hpms::LogBuffer::Instance().Close();
		return -1;
	}
	
}