/**
 * File LuaExtensions.h
 */

#pragma once

#include <glm/glm.hpp>
#include <cmath>
#include <algorithm>
#include <api/HPMSInputUtils.h>
#include <common/HPMSMathUtils.h>
#include <facade/HPMSApiFacade.h>
#include <logic/controllers/Collisor.h>

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
            if (name == event.name && action == event.state)
            {
                return true;
            }
        }
        return false;
    }

    bool KHMouseAction(const std::vector<hpms::MouseEvent>& events, const std::string& name, int action)
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
    hpms::EntityAdapter* AMCreateEntity(const std::string& name)
    {
        return hpms::GetSupplier()->CreateEntity(name);
    }

    void AMDeleteEntity(EntityAdapter* entity)
    {
        hpms::SafeDelete(entity);
    }

    hpms::SceneNodeAdapter* AMCreateNode(const std::string& name)
    {
        return hpms::GetSupplier()->GetRootSceneNode()->CreateChild(name);
    }

    hpms::SceneNodeAdapter* AMCreateNode(const std::string& name, SceneNodeAdapter* parent)
    {
        return parent->CreateChild(name);
    }

    void AMDeleteNode(SceneNodeAdapter* node)
    {
        hpms::SafeDelete(node);
    }

    hpms::BackgroundImageAdapter* AMCreateBackground(const std::string& path)
    {
        return hpms::GetSupplier()->CreateBackgroundImage(path);
    }

    void AMDeleteBackground(BackgroundImageAdapter* pic)
    {
        hpms::SafeDelete(pic);
    }

    hpms::OverlayImageAdapter* AMCreateForeground(const std::string& path, unsigned int x = 0, unsigned int y = 0, int zOrder = 0)
    {
        return hpms::GetSupplier()->CreateOverlayImage(path, x, y, zOrder);
    }

    void AMDeleteForeground(OverlayImageAdapter* pic)
    {
        hpms::SafeDelete(pic);
    }

    void AMSetNodeEntity(SceneNodeAdapter* node, EntityAdapter* obj)
    {
        node->AttachObject(obj);
    }

    void AMRemoveNodeEntity(SceneNodeAdapter* node, EntityAdapter* obj)
    {
        node->DetachObject(obj);
    }

    // LUA Logic.
    hpms::WalkmapAdapter* LCreateWalkMap(const std::string& name)
    {
        return hpms::GetSupplier()->CreateWalkmap(name);
    }

    void LDeleteWalkMap(WalkmapAdapter* walkMap)
    {
        hpms::SafeDelete(walkMap);
    }

    hpms::Collisor* LCreateEntityCollisor(EntityAdapter* entity, WalkmapAdapter* walkMap, float tolerance)
    {
        auto* c = hpms::SafeNew<hpms::Collisor>(entity, walkMap, tolerance);
        return c;
    }

    hpms::Collisor* LCreateNodeCollisor(SceneNodeAdapter* node, WalkMap* walkMap, float tolerance)
    {
        auto* c = hpms::SafeNew<hpms::Collisor>(node, walkMap, tolerance);
        return c;
    }



    void LDeleteCollisor(Collisor* collisor)
    {
        hpms::SafeDelete(collisor);
    }

    hpms::AnimationAdapter* LCreateAnimator(EntityAdapter* entity, const std::string& id)
    {
        return entity->GetAnimationByName(id);
    }

    void LDeleteAnimator(AnimationAdapter* anim)
    {
        // Managed by adaptee.
    }

    void LEnableController(hpms::Controller* controller)
    {
        controller->SetActive(true);
    }

    void LDisableController(hpms::Controller* controller)
    {
        controller->SetActive(false);
    }


    void LUpdateCollisor(hpms::Collisor* coll)
    {
        coll->Update();
    }

    void LMoveCollisor(hpms::Collisor* collisor, glm::vec3 position, glm::vec2 direction)
    {
        collisor->Move(position, direction);
    }

    void LSetAnimation(hpms::EntityAdapter* entity, const std::string& animName)
    {
        for (auto* anim : entity->GetAllAnimations())
        {
            anim->SetPlaying(false);
        }
        entity->GetAnimationByName(animName)->SetPlaying(true);
    }



}
