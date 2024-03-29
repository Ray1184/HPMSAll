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
#define T_WHITE glm::vec4(1, 1, 1, 0.3)

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

        inline static void DrawBoundingBox(hpms::Collisor* actor)
        {

            auto* drawer = hpms::GetNative();
            drawer->BeginDraw(BLUE, BLUE);
            drawer->DrawCircle(actor->GetPosition(), actor->GetScaledBoundingRadius());
            drawer->EndDraw();

            drawer->BeginDraw(GREEN, GREEN);
            for (size_t i = 0; i < actor->GetScaledBoundingRect().size() - 1; i++)
            {
                const auto& a = actor->GetScaledBoundingRect()[i];
                const auto& b = actor->GetScaledBoundingRect()[i + 1];
                drawer->DrawLine(V2_TO_V3(a), V2_TO_V3(b));
            }
            const auto& a = actor->GetScaledBoundingRect()[actor->GetScaledBoundingRect().size() - 1];
            const auto& b = actor->GetScaledBoundingRect()[0];
            drawer->DrawLine(V2_TO_V3(a), V2_TO_V3(b));
            drawer->EndDraw();
        }

        inline static void DrawPerimeter(hpms::WalkmapAdapter* walkmap)
        {
            auto* drawer = hpms::GetNative();
            auto drawProcess = [drawer](const glm::vec2& posA, const glm::vec2& posB)
            {
                drawer->BeginDraw(GREEN, GREEN);
                drawer->DrawLine(V2_TO_V3(posA), V2_TO_V3(posB));
                drawer->EndDraw();
                return false;
            };

            walkmap->ForEachSide(drawProcess);

        }

        inline static void DrawWalkmap(hpms::WalkmapAdapter* walkmap)
        {
            auto* drawer = hpms::GetNative();
            auto drawProcess = [drawer](hpms::TriangleAdapter* tri)
            {
                DrawTriangle(drawer, tri);
                return false;
            };
            drawer->BeginDraw(T_WHITE, T_WHITE);
            walkmap->ForEachTriangle(drawProcess);
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