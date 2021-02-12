#include <iostream>
#include <windows.h>
#include <api/HPMSSimulatorAdapter.h>
#include <core/HPMSEngineFacade.h>
#include <core/HPMSRenderToTexture.h>

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
    LOG_DEBUG(ss.str().c_str());
    LOG_DEBUG("End memory dump report.");
#endif
}

class TestLogic : public hpms::CustomLogic
{
private:
    hpms::SupplierAdapter* supplier;
    bool exit;
    hpms::EntityAdapter* entity;
    hpms::EntityAdapter* depthEntity;
    hpms::LightAdapter* light;
    hpms::SceneNodeAdapter* node;
    hpms::SceneNodeAdapter* depthNode;
    unsigned int fps;
public:

    TestLogic(hpms::SupplierAdapter* supplier) : supplier(supplier), exit(false)
    {}

    virtual ~TestLogic()
    {
        hpms::SafeDelete(supplier);
    }

    virtual void OnCreate() override
    {
        std::cout << "Scene user setup starting..." << std::endl;
        supplier->SetAmbientLight(glm::vec3(0.1, 0.1, 0.1));
        supplier->GetCamera()->SetNear(0.5);
        supplier->GetCamera()->SetFar(50);
        supplier->GetCamera()->SetPosition(glm::vec3(5, 5, 5));
        supplier->GetCamera()->LookAt(glm::vec3(0, 0, 0));
        entity = supplier->CreateEntity("Cube.mesh");
        node = supplier->GetRootSceneNode()->CreateChild("CubeNode");
        node->AttachObject(entity);
        depthEntity = supplier->CreateEntity("DepthCube.mesh");
        depthEntity->SetMode(hpms::EntityMode::DEPTH_ONLY);
        depthNode = supplier->GetRootSceneNode()->CreateChild("DepthCubeNode");
        depthNode->AttachObject(depthEntity);
        light = supplier->CreateLight(0.5, 0.5, 0.5);
        light->SetPosition(glm::vec3(5, 5, 5));
        std::cout << "Scene user setup done." << std::endl;

    }

    virtual void OnUpdate(float tpf) override
    {
        auto q = node->GetRotation();
        q = q * glm::quat(glm::vec3(0, tpf, 0));
        node->SetRotation(q);

        fps = (int) (1.0 / tpf);
    }

    virtual void
    OnInput(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents,
            unsigned int x, unsigned int y) override
    {
        for (const auto& key : keyEvents)
        {
            if (key.state == hpms::KeyEvent::PRESSED_FIRST_TIME)
            {
                if (key.name == "F")
                {
                    std::cout << "FPS: " << fps << std::endl;
                }
                if (key.name == "ESC")
                {
                    exit = true;
                }
            }
        }
    }

    virtual void OnDestroy() override
    {
        hpms::SafeDelete(light);
        hpms::SafeDelete(node);
        hpms::SafeDelete(entity);
        hpms::SafeDelete(depthNode);
        hpms::SafeDelete(depthEntity);
    }

    virtual bool TriggerStop() override
    {
        return exit;
    }
};


int DynamicCpTest()
{
    hpms::WindowSettings s;
    s.name = "Demo";
    s.width = 640;
    s.height = 400;
    hpms::InitContext(s, 3);
    auto* supplier = hpms::CreateSupplier();
    std::cout << "Backend implementation: " << supplier->GetImplName() << std::endl;
    auto* customLogic = hpms::SafeNew<TestLogic>(supplier);
    auto* simulator = hpms::CreateSimulator(customLogic);
    simulator->Run();
    hpms::SafeDelete(customLogic);
    hpms::DestroySimulator(simulator);
    hpms::DestroyContext();
}

#if defined(_WIN32) || defined(WIN32)

INT WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR cmdLine, INT)
#else
int main(int argc, char *argv[])
#endif
{
    try
    {

        DynamicCpTest();
        Dump();

        return 0;
    } catch (std::exception& e)
    {
        std::cerr << e.what() << std::endl;
    }
}