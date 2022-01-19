#include <sstream>
#include <windows.h>
#include <api/HPMSSimulatorAdapter.h>
#include <facade/HPMSEngineFacade.h>
#include <states/HPMSLuaLogic.h>

#include <glm/glm.hpp>
#include <common/HPMSMathUtils.h>

#define WIDTH 320
#define HEIGHT 200

#if defined(_WIN32) || defined(WIN32)
int APIENTRY wWinMain(_In_ HINSTANCE hInstance, _In_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
#else
int main(int argc, char* argv[])
#endif
{
	/*
	hpms::LogBuffer::Instance().Open();
	glm::vec2 pa(5.5, 2.2);
	glm::vec2 pb(12, 3.5);
	glm::vec2 center(7, 2.8f);
	float rad = 0.24f;	
	LOG_INFO("----------------- COLLISION RESPONSE --------------------");
	std::stringstream ss;
	ss << hpms::CircleLineIntersect(pa, pb, center, rad) << std::endl;
	LOG_INFO(ss.str().c_str());
	LOG_INFO("---------------------------------------------------------");	
	hpms::LogBuffer::Instance().Close();

	*/
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
		ss << "Traceback: " << customLogic->GetVM()->BuildStackTrace();
		LOG_ERROR(ss.str().c_str());
	}
	
}