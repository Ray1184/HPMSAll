/*!
 * File HPMSTestMain.cpp
 */

#include <sstream>
#include <windows.h>
#include <api/HPMSSimulatorAdapter.h>
#include <facade/HPMSEngineFacade.h>
#include <Ogre.h>
#include <OgreOverlay.h>
#include <OgreOverlayContainer.h>
#include <OgreOverlayElement.h>
#include <core/HPMSMaterialHelper.h>
#include <OgreTextAreaOverlayElement.h>

#define WIDTH 960
#define HEIGHT 600

class TestLogic : public hpms::CustomLogic
{
public:
//    virtual void OnCreate() override
//    {
//        auto* entity = hpms::GetSupplier()->CreateEntity("Cube.mesh");
//        hpms::GetSupplier()->GetRootSceneNode()->AttachObject(entity);
//        hpms::GetSupplier()->GetCamera()->SetPosition(glm::vec3(5, 5, 5));
//        hpms::GetSupplier()->SetAmbientLight(glm::vec3(0.1, 0.1, 0.1));
//        auto* light = hpms::GetSupplier()->CreateLight(0.5, 0.5, 0.5);
//
    /*auto* overlayManager = Ogre::OverlayManager::getSingletonPtr();
    auto* overlay = overlayManager->create("Overlay_");
    auto* ogrePanel = dynamic_cast<Ogre::OverlayContainer*>(overlayManager->createOverlayElement("Panel", "OverlayElement_"));
    unsigned int width, height;
    auto material = CreateTexturedMaterial("Derceto.png", &width, &height, "Test");
    material->getTechnique(0)->getPass(0)->setSceneBlending(Ogre::SceneBlendType::SBT_ADD);
    ogrePanel->setMaterial(material);
//
//        // NOTE: Overlay doesn't work well with RTT, so are excluded and pixelated manually (see HPMSRenderToTexture.cpp).
//        unsigned int pixelation = 1;
//        ogrePanel->setMetricsMode(Ogre::GMM_PIXELS);
//        ogrePanel->setPosition(WIDTH, HEIGHT);
//        ogrePanel->setDimensions(width, height);
//        ogrePanel->show();
//        overlay->add2D(ogrePanel);
//        //overlay->setZOrder(zOrder);
//        //SetBlending(BlendingType::NORMAL);
//        overlay->show();*/
//    }
//
//    virtual void OnUpdate(float tpf) override
//    {
//
//    }
//
//    virtual void OnInput(const std::vector<hpms::KeyEvent>& keyEvents, const std::vector<hpms::MouseEvent>& mouseButtonEvents, unsigned int x, unsigned int y) override
//    {
//
//    }
//
//    virtual void OnDestroy() override
//    {
//
//    }
//
//    virtual bool TriggerStop() override
//    {
//        return false;
//    }
//
//    inline static Ogre::MaterialPtr
//    CreateTexturedMaterial(const std::string& textureName, unsigned int* width = nullptr, unsigned int* height = nullptr, std::string materialName = "_undef_")
//    {
//        Ogre::TexturePtr texture = Ogre::TextureManager::getSingleton().load(textureName, "General");
//        if (width)
//        {
//            *width = texture->getWidth();
//        }
//
//        if (height)
//        {
//            *height = texture->getHeight();
//        }
//
//        if (materialName == "_undef_") {
//            materialName = textureName;
//        }
//        auto material = Ogre::MaterialManager::getSingleton().create("Material_" + materialName,
//                                                                     Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
//
//        auto* textState = material->getTechnique(0)->getPass(0)->createTextureUnitState(texture->getName());
//        textState->setTextureFiltering(Ogre::TFO_NONE);
//        material->getTechnique(0)->getPass(0)->setDepthCheckEnabled(false);
//        material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(false);
//        material->getTechnique(0)->getPass(0)->setLightingEnabled(false);
//
//        return material;
//    }

private:
    hpms::SupplierAdapter* supplier;
    bool exit;
    hpms::EntityAdapter* entity;
    hpms::EntityAdapter* depthEntity;
    hpms::LightAdapter* light;
    hpms::SceneNodeAdapter* node;
    hpms::SceneNodeAdapter* depthNode;
    hpms::WalkmapAdapter* walkmap;
    hpms::BackgroundImageAdapter* background;
    //hpms::OverlayImageAdapter* overlay;
    hpms::OverlayTextAreaAdapter* textArea;
    unsigned int fps;
public:

    TestLogic() : exit(false)
    {

    }

    virtual ~TestLogic()
    {

    }


    virtual void OnCreate() override
    {
        supplier = hpms::GetSupplier();
        //std::cout << "Scene user setup starting..." << std::endl;
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
        walkmap = supplier->CreateWalkmap("Basement.hrdat");
        background = supplier->CreateBackgroundImage("Derceto.png");
        background->Show();
        textArea = supplier->CreateTextArea("PROVA!!!", "Typewriter", 15, 0, 0, WIDTH, HEIGHT, 10);
        textArea->SetText("AMBARABACICCICOCOO");
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
                if (key.name == "ESC")
                {
                    exit = true;
                }
            }
        }
    }

    virtual void OnDestroy() override
    {
        //hpms::SafeDelete(overlay);
        hpms::SafeDelete(background);
        hpms::SafeDelete(walkmap);
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

#if defined(_WIN32) || defined(WIN32)

INT WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR cmdLine, INT)
#else
int main(int argc, char *argv[])
#endif
{

    hpms::WindowSettings s;
    s.name = "Demo";
    s.width = WIDTH;
    s.height = HEIGHT;
    s.pixelRatio = WIDTH / 320;
    auto* customLogic = hpms::SafeNew<TestLogic>();
    hpms::InitContext(s, customLogic);
    auto* simulator = hpms::GetSimulator();
    simulator->Run();
    hpms::SafeDelete(customLogic);
    hpms::DestroyContext();
}

