/*!
 * File HPMSRenderToTexture.cpp
 */

#include <core/HPMSRenderToTexture.h>
#include <OgreOverlay.h>

hpms::RenderToTexture::RenderToTexture(hpms::OgreContext* ctx, unsigned int fbWidth, unsigned int fbHeight) : ctx(ctx),
                                                                                                              fbWidth(fbWidth),
                                                                                                              fbHeight(fbHeight),
                                                                                                              renderScreen(nullptr),
                                                                                                              fbNode(nullptr)
{
    Initialize();
}

void hpms::RenderToTexture::Initialize()
{

    auto texture = Ogre::TextureManager::getSingleton().createManual(RTT_TEXTURE_NAME,
                                                                     Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME,
                                                                     Ogre::TEX_TYPE_2D, fbWidth, fbHeight,
                                                                     0,
                                                                     Ogre::PF_R8G8B8,
                                                                     (int) Ogre::TU_RENDERTARGET);

    auto* renderTexture = texture->getBuffer()->getRenderTarget();

    renderTexture->addViewport(ctx->GetCamera());
    renderTexture->getViewport(0)->setClearEveryFrame(true);

    // NOTE: Overlay doesn't work well with RTT, so are excluded and pixelated manually (see HPMSOverlayImageAdaptee.cpp).
    renderTexture->getViewport(0)->setOverlaysEnabled(true);
    renderTexture->getViewport(0)->setAutoUpdated(true);
    renderTexture->getViewport(0)->setBackgroundColour(Ogre::ColourValue(0, 0, 0));

    renderScreen = hpms::SafeNewRaw<Ogre::Rectangle2D>(true);
    renderScreen->setCorners(-1, 1.0, 1.0, -1);
    renderScreen->setBoundingBox(Ogre::AxisAlignedBox::BOX_INFINITE);

    fbNode = ctx->GetSceneManager()->getRootSceneNode()->createChildSceneNode("FrameBufferNode");
    fbNode->attachObject(renderScreen);

    Ogre::MaterialPtr renderMaterial =
            Ogre::MaterialManager::getSingleton().create(
                    RTT_MATERIAL_NAME,
                    Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);

    renderMaterial->getTechnique(0)->getPass(0)->setLightingEnabled(false);
    Ogre::TextureUnitState* textState = renderMaterial->getTechnique(0)->getPass(0)->createTextureUnitState(
            RTT_TEXTURE_NAME);
    textState->setTextureFiltering(Ogre::TFO_NONE);

    renderScreen->setMaterial(renderMaterial);

    renderTexture->addListener(this);
}


hpms::RenderToTexture::~RenderToTexture()
{
    hpms::SafeDeleteRaw(renderScreen);
    ctx->GetSceneManager()->destroySceneNode(fbNode);
}


void hpms::RenderToTexture::preRenderTargetUpdate(const Ogre::RenderTargetEvent& evt)
{
    renderScreen->setVisible(false);

    // NOTE: Overlays are rendered twice (original and RTT), so we need to hide the original after render and show again before.
    auto it = Ogre::OverlayManager::getSingletonPtr()->getOverlayIterator();
    for (auto over : it) {
        over.second->show();
    }
}

void hpms::RenderToTexture::postRenderTargetUpdate(const Ogre::RenderTargetEvent& evt)
{
    renderScreen->setVisible(true);

    // NOTE: Overlays are rendered twice (original and RTT), so we need to hide the original after render and show again before.
    auto it = Ogre::OverlayManager::getSingletonPtr()->getOverlayIterator();
    for (auto over : it) {
        over.second->hide();
    }
}


