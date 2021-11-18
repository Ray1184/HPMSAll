/*!
 * File HPMSRenderToTexture.h
 */


#pragma once

#include <OgreRectangle2D.h>
#include <core/HPMSOgreContext.h>

#define RTT_MATERIAL_NAME "RTTMaterial"
#define RTT_TEXTURE_NAME "RTTTex"

namespace hpms
{
    class RenderToTexture : public hpms::Object, public Ogre::RenderTargetListener
    {
    private:
        unsigned int fbWidth;
        unsigned int fbHeight;
        Ogre::Rectangle2D* renderScreen;
        hpms::OgreContext* ctx;
        Ogre::SceneNode* fbNode;
        bool loaded;

        void Initialize();

    public:
        RenderToTexture(hpms::OgreContext* ctx, unsigned int fbWidth, unsigned int fbHeight);

        virtual ~RenderToTexture();

        virtual void Shutdown();

        virtual void preRenderTargetUpdate(const Ogre::RenderTargetEvent& evt) override;

        virtual void postRenderTargetUpdate(const Ogre::RenderTargetEvent& evt) override;

        inline size_t GetFbWidth() const
        {
            return fbWidth;
        }

        inline size_t GetFbHeight() const
        {
            return fbHeight;
        }

        inline Ogre::Rectangle2D* GetRenderScreen() const
        {
            return renderScreen;
        }

        inline const std::string Name() const override
        {
            return "RenderToTexture";
        }
    };
}