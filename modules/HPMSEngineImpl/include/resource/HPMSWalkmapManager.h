/*!
 * File HPMSWalkmapManager.h
 */


#pragma once

#include <OgreResourceManager.h>
#include <OgreScriptCompiler.h>
#include <common/HPMSUtils.h>
#include <resource/HPMSWalkmap.h>
#include <common/HPMSObject.h>

namespace hpms
{
    class WalkmapManager : public Ogre::ResourceManager, public hpms::Object
    {

    protected:
        inline Ogre::Resource*
        createImpl(const Ogre::String& name, Ogre::ResourceHandle handle, const Ogre::String& group, bool isManual,
                   Ogre::ManualResourceLoader* loader, const Ogre::NameValuePairList* createParams) override
        {
            return hpms::SafeNewRaw<hpms::Walkmap>(this, name, handle, group);
        }

    public:

        WalkmapManager();

        virtual ~WalkmapManager();

        hpms::WalkmapPtr Create(const std::string& name, const Ogre::String& group = Ogre::ResourceGroupManager::AUTODETECT_RESOURCE_GROUP_NAME);

        static WalkmapManager& GetSingleton();

        static WalkmapManager* GetSingletonPtr();

        inline const std::string Name() const override
        {
            return "WalkmapManager";
        }
    };
}