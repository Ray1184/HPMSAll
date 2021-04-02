/*!
 * File HPMSImageAdapter.h
 */

#pragma once

namespace hpms
{
    enum BlendingType
    {
        NORMAL = 0,
        OVERLAY = 1
    };

    class ImageAdapter
    {
    public:
        virtual void Show() = 0;

        virtual void Hide() = 0;
    };
}
