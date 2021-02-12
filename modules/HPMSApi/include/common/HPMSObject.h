/*!
 * File HPMSObject.h
 */

#pragma once

#include <string>

namespace hpms
{
    class Object
    {
    private:
        std::string exportName;

    public:
        virtual const std::string Name() const = 0;

        const std::string& GetExportName() const
        {
            return exportName;
        }

        void SetExportName(const std::string& exportName)
        {
            Object::exportName = exportName;
        }

    };
}
