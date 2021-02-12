/*!
 * File Controller.h
 */

#pragma once

#include <unordered_map>

namespace hpms
{
    class Controller : public HPMSObject
    {
    protected:
        bool active{true};
    public:
        virtual void Update() = 0;

        inline void SetActive(bool active)
        {
            Controller::active = active;
        }

        inline bool IsActive() const
        {
            return active;
        }
    };
}
