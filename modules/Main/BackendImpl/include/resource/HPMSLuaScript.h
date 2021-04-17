/*!
 * File HPMSLuaScript.h
 */

#pragma once

#include <OgreResource.h>
#include <OgreResourceManager.h>
#include <common/HPMSObject.h>

namespace hpms
{

    class LuaScript : public Ogre::Resource, public hpms::Object
    {
    private:
        std::string scriptContent;
    protected:
        void loadImpl() override;

        void unloadImpl() override;

        size_t calculateSize() const override;

    public:
        LuaScript(Ogre::ResourceManager* creator, const std::string& name,
                  Ogre::ResourceHandle handle, const std::string& group);

        virtual ~LuaScript();

        inline const std::string& GetScriptContent() const
        {
            return scriptContent;
        }

        inline const std::string Name() const override
        {
            return "LuaScript";
        }

    };

    typedef Ogre::SharedPtr<LuaScript> LuaScriptPtr;
}
