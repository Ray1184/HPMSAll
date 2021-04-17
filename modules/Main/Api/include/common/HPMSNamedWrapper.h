/*!
 * File HPMSWrapper.h
 */


#pragma once

#include <string>
#include <common/HPMSObject.h>
#include <common/HPMSUtils.h>

namespace hpms
{
    template<typename T>
    class NamedWrapper : public Object
    {
    public:
        explicit NamedWrapper(T* object, const std::string& name) : name(name), object(object)
        {

        }

        virtual ~NamedWrapper()
        {
            hpms::SafeDeleteRaw(object);
        }


        inline T* GetWrappedObject()
        {
            return object;
        }

        inline const std::string Name() const override
        {
            return name;
        }

    private:
        std::string name;

        T* object;

    };
}