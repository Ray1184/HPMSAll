/*!
 * File HPMSOverlayImageAdapter.h
 */


#pragma once

#include <common/HPMSObject.h>
#include <api/HPMSActorAdapter.h>
#include <api/HPMSImageAdapter.h>
namespace hpms
{



    enum BlendingType
    {
        NORMAL = 0,
        OVERLAY = 1
    };

    class OverlayImageAdapter : public ActorAdapter, public ImageAdapter
    {
    public:
        inline const std::string Name() const override
        {
            return "OverlayImageAdapter";
        }

        inline virtual ~OverlayImageAdapter()
        {

        }

        virtual void SetBlending(BlendingType mode) = 0;

    };
}