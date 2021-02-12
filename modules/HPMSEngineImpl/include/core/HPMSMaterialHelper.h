/*!
 * File HPMSMaterialHelper.h
 */

#pragma once

#include <Ogre.h>
#include <OgreRectangle2D.h>

namespace hpms
{

    class MaterialHelper
    {
    public:
        inline static Ogre::MaterialPtr
        CreateTexturedMaterial(Ogre::Image& image, unsigned int width, unsigned int height)
        {
            Ogre::TexturePtr texture = Ogre::TextureManager::getSingleton().createManual(
                    "GeneratedTexture",
                    Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME,
                    Ogre::TEX_TYPE_2D,
                    width, height, 0, Ogre::PF_BYTE_BGR,
                    Ogre::TU_DYNAMIC_WRITE_ONLY_DISCARDABLE);

            texture->loadImage(image);

            auto material = Ogre::MaterialManager::getSingleton().create("GeneratedMaterial",
                                                                              Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);

            material->getTechnique(0)->getPass(0)->createTextureUnitState("GeneratedTexture");
            material->getTechnique(0)->getPass(0)->setDepthCheckEnabled(false);
            material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(false);
            material->getTechnique(0)->getPass(0)->setLightingEnabled(false);
            SetMaterialTextureAddMode(material);
            return material;
        }

        inline static void SetMaterialTextureAddMode(const Ogre::MaterialPtr& material)
        {
            material->getTechnique(0)->getPass(0)->setSceneBlending(Ogre::SceneBlendType::SBT_ADD);
        }

        inline static void SetMaterialTextureStandardMode(const Ogre::MaterialPtr& material)
        {
            material->getTechnique(0)->getPass(0)->setSceneBlending(Ogre::SceneBlendType::SBT_TRANSPARENT_ALPHA);
        }
    };
}
