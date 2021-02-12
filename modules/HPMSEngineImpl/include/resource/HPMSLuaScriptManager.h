/*!
 * File HPMSLuaScriptManager.h
 */


#pragma once

#include <OgreResourceManager.h>
#include <OgreScriptCompiler.h>
#include <common/HPMSUtils.h>
#include <resource/HPMSLuaScript.h>
#include <common/HPMSObject.h>

namespace hpms
{
    class LuaScriptManager : public Ogre::ResourceManager, public hpms::Object
    {

    protected:
        inline Ogre::Resource*
        createImpl(const Ogre::String& name, Ogre::ResourceHandle handle, const Ogre::String& group, bool isManual,
                   Ogre::ManualResourceLoader* loader, const Ogre::NameValuePairList* createParams) override
        {
            return hpms::SafeNewRaw<hpms::LuaScript>(this, name, handle, group);
        }

    public:

        LuaScriptManager();

        virtual ~LuaScriptManager();

        hpms::LuaScriptPtr Create(const std::string& name, const Ogre::String& group = Ogre::ResourceGroupManager::AUTODETECT_RESOURCE_GROUP_NAME);

        static LuaScriptManager& GetSingleton();

        static LuaScriptManager* GetSingletonPtr();

        inline const std::string Name() const override
        {
            return "LuaScriptManager";
        }
    };
}