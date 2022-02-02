/*!
 * File HPMSOgreContextAdaptee.cpp
 */

#include <core/HPMSOgreContext.h>
#include <SDL2/SDL_syswm.h>
#include <resource/HPMSLuaScriptManager.h>

hpms::OgreContext::OgreContext(const OgreWindowSettings& settings) : root(nullptr),
                                   camera(nullptr),
                                   sceneMgr(nullptr),
                                   resourcesCfg(OGRE_RESOURCES_FILE),
                                   pluginsCfg(OGRE_PLUGINS_FILE),
                                   settings(settings)
{
    logManager = hpms::SafeNewRaw<Ogre::LogManager>();
    logManager->createLog(OGRE_LOG_FILE, true, false, false);
    fsLayer = hpms::SafeNewRaw<Ogre::FileSystemLayer>("FSData");
    root = hpms::SafeNewRaw<Ogre::Root>(pluginsCfg,
                                        fsLayer->getWritablePath(
                                            OGRE_CONFIG_FILE),
                                        fsLayer->getWritablePath(
                                            OGRE_LOG_FILE));
    overlaySystem = hpms::SafeNewRaw<Ogre::OverlaySystem>();
    overlayManager = Ogre::OverlayManager::getSingletonPtr();

    Setup();

}

hpms::OgreContext::~OgreContext()
{   
    root->destroySceneManager(sceneMgr);
    hpms::LuaScriptManager::GetSingleton().unloadAll();
    hpms::SafeDeleteRaw(overlaySystem);
    hpms::SafeDeleteRaw(root);
    hpms::SafeDeleteRaw(fsLayer);
    hpms::SafeDeleteRaw(logManager);
}

bool hpms::OgreContext::CreateWindowPair(const OgreWindowSettings& settings)
{
    try
    {
        auto miscParams = Ogre::NameValuePairList();

        if (!SDL_WasInit(SDL_INIT_VIDEO))
        {
            SDL_InitSubSystem(SDL_INIT_VIDEO);
        }
        SDL_ShowCursor(false);
        auto p = root->getRenderSystem()->getRenderWindowDescription();
        miscParams.insert(p.miscParams.begin(), p.miscParams.end());
        p.miscParams = miscParams;
        p.name = settings.name;
        p.useFullScreen = settings.fullScreen;


        if (settings.width > 0 && settings.height > 0)
        {
            p.width = settings.width;
            p.height = settings.height;
        }

        int flags = p.useFullScreen ? SDL_WINDOW_FULLSCREEN : SDL_WINDOW_RESIZABLE;
        int d = Ogre::StringConverter::parseInt(miscParams["monitorIndex"], 1) - 1;
        windowPair.native = SDL_CreateWindow(p.name.c_str(), SDL_WINDOWPOS_UNDEFINED_DISPLAY(d),
                                             SDL_WINDOWPOS_UNDEFINED_DISPLAY(d), p.width, p.height, flags);

#if OGRE_PLATFORM != OGRE_PLATFORM_EMSCRIPTEN
        SDL_SysWMinfo wmInfo;
        SDL_VERSION(&wmInfo.version);
        SDL_GetWindowWMInfo(windowPair.native, &wmInfo);
#endif

#if OGRE_PLATFORM == OGRE_PLATFORM_LINUX
        p.miscParams["parentWindowHandle"] = Ogre::StringConverter::toString(size_t(wmInfo.info.x11.window));
#elif OGRE_PLATFORM == OGRE_PLATFORM_WIN32
        p.miscParams["externalWindowHandle"] = Ogre::StringConverter::toString(size_t(wmInfo.info.win.window));
#elif OGRE_PLATFORM == OGRE_PLATFORM_APPLE
        assert(wmInfo.subsystem == SDL_SYSWM_COCOA);
        p.miscParams["externalWindowHandle"] = Ogre::StringConverter::toString(size_t(wmInfo.info.cocoa.window));
#endif
        //p.miscParams["VSync"] = "No";
        //std::string usingVSync = "Using VSYNC: " + p.miscParams["vsync"];
        //LOG_WARN(usingVSync.c_str());
        windowPair.render = root->createRenderWindow(p);
    } catch (std::exception& e)
    {
        return false;
    }
    return true;
}


void hpms::OgreContext::CreateViewports()
{
    sceneMgr = root->createSceneManager();
    sceneMgr->addRenderQueueListener(overlaySystem);
    camera = sceneMgr->createCamera(DEFAULT_CAMERA_NAME);   
    Ogre::Viewport* vp = windowPair.render->addViewport(camera);
    vp->setBackgroundColour(Ogre::ColourValue(0, 0, 0));

    camera->setAspectRatio(Ogre::Real(vp->getActualWidth()) / Ogre::Real(vp->getActualHeight()));
}

void hpms::OgreContext::InitRoot()
{
    auto* renderSystem = root->getRenderSystemByName("OpenGL Rendering Subsystem");
    //renderSystem->setConfigOption("VSync", "No");
    root->setRenderSystem(renderSystem);
    root->initialise(false);
    //renderSystem->setConfigOption("VSync", "No");
}

void hpms::OgreContext::SetupResources()
{
    Ogre::ConfigFile cf;
    cf.load(resourcesCfg);

    Ogre::String name, locationType;
    Ogre::ConfigFile::SettingsBySection_ settingsBySection = cf.getSettingsBySection();
    for (const auto& p : settingsBySection)
    {
        for (const auto& r : p.second)
        {
            locationType = r.first;
            name = r.second;
            Ogre::ResourceGroupManager::getSingleton().addResourceLocation(name, locationType);
        }
    }
}

void hpms::OgreContext::LoadResources()
{
    Ogre::ResourceGroupManager::getSingleton().initialiseAllResourceGroups();
}

void hpms::OgreContext::CreateResourceListener()
{

}

bool hpms::OgreContext::Setup()
{
    LOG_DEBUG("Initializing OGRE root");
    InitRoot();

    LOG_DEBUG("Setting up OGRE resources");
    SetupResources();

    LOG_DEBUG("Creating OGRE window");
    bool ok = CreateWindowPair(settings);
    if (!ok)
    {
        LOG_ERROR("Error creating native window handler");
        return false;
    }

    LOG_DEBUG("Creating OGRE viewport");
    CreateViewports();
    Ogre::TextureManager::getSingleton().setDefaultNumMipmaps(0);
    Ogre::MaterialManager::getSingleton().setDefaultTextureFiltering(Ogre::TextureFilterOptions::TFO_NONE);
    Ogre::MaterialManager::getSingleton().setDefaultTextureFiltering(Ogre::FilterOptions::FO_NONE, Ogre::FilterOptions::FO_NONE, Ogre::FilterOptions::FO_NONE);

    LOG_DEBUG("Creating OGRE resource listener");
    CreateResourceListener();

    LOG_DEBUG("Loading OGRE resources");
    LoadResources();

    return true;
}