/*!
 * File HPMSAdapteeCommon.h
 */


#pragma once

#include <core/HPMSOgreContext.h>
#include <common/HPMSUtils.h>

namespace hpms
{
    class AdapteeCommon
    {
    public:
        inline AdapteeCommon(OgreContext* ctx) : ctx(ctx)
        {}

        inline void Check() const
        {
            HPMS_ASSERT(ctx, "Context cannot be null");
        }

        template <typename T>
        inline void Check(T* ptr) const
        {
            HPMS_ASSERT(ptr, "Adaptee cannot be null");
        }


    protected:
        hpms::OgreContext* ctx;

    };
}