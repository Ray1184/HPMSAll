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
        CreateTexturedMaterial(const std::string& textureName, unsigned int* width = nullptr, unsigned int* height = nullptr, std::string materialName = "_undef_")
        {
            auto material = Ogre::MaterialManager::getSingleton().getByName("Material_" + materialName);
            if (material.get())
            {
                return material;
            }

            Ogre::TexturePtr texture = Ogre::TextureManager::getSingleton().load(textureName, "General");
            if (width)
            {
                *width = texture->getWidth();
            }

            if (height)
            {
                *height = texture->getHeight();
            }

            if (materialName == "_undef_")
            {
                materialName = textureName;
            }
            material = Ogre::MaterialManager::getSingleton().create("Material_" + materialName,
                                                                    Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
            material->getTechnique(0)->getPass(0)->createTextureUnitState(texture->getName());
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

        inline static Ogre::MaterialPtr CreateGuiMaterial()
        {
            auto renderMaterial = Ogre::MaterialManager::getSingleton().getByName("GuiMaterial");
            if (renderMaterial.get())
            {
                return renderMaterial;
            }
            renderMaterial = Ogre::MaterialManager::getSingleton().create("GuiMaterial", Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
            Ogre::Technique* matTechnique = renderMaterial->createTechnique();
            matTechnique->createPass();
            renderMaterial->getTechnique(0)->getPass(0)->setLightingEnabled(false);
            renderMaterial->getTechnique(0)->getPass(0)->setColourWriteEnabled(false);
            return renderMaterial;

        }
    };
}
