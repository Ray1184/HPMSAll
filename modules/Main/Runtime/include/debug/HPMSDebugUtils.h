/*!
 * File HPMSDebugUtils.h
 */


#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <facade/HPMSApiFacade.h>
#include <sstream>

#define RED glm::vec4(1, 0, 0, 1)
#define GREEN glm::vec4(0, 1, 0, 1)
#define BLUE glm::vec4(0, 0, 1, 1)
#define WHITE glm::vec4(1, 1, 1, 1)
#define T_WHITE glm::vec4(1, 1, 1, 0.5)

namespace hpms
{
    class DebugUtils
    {
    public:
        inline static void ClearAllDraws()
        {
            auto* drawer = hpms::GetNative();
            drawer->Clear();
        }
        inline static void DrawBoundingBox(hpms::ActorAdapter* actor) {

            auto* drawer = hpms::GetNative();
            drawer->BeginDraw(BLUE, BLUE);
            drawer->DrawCircle(actor->GetPosition(), actor->GetBoundingRadius() * actor->GetScale().x);
            drawer->EndDraw();
        }

        inline static void DrawWalkmap(hpms::WalkmapAdapter* walkmap)
        {
            auto* drawer = hpms::GetNative();
            auto drawProcess = [drawer](hpms::TriangleAdapter* tri)
            {
                DrawTriangle(drawer, tri);
            };
            drawer->BeginDraw(T_WHITE, T_WHITE);
            walkmap->Visit(drawProcess);
            drawer->EndDraw();
        }

        inline static void DrawCollisorSector(hpms::Collisor* collisor)
        {
            auto* drawer = hpms::GetNative();
            auto* tri = collisor->GetCurrentTriangle();
            if (tri)
            {
                drawer->BeginDraw(RED, RED);
                DrawTriangle(drawer, tri);
                drawer->EndDraw();
            }
        }

        inline static void DrawSampledSector(hpms::WalkmapAdapter* walkmap, hpms::ActorAdapter* actor)
        {
            auto* drawer = hpms::GetNative();
            auto* tri = walkmap->SampleTriangle(actor->GetPosition(), 0.0);
            if (tri)
            {
                drawer->BeginDraw(RED, RED);
                DrawTriangle(drawer, tri);
                drawer->EndDraw();
            }
        }

    private:
        inline static void DrawTriangle(hpms::NativeAdapter* drawer, hpms::TriangleAdapter* tri)
        {
            drawer->DrawLine(glm::vec3(tri->X1(), tri->Y1(), tri->Z1()), glm::vec3(tri->X2(), tri->Y2(), tri->Z2()));
            drawer->DrawLine(glm::vec3(tri->X2(), tri->Y2(), tri->Z2()), glm::vec3(tri->X3(), tri->Y3(), tri->Z3()));
            drawer->DrawLine(glm::vec3(tri->X3(), tri->Y3(), tri->Z3()), glm::vec3(tri->X1(), tri->Y1(), tri->Z1()));
        }
    };
}