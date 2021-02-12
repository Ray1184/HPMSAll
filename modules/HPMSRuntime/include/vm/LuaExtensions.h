/**
 * File LuaExtensions.h
 */

#pragma once

#include <glm/glm.hpp>
#include <math.h>
#include <algorithm>

#include <core/items/Entity.h>
#include <core/ResourceItemsCache.h>
#include <core/Camera.h>
#include <core/Scene.h>
#include <input/KeyEvent.h>
#include <logic/CalcUtils.h>
#include <logic/controllers/Controller.h>
#include <logic/controllers/Collisor.h>
#include <logic/controllers/Animator.h>
#include <logic/LogicItemsCache.h>

namespace hpms
{

    // LUA Math.
    glm::quat MulQuat(const glm::quat& q1, const glm::quat& q2)
    {
        return q1 * q2;
    }


    glm::quat FromEuler(float xAngle, float yAngle, float zAngle)
    {
        return glm::quat(glm::vec3(xAngle, yAngle, zAngle));
    }

    glm::quat FromAxisQuat(float angle, float xAxis, float yAxis, float zAxis)
    {
        return glm::angleAxis(angle, glm::vec3(xAxis, yAxis, zAxis));
    }


    glm::vec3 GetDirection(const glm::quat& rot, const glm::vec3& forward)
    {
        return hpms::CalcDirection(rot, forward);
    }

    float ToRadians(float degrees)
    {
        return glm::radians(degrees);
    }

    float ToDegrees(float radians)
    {
        return glm::degrees(radians);
    }

    glm::vec3 SumVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return v1 + v2;
    }

    glm::vec3 SubVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return v1 - v2;
    }

    glm::vec3 MulVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return v1 * v2;
    }

    glm::vec3 DivVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return v1 / v2;
    }


    glm::vec3 NormVec3(const glm::vec3& v)
    {
        return glm::normalize(v);
    }

    float DistVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + pow(v2.z - v1.z, 2));
    }

    float DotVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return glm::dot(v1, v2);
    }

    glm::vec3 CrossVec3(const glm::vec3& v1, const glm::vec3& v2)
    {
        return glm::cross(v1, v2);
    }

    glm::vec4 SumVec4(const glm::vec4& v1, const glm::vec4& v2)
    {
        return v1 + v2;
    }

    glm::vec4 SubVec4(const glm::vec4& v1, const glm::vec4& v2)
    {
        return v1 - v2;
    }

    glm::vec4 MulVec4(const glm::vec4& v1, const glm::vec4& v2)
    {
        return v1 * v2;
    }

    glm::vec4 DivVec4(const glm::vec4& v1, const glm::vec4& v2)
    {
        return v1 / v2;
    }

    glm::vec4 NormVec4(const glm::vec4& v)
    {
        return glm::normalize(v);
    }

    float DotVec4(const glm::vec4& v1, const glm::vec4& v2)
    {
        return glm::dot(v1, v2);
    }

    glm::vec2 SumVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return v1 + v2;
    }

    glm::vec2 SubVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return v1 - v2;
    }

    glm::vec2 MulVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return v1 * v2;
    }

    glm::vec2 DivVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return v1 / v2;
    }


    glm::vec2 NormVec2(const glm::vec2& v)
    {
        return glm::normalize(v);
    }

    float DistVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return (float) sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2));
    }

    float DotVec2(const glm::vec2& v1, const glm::vec2& v2)
    {
        return glm::dot(v1, v2);
    }


    glm::mat4 SumMat4(const glm::mat4& v1, const glm::mat4& v2)
    {
        return v1 + v2;
    }

    glm::mat4 SubMat4(const glm::mat4& v1, const glm::mat4& v2)
    {
        return v1 - v2;
    }

    glm::mat4 MulMat4(const glm::mat4& v1, const glm::mat4& v2)
    {
        return v1 * v2;
    }

    glm::mat4 DivMat4(const glm::mat4& v1, const glm::mat4& v2)
    {
        return v1 / v2;
    }

    float ElemAtMat4(const glm::mat4& v, int i, int j)
    {
        return v[i][j];
    }

    // STL utils.

    // LUA Key handling.
    bool KHKeyAction(const std::vector<hpms::KeyEvent>& events, const std::string& name, int action)
    {
        for (const auto& event : events)
        {
            if (name == event.key && action == event.inputType)
            {
                return true;
            }
        }
        return false;
    }

    // LUA Asset Manager.
    hpms::Entity* AMCreateEntity(const std::string& name)
    {
        AdvModelItem* testModel = ResourceItemsCache::Instance().GetModel(name);
        auto* e = hpms::SafeNew<hpms::Entity>(testModel);
        return e;
    }

    void AMDeleteEntity(Entity* entity)
    {
        hpms::SafeDelete(entity);
    }

    hpms::SceneNode* AMCreateNode(const std::string& name)
    {
        auto* n = hpms::SafeNew<hpms::SceneNode>(name);
        return n;
    }

    void AMDeleteNode(SceneNode* node)
    {
        hpms::SafeDelete(node);
    }


    void AMDeleteNodeAndActors(SceneNode* node)
    {
        node->DeleteAllActors();
        AMDeleteNode(node);
    }


    hpms::Picture* AMCreateBackground(const std::string& path)
    {
        auto* p = hpms::SafeNew<hpms::Picture>(path, PictureMode::BACKGROUND);
        return p;
    }

    void AMDeleteBackground(Picture* pic)
    {
        hpms::SafeDelete(pic);
    }

    hpms::Picture* AMCreateForeground(const std::string& path)
    {
        auto* p = hpms::SafeNew<hpms::Picture>(path, PictureMode::FOREGROUND);
        return p;
    }

    void AMDeleteForeground(Picture* pic)
    {
        hpms::SafeDelete(pic);
    }

    hpms::Picture* AMCreateDepthMask(const std::string& path)
    {
        auto* p = hpms::SafeNew<hpms::Picture>(path, PictureMode::DEPTH_MASK);
        return p;
    }

    void AMDeleteDepthMask(Picture* pic)
    {
        hpms::SafeDelete(pic);
    }

    void AMAddEntityToScene(Entity* obj, Scene* scene)
    {
        scene->AddRenderObject(obj);
    }

    void AMSetNodeEntity(SceneNode* node, Entity* obj)
    {
        node->SetActor(obj);
    }

    void AMAddNodeToScene(SceneNode* obj, Scene* scene)
    {
        scene->AddRenderObject(obj);
    }

    void AMAddPictureToScene(Picture* obj, Scene* scene)
    {
        scene->AddRenderObject(obj);
    }

    void AMUpdateCamera(Camera* cam)
    {
        cam->UpdateViewMatrix();
    }


    // LUA Logic.
    hpms::WalkMap* LCreateWalkMap(const std::string& path)
    {
        auto* w = hpms::SafeNew<hpms::WalkMap>(path, LogicItemsCache::Instance().GetRoomMap(path));
        return w;
    }

    void LDeleteWalkMap(WalkMap* walkMap)
    {
        hpms::SafeDelete(walkMap);
    }

    hpms::Collisor* LCreateEntityCollisor(Entity* entity, WalkMap* walkMap, float tolerance)
    {
        auto* c = hpms::SafeNew<hpms::Collisor>(entity, walkMap, tolerance);
        return c;
    }

    hpms::Collisor* LCreateNodeCollisor(SceneNode* node, WalkMap* walkMap, float tolerance)
    {
        auto* c = hpms::SafeNew<hpms::Collisor>(node, walkMap, tolerance);
        return c;
    }



    void LDeleteCollisor(Collisor* collisor)
    {
        hpms::SafeDelete(collisor);
    }

    hpms::Animator* LCreateAnimator(Entity* entity, const std::string& id)
    {
        auto* a = hpms::SafeNew<hpms::Animator>(entity, id);
        return a;
    }

    void LDeleteAnimator(Animator* anim)
    {
        hpms::SafeDelete(anim);
    }

    void LEnableController(hpms::Controller* controller)
    {
        controller->SetActive(true);
    }

    void LDisableController(hpms::Controller* controller)
    {
        controller->SetActive(false);
    }

    void LUpdateAnimator(hpms::Animator* anim)
    {
        anim->Update();
    }

    void LUpdateCollisor(hpms::Collisor* coll)
    {
        coll->Update();
    }

    void LMoveCollisor(hpms::Collisor* collisor, glm::vec3 position, glm::vec2 direction)
    {
        collisor->Move(position, direction);
    }

    void LRegisterAnimation(hpms::Animator* animator, const std::string& animName, int startFrame, int endFrame)
    {
        animator->RegisterAnimation(animName, startFrame, endFrame);
    }

    void LSetAnimation(hpms::Animator* animator, const std::string& animName)
    {
        animator->CheckAndSetCurrentAnimation(animName);
    }

    bool LIsAnimationSequenceFinished(hpms::Animator* animator)
    {
        animator->IsSequenceFinished();
    }

    void LRewind(hpms::Animator* animator)
    {
        animator->Rewind();
    }

}
