/*!
 * File HPMSWalkmap.cpp
 */

#include <resource/HPMSWalkmap.h>

void hpms::Walkmap::loadImpl()
{
    Ogre::DataStreamPtr stream = Ogre::ResourceGroupManager::getSingleton().openResource(mName);
    size = stream->size();
    char* buffer = hpms::SafeNewArray<char>(size);
    data = hpms::SafeNew<hpms::WalkmapData>();
    stream->read(buffer, size);
    pods::InputBuffer in(buffer, size);
    POD_DESERIALIZER<decltype(in)> deserializer(in);
    if (deserializer.load(*data) != pods::Error::NoError)
    {
        std::stringstream ss;
        ss << "Impossible to deserialize walkmap " << mName;
        LOG_ERROR(ss.str().c_str());
    }

    auto p = data->GetPerimeter();
    p.AfterDeSerialization();
    data->SetPerimeter(p);
    std::vector<hpms::Polygon> obs;
    for (auto p : data->GetObstacles())
    {
        p.AfterDeSerialization();
        obs.push_back(p);
    }
    data->SetObstacles(obs);
    hpms::SafeDeleteArray(buffer);
}

void hpms::Walkmap::unloadImpl()
{
    hpms::SafeDelete(data);
}

size_t hpms::Walkmap::calculateSize() const
{
    return size;
}

hpms::Walkmap::Walkmap(Ogre::ResourceManager* creator, const std::string& name, Ogre::ResourceHandle handle,
                       const std::string& group) :
        Ogre::Resource(creator, name, handle, group)
{
    createParamDictionary("Walkmap");
}

hpms::Walkmap::~Walkmap()
{
    unload();
}
