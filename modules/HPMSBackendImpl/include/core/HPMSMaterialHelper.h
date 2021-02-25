/*!
 * File HPMSMaterialHelper.h
 */

#pragma once

#include <Ogre.h>
#include <OgreRectangle2D.h>
#include <OgreTextureManager.h>

namespace hpms
{

    class MaterialHelper
    {
    public:
        inline static Ogre::MaterialPtr
        CreateTexturedMaterial(const std::string& textureName, unsigned int* width = nullptr, unsigned int* height = nullptr)
        {
            Ogre::TexturePtr texture = Ogre::TextureManager::getSingleton().load(textureName, "General");
            if (width)
            {
                *width = texture->getWidth();
            }

            if (height)
            {
                *height = texture->getHeight();
            }

            auto material = Ogre::MaterialManager::getSingleton().create("Material_" + textureName,
                                                                              Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);

            auto* textState = material->getTechnique(0)->getPass(0)->createTextureUnitState(texture->getName());
            textState->setTextureFiltering(Ogre::TFO_NONE);
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
