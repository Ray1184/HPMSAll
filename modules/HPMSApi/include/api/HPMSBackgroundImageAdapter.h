/*!
 * File HPMSImageAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSImageAdapter.h>

namespace hpms
{

    class BackgroundImageAdapter : public ActorAdapter, public ImageAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "BackgroundImageAdapter";
        }

        inline virtual ~BackgroundImageAdapter()
        {

        }

    };
}