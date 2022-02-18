/*!
 * File HPMSOgreContext.h
 */


#pragma once

#include <Ogre.h>
#include <OgreFileSystemLayer.h>
#include <common/HPMSNamedWrapper.h>
#ifdef CROSS_BUILD
#include <SDL2/SDL.h>
#else
#include <SDL.h>
#endif
#include <input/HPMSInputHandler.h>
#include <OgreOverlayManager.h>
#include <OgreOverlaySystem.h>

namespace hpms
{

    struct NativeWindowPair
    {
        Ogre::RenderWindow* render{nullptr};
        SDL_Window* native{nullptr};
    };

    struct OgreWindowSettings
    {
        unsigned int width{320};
        unsigned int height{200};
        unsigned int pixelRatio;
        std::string name{"Ogre Template"};
        bool fullScreen{false};
    };

    class OgreContext : public hpms::Object
    {
    private:
        OgreWindowSettings settings;

        bool Setup();

        void InitRoot();

        bool CreateWindowPair(const OgreWindowSettings& settings);

        void CreateViewports();

        void SetupResources();

        void CreateResourceListener();

        void LoadResources();
    public:
        explicit OgreContext(const OgreWindowSettings& settings);

        virtual ~OgreContext();

        inline virtual const std::string Name() const override
        {
            return "OgreContext";
        }

        inline Ogre::FileSystemLayer* GetFsLayer() const
        {
            return fsLayer;
        }

        inline Ogre::Root* GetRoot() const
        {
            return root;
        }

        inline Ogre::OverlayManager* GetOverlayManager() const
        {
            return overlayManager;
        }

        inline Ogre::LogManager* GetLogManager() const
        {
            return logManager;
        }

        inline Ogre::Camera* GetCamera() const
        {
            return camera;
        }

        inline Ogre::SceneManager* GetSceneManager() const
        {
            return sceneMgr;
        }

        inline Ogre::RenderWindow* GetRenderWindow() const
        {
            return windowPair.render;
        }

        inline const OgreWindowSettings& GetSettings() const
        {
            return settings;
        }

    private:
        Ogre::FileSystemLayer* fsLayer;
        Ogre::OverlayManager* overlayManager;
        Ogre::OverlaySystem* overlaySystem;
        Ogre::LogManager* logManager;
        Ogre::Root* root;
        Ogre::String resourcesCfg;
        Ogre::String pluginsCfg;
        Ogre::Camera* camera;
        Ogre::SceneManager* sceneMgr;
        NativeWindowPair windowPair;

    };
}
