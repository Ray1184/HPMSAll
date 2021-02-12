/*!
 * File HPMSImageAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>

namespace hpms
{

    class BackgroundImageAdapter : public ActorAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "ImageAdapter";
        }

        inline virtual ~BackgroundImageAdapter()
        {

        }

    };
}