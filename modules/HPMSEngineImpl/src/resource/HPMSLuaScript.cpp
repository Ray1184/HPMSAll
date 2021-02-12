/*!
 * File HPMSLuaScript.cpp
 */

#include <resource/HPMSLuaScript.h>

hpms::LuaScript::LuaScript(Ogre::ResourceManager* creator, const std::string& name, Ogre::ResourceHandle handle,
                           const std::string& group) :
        Ogre::Resource(creator, name, handle, group)
{
    createParamDictionary("LuaScript");
}

hpms::LuaScript::~LuaScript()
{
    unload();
}

void hpms::LuaScript::loadImpl()
{
    Ogre::DataStreamPtr stream = Ogre::ResourceGroupManager::getSingleton().openResource(mName);
    scriptContent = stream->getAsString();
}

void hpms::LuaScript::unloadImpl()
{
    scriptContent.clear();
}

size_t hpms::LuaScript::calculateSize() const
{
    return scriptContent.length();
}

