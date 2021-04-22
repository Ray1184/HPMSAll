/*!
 * File HPMSDebugUtils.h
 */


#pragma once

#include <api/HPMSWalkmapAdapter.h>

namespace hpms {
    class HPMSDebugUtils {
    public:
        inline static void DrawWalkmap(hpms::WalkmapAdapter* walkmap)
        {
            auto drawProcess = [&inputFiles](hpms::TriangleAdapter* tri)
            {

            };
            walkmap->Visit(drawProcess);
        }
    };
}