/*!
 * File HPMSEntityHelper.h
 */


#pragma once

#include <Ogre.h>

namespace hpms
{
    class EntityHelper
    {


    public:
        inline static void SetWriteDepthOnly(Ogre::Entity* entity)
        {
            for (auto sub : entity->getSubEntities())
            {
                auto material = sub->getMaterial();
                material->getTechnique(0)->getPass(0)->setColourWriteEnabled(false);
                material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(true);
            }
            entity->setRenderQueueGroup(0);
        }

        inline static void SetWriteColorOnly(Ogre::Entity* entity)
        {
            for (auto sub : entity->getSubEntities())
            {
                auto material = sub->getMaterial();
                material->getTechnique(0)->getPass(0)->setColourWriteEnabled(true);
                material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(false);
            }
        }

        inline static void SetWriteDepthAndColor(Ogre::Entity* entity)
        {
            for (auto sub : entity->getSubEntities())
            {
                auto material = sub->getMaterial();
                material->getTechnique(0)->getPass(0)->setColourWriteEnabled(true);
                material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(true);
            }
        }

        inline static void SetWriteNothing(Ogre::Entity* entity)
        {
            for (auto sub : entity->getSubEntities())
            {
                auto material = sub->getMaterial();
                material->getTechnique(0)->getPass(0)->setColourWriteEnabled(false);
                material->getTechnique(0)->getPass(0)->setDepthWriteEnabled(false);
            }
        }


    };
}