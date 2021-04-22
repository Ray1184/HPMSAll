/*!
 * File HPMSDebugUtils.h
 */


#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <facade/HPMSApiFacade.h>

namespace hpms {
    class DebugUtils {
    public:
        inline static void DrawWalkmap(hpms::WalkmapAdapter* walkmap)
        {
            auto drawProcess = [](hpms::TriangleAdapter* tri)
            {
                auto* drawer = hpms::GetNative();
                drawer->DrawLine(glm::vec3(tri->X1(), tri->Y1(), tri->Z1()), glm::vec3(tri->X2(), tri->Y2(), tri->Z2()));
                drawer->DrawLine(glm::vec3(tri->X2(), tri->Y2(), tri->Z2()), glm::vec3(tri->X3(), tri->Y3(), tri->Z3()));
                drawer->DrawLine(glm::vec3(tri->X3(), tri->Y3(), tri->Z3()), glm::vec3(tri->X1(), tri->Y1(), tri->Z1()));
            };
            walkmap->Visit(drawProcess);
        }
    };
}