/**
 * File HPMSLuaExtensions.h
 */

#pragma once

#include <glm/glm.hpp>
#include <cmath>
#include <algorithm>
#include <api/HPMSInputUtils.h>
#include <common/HPMSMathUtils.h>
#include <facade/HPMSApiFacade.h>
#include <logic/interaction/HPMSCollisor.h>
#include <logic/gui/HPMSGuiText.h>

namespace hpms
{

    class LuaExtensions
    {

    public:

        // LUA Math.
        static inline glm::quat MulQuat(const glm::quat& q1, const glm::quat& q2)
        {
            return q1 * q2;
        }


        static inline glm::quat FromEuler(float xAngle, float yAngle, float zAngle)
        {
            return glm::quat(glm::vec3(xAngle, yAngle, zAngle));
        }

        static inline glm::quat FromAxisQuat(float angle, float xAxis, float yAxis, float zAxis)
        {
            return glm::angleAxis(angle, glm::vec3(xAxis, yAxis, zAxis));
        }


        static inline glm::vec3 GetDirection(const glm::quat& rot, const glm::vec3& forward)
        {
            return hpms::CalcDirection(rot, forward);
        }

        static inline float ToRadians(float degrees)
        {
            return glm::radians(degrees);
        }

        static inline float ToDegrees(float radians)
        {
            return glm::degrees(radians);
        }

        static inline glm::vec3 SumVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return v1 + v2;
        }

        static inline glm::vec3 SubVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return v1 - v2;
        }

        static inline glm::vec3 MulVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return v1 * v2;
        }

        static inline glm::vec3 DivVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return v1 / v2;
        }


        static inline glm::vec3 NormVec3(const glm::vec3& v)
        {
            return glm::normalize(v);
        }

        static inline float DistVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + pow(v2.z - v1.z, 2));
        }

        static inline float DotVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return glm::dot(v1, v2);
        }

        static inline glm::vec3 CrossVec3(const glm::vec3& v1, const glm::vec3& v2)
        {
            return glm::cross(v1, v2);
        }

        static inline glm::vec4 SumVec4(const glm::vec4& v1, const glm::vec4& v2)
        {
            return v1 + v2;
        }

        static inline glm::vec4 SubVec4(const glm::vec4& v1, const glm::vec4& v2)
        {
            return v1 - v2;
        }

        static inline glm::vec4 MulVec4(const glm::vec4& v1, const glm::vec4& v2)
        {
            return v1 * v2;
        }

        static inline glm::vec4 DivVec4(const glm::vec4& v1, const glm::vec4& v2)
        {
            return v1 / v2;
        }

        static inline glm::vec4 NormVec4(const glm::vec4& v)
        {
            return glm::normalize(v);
        }

        static inline float DotVec4(const glm::vec4& v1, const glm::vec4& v2)
        {
            return glm::dot(v1, v2);
        }

        static inline glm::vec2 SumVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return v1 + v2;
        }

        static inline glm::vec2 SubVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return v1 - v2;
        }

        static inline glm::vec2 MulVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return v1 * v2;
        }

        static inline glm::vec2 DivVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return v1 / v2;
        }


        static inline glm::vec2 NormVec2(const glm::vec2& v)
        {
            return glm::normalize(v);
        }

        static inline float DistVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return (float) sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2));
        }

        static inline float DotVec2(const glm::vec2& v1, const glm::vec2& v2)
        {
            return glm::dot(v1, v2);
        }


        static inline glm::mat4 SumMat4(const glm::mat4& v1, const glm::mat4& v2)
        {
            return v1 + v2;
        }

        static inline glm::mat4 SubMat4(const glm::mat4& v1, const glm::mat4& v2)
        {
            return v1 - v2;
        }

        static inline glm::mat4 MulMat4(const glm::mat4& v1, const glm::mat4& v2)
        {
            return v1 * v2;
        }

        static inline glm::mat4 DivMat4(const glm::mat4& v1, const glm::mat4& v2)
        {
            return v1 / v2;
        }

        static inline float ElemAtMat4(const glm::mat4& v, int i, int j)
        {
            return v[i][j];
        }

        // STL utils.

        // LUA Key handling.
        static inline bool KHKeyAction(const std::vector<hpms::KeyEvent>& events, const std::string& name, int action)
        {
            for (const auto& event : events)
            {
                if (name == event.name && action == event.state)
                {
                    return true;
                }
            }
            return false;
        }

        static inline bool KHMouseAction(const std::vector<hpms::MouseEvent>& events, const std::string& name, int action)
        {
            for (const auto& event : events)
            {
                if (name == event.name && action == event.state)
                {
                    return true;
                }
            }
            return false;
        }

        // LUA Asset Manager.
        static inline hpms::EntityAdapter* AMCreateEntity(const std::string& name)
        {
            return hpms::GetSupplier()->CreateEntity(name);
        }

        static inline hpms::EntityAdapter* AMCreateDepthEntity(const std::string& name)
        {
            auto* entity = hpms::GetSupplier()->CreateEntity(name);
            entity->SetMode(EntityMode::DEPTH_ONLY);
            return entity;
        }

        static inline void AMDeleteEntity(EntityAdapter* entity)
        {
            hpms::SafeDelete(entity);
        }

        static inline hpms::SceneNodeAdapter* AMCreateNode(const std::string& name)
        {
            return hpms::GetSupplier()->GetRootSceneNode()->CreateChild(name);
        }

        static inline hpms::SceneNodeAdapter* AMCreateChildNode(const std::string& name, SceneNodeAdapter* parent)
        {
            return parent->CreateChild(name);
        }

        static inline void AMDeleteNode(SceneNodeAdapter* node)
        {
            hpms::SafeDelete(node);
        }

        static inline hpms::BackgroundImageAdapter* AMCreateBackground(const std::string& path)
        {
            return hpms::GetSupplier()->CreateBackgroundImage(path);
        }

        static inline void AMDeleteBackground(BackgroundImageAdapter* pic)
        {
            hpms::SafeDelete(pic);
        }

        static inline hpms::OverlayImageAdapter* AMCreateOverlay(const std::string& path, int x, int y, int zOrder = 0)
        {
            return hpms::GetSupplier()->CreateOverlayImage(path, x, y, zOrder);
        }

        static inline void AMDeleteOverlay(OverlayImageAdapter* pic)
        {
            hpms::SafeDelete(pic);
        }

        static inline hpms::GuiText* AMCreateTextArea(const std::string& boxName, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder = 0, const glm::vec4& color = glm::vec4(1.0, 1.0, 1.0, 1.0))
        {
            return hpms::SafeNew<hpms::GuiText>(boxName, fontName, fontSize, x, y, width, height, zOrder, color);
        }

        static inline void AMDeleteTextArea(GuiText* text)
        {
            hpms::SafeDelete(text);
        }

        static inline void LSetNodeEntity(SceneNodeAdapter* node, EntityAdapter* obj)
        {
            node->AttachObject(obj);
        }

        static inline void LSetNodeCamera(SceneNodeAdapter* node, CameraAdapter* cam)
        {
            node->AttachObject(cam);
        }

        static inline void LSRemoveNodeEntity(SceneNodeAdapter* node, EntityAdapter* obj)
        {
            node->DetachObject(obj);
        }

        static inline void LSetBoneNode(const std::string& boneNode, EntityAdapter* objToAttach, EntityAdapter* boneOwner, const glm::vec3& offsetPosition = glm::vec3(), const glm::quat& offsetRotation = glm::quat())
        {
            boneOwner->AttachObjectToBone(boneNode, objToAttach, offsetPosition, offsetRotation);
        }

        static inline hpms::WalkmapAdapter* AMCreateWalkMap(const std::string& name)
        {
            return hpms::GetSupplier()->CreateWalkmap(name);
        }

        static inline void AMDeleteWalkMap(WalkmapAdapter* walkMap)
        {
            hpms::SafeDelete(walkMap);
        }

        static inline hpms::Collisor* AMCreateEntityCollisor(EntityAdapter* entity, WalkmapAdapter* walkMap, float tolerance)
        {
            auto* c = hpms::SafeNew<hpms::Collisor>(entity, walkMap, tolerance);
            return c;
        }

        static inline hpms::Collisor* AMCreateNodeCollisor(SceneNodeAdapter* node, WalkmapAdapter* walkMap, float tolerance)
        {
            auto* c = hpms::SafeNew<hpms::Collisor>(node, walkMap, tolerance);
            return c;
        }


        static inline void AMDeleteCollisor(Collisor* collisor)
        {
            hpms::SafeDelete(collisor);
        }

        static inline hpms::LightAdapter* AMCreateLight(const glm::vec3& color)
        {
            return hpms::GetSupplier()->CreateLight(color.x, color.y, color.z);
        }

        static inline void AMDeleteLight(LightAdapter* light)
        {
            hpms::SafeDelete(light);
        }

        // LUA Logic.
        static inline CameraAdapter* LGetCamera()
        {
            return hpms::GetSupplier()->GetCamera();
        }

        static inline void LCameraLookAt(CameraAdapter* cam, const glm::vec3& at)
        {
            cam->LookAt(at);
        }



        static inline void LCameraFovY(CameraAdapter* cam, float fov)
        {
            cam->SetFovY(fov);
        }

        static inline void LSetAmbient(const glm::vec3& light)
        {
            hpms::GetSupplier()->SetAmbientLight(light);
        }

        static inline hpms::AnimationAdapter* LGetAnimator(EntityAdapter* entity, const std::string& id)
        {
            return entity->GetAnimationByName(id);
        }

        static inline std::string LStreamText(hpms::GuiText* textArea, const std::string& text, unsigned int maxLines)
        {
            return textArea->DrawTextStream(text, maxLines);
        }

        static inline void LEnableController(hpms::Controller* controller)
        {
            controller->SetActive(true);
        }

        static inline void LDisableController(hpms::Controller* controller)
        {
            controller->SetActive(false);
        }


        static inline void LUpdateCollisor(hpms::Collisor* coll)
        {
            coll->Update();
        }

        static inline void LMoveCollisor(hpms::Collisor* collisor, glm::vec3 position, glm::vec2 direction)
        {
            collisor->Move(position, direction);
        }

        static inline void LPlayAnimation(hpms::EntityAdapter* entity, const std::string& animName)
        {
            for (auto* anim : entity->GetAllAnimations())
            {
                anim->SetPlaying(false);
            }
            entity->GetAnimationByName(animName)->SetPlaying(true);
        }

        static inline void LUpdateAnimation(hpms::EntityAdapter* entity, const std::string& animName, float tpf)
        {
            entity->GetAnimationByName(animName)->Update(tpf);
        }


    };
}
