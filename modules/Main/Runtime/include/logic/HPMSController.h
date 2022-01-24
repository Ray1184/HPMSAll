/*!
 * File HPMSController.h
 */

#pragma once

#include <unordered_map>
#include <common/HPMSObject.h>

namespace hpms
{
    class Controller : public Object
    {
    protected:
        bool active{true};
    public:
        virtual void Update(float tpf) = 0;

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
