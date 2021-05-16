/**
 * File HPMSLuaRegister.h
 */
#pragma once

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include <vector>
#include <LuaBridge/LuaBridge.h>
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/mat4x4.hpp>
#include <vm/HPMSLuaExtensions.h>
#include <logic/interaction/HPMSCollisor.h>
#include <api/HPMSEntityAdapter.h>
#include <logic/gui/HPMSGuiText.h>

using namespace luabridge;

namespace hpms
{
    class LuaRegister
    {
    public:


        inline static void RegisterAssetManager(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .addFunction("make_entity", &hpms::LuaExtensions::AMCreateEntity)
                    .addFunction("make_depth_entity", &hpms::LuaExtensions::AMCreateDepthEntity)
                    .addFunction("delete_entity", &hpms::LuaExtensions::AMDeleteEntity)
                    .addFunction("make_node", &hpms::LuaExtensions::AMCreateNode)
                    .addFunction("make_child_node", &hpms::LuaExtensions::AMCreateChildNode)
                    .addFunction("delete_node", &hpms::LuaExtensions::AMDeleteNode)
                    .addFunction("make_background", &hpms::LuaExtensions::AMCreateBackground)
                    .addFunction("delete_background", &hpms::LuaExtensions::AMDeleteBackground)
                    .addFunction("make_overlay", &hpms::LuaExtensions::AMCreateOverlay)
                    .addFunction("delete_overlay", &hpms::LuaExtensions::AMDeleteOverlay)
                    .addFunction("make_textarea", &hpms::LuaExtensions::AMCreateTextArea)
                    .addFunction("delete_textarea", &hpms::LuaExtensions::AMDeleteTextArea)
                    .addFunction("make_light", &hpms::LuaExtensions::AMCreateLight)
                    .addFunction("delete_light", &hpms::LuaExtensions::AMDeleteLight)
                    .addFunction("make_walkmap", &hpms::LuaExtensions::AMCreateWalkMap)
                    .addFunction("delete_walkmap", &hpms::LuaExtensions::AMDeleteWalkMap)
                    .addFunction("make_node_collisor", &hpms::LuaExtensions::AMCreateNodeCollisor)
                    .addFunction("make_entity_collisor", &hpms::LuaExtensions::AMCreateEntityCollisor)
                    .addFunction("delete_collisor", &hpms::LuaExtensions::AMDeleteCollisor)
                    .endNamespace();
        }

        inline static void RegisterEntity(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::EntityAdapter>("entity")
                    .addProperty("position", &hpms::EntityAdapter::GetPosition, &hpms::EntityAdapter::SetPosition)
                    .addProperty("scale", &hpms::EntityAdapter::GetScale, &hpms::EntityAdapter::SetScale)
                    .addProperty("rotation", &hpms::EntityAdapter::GetRotation, &hpms::EntityAdapter::SetRotation)
                    .addProperty("visible", &hpms::EntityAdapter::IsVisible, &hpms::EntityAdapter::SetVisible)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterNode(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::SceneNodeAdapter>("node")
                    .addProperty("position", &hpms::SceneNodeAdapter::GetPosition, &hpms::SceneNodeAdapter::SetPosition)
                    .addProperty("scale", &hpms::SceneNodeAdapter::GetScale, &hpms::SceneNodeAdapter::SetScale)
                    .addProperty("rotation", &hpms::SceneNodeAdapter::GetRotation, &hpms::SceneNodeAdapter::SetRotation)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterOverlayImage(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::OverlayImageAdapter>("overlay")
                    .addProperty("position", &hpms::OverlayImageAdapter::GetPosition, &hpms::OverlayImageAdapter::SetPosition)
                    .addProperty("visible", &hpms::OverlayImageAdapter::IsVisible, &hpms::OverlayImageAdapter::SetVisible)
                    .endClass()
                    .endNamespace();

        }

        inline static void RegisterTextArea(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::GuiText>("textarea")
                    .addProperty("position", &hpms::GuiText::GetPosition, &hpms::GuiText::SetPosition)
                    .addProperty("color", &hpms::GuiText::GetColor, &hpms::GuiText::SetColor)
                    .addProperty("visible", &hpms::GuiText::IsVisible, &hpms::GuiText::SetVisible)
                    .addProperty("text", &hpms::GuiText::GetText, &hpms::GuiText::SetText)
                    .endClass()
                    .endNamespace();

        }

        inline static void RegisterBackgroundImage(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::BackgroundImageAdapter>("background")
                    .addProperty("position", &hpms::BackgroundImageAdapter::GetPosition, &hpms::BackgroundImageAdapter::SetPosition)
                    .addProperty("visible", &hpms::BackgroundImageAdapter::IsVisible, &hpms::BackgroundImageAdapter::SetVisible)
                    .endClass()
                    .endNamespace();

        }

        inline static void RegisterLight(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<hpms::LightAdapter>("light")
                    .addProperty("position", &hpms::LightAdapter::GetPosition, &hpms::LightAdapter::SetPosition)
                    .addProperty("visible", &hpms::LightAdapter::IsVisible, &hpms::LightAdapter::SetVisible)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterCommonMath(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .addFunction("to_radians", &hpms::LuaExtensions::ToRadians)
                    .addFunction("to_degrees", &hpms::LuaExtensions::ToDegrees)
                    .endNamespace();

        }

        inline static void RegisterQuaternion(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<glm::quat>("quat")
                    .addConstructor < void(*)
            (void) > ()
                    .addConstructor < void(*)
            (glm::quat) > ()
                    .addConstructor < void(*)
            (float, float, float, float) > ()
                    .addData("x", &glm::quat::x)
                    .addData("y", &glm::quat::y)
                    .addData("z", &glm::quat::z)
                    .addData("w", &glm::quat::w)
                    .endClass()
                    .addFunction("quat_mul", &hpms::LuaExtensions::MulQuat)
                    .addFunction("from_axis", &hpms::LuaExtensions::FromAxisQuat)
                    .addFunction("get_direction", &hpms::LuaExtensions::GetDirection)
                    .addFunction("from_euler", &hpms::LuaExtensions::FromEuler)
                    .endNamespace();

        }

        inline static void RegisterVector3(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<glm::vec3>("vec3")
                    .addConstructor < void(*)
            (void) > ()
                    .addConstructor < void(*)
            (float, float, float) > ()
                    .addData("x", &glm::vec3::x)
                    .addData("y", &glm::vec3::y)
                    .addData("z", &glm::vec3::z)
                    .endClass()
                    .addFunction("vec3_add", &hpms::LuaExtensions::SumVec3)
                    .addFunction("vec3_sub", &hpms::LuaExtensions::SubVec3)
                    .addFunction("vec3_mul", &hpms::LuaExtensions::MulVec3)
                    .addFunction("vec3_div", &hpms::LuaExtensions::DivVec3)
                    .addFunction("vec3_dist", &hpms::LuaExtensions::DistVec3)
                    .addFunction("vec3_dot", &hpms::LuaExtensions::DotVec3)
                    .addFunction("vec3_cross", &hpms::LuaExtensions::CrossVec3)
                    .endNamespace();

        }

        inline static void RegisterVector4(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<glm::vec4>("vec4")
                    .addConstructor < void(*)
            (void) > ()
                    .addConstructor < void(*)
            (float, float, float, float) > ()
                    .addData("w", &glm::vec4::w)
                    .addData("x", &glm::vec4::x)
                    .addData("y", &glm::vec4::y)
                    .addData("z", &glm::vec4::z)
                    .endClass()
                    .addFunction("vec4_add", &hpms::LuaExtensions::SumVec4)
                    .addFunction("vec4_sub", &hpms::LuaExtensions::SubVec4)
                    .addFunction("vec4_mul", &hpms::LuaExtensions::MulVec4)
                    .addFunction("vec4_div", &hpms::LuaExtensions::DivVec4)
                    .addFunction("vec4_dot", &hpms::LuaExtensions::DotVec4)
                    .endNamespace();

        }

        inline static void RegisterVector2(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<glm::vec2>("vec2")
                    .addConstructor < void(*)
            (void) > ()
                    .addConstructor < void(*)
            (float, float) > ()
                    .addData("x", &glm::vec2::x)
                    .addData("y", &glm::vec2::y)
                    .endClass()
                    .addFunction("vec2_add", &hpms::LuaExtensions::SumVec2)
                    .addFunction("vec2_sub", &hpms::LuaExtensions::SubVec2)
                    .addFunction("vec2_mul", &hpms::LuaExtensions::MulVec2)
                    .addFunction("vec2_div", &hpms::LuaExtensions::DivVec2)
                    .addFunction("vec2_dist", &hpms::LuaExtensions::DistVec2)
                    .addFunction("vec2_dot", &hpms::LuaExtensions::DotVec2)
                    .endNamespace();

        }

        inline static void RegisterMatrix4(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<glm::mat4>("mat4")
                    .addConstructor < void(*)
            (void) > ()
                    .endClass()
                    .addFunction("mat4_add", &hpms::LuaExtensions::SumMat4)
                    .addFunction("mat4_sub", &hpms::LuaExtensions::SubMat4)
                    .addFunction("mat4_mul", &hpms::LuaExtensions::MulMat4)
                    .addFunction("mat4_div", &hpms::LuaExtensions::DivMat4)
                    .addFunction("mat4_elem_at", &hpms::LuaExtensions::ElemAtMat4)
                    .endNamespace();

        }

        inline static void RegisterKeyEvent(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<KeyEvent>("key_event")
                    .addData("key", &KeyEvent::name)
                    .addData("input_type", &KeyEvent::state)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterKeyList(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<std::vector<KeyEvent>>("key_list")
                    .endClass()
                    .addFunction("key_action_performed", &hpms::LuaExtensions::KHKeyAction)
                    .endNamespace();
        }

        inline static void RegisterMouseEvent(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<MouseEvent>("mbutton_event")
                    .addData("key", &MouseEvent::name)
                    .addData("input_type", &MouseEvent::state)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterMouseList(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<std::vector<MouseEvent>>("mbutton_list")
                    .endClass()
                    .addFunction("mbutton_action_performed", &hpms::LuaExtensions::KHMouseAction)
                    .endNamespace();
        }


        inline static void RegisterCamera(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<CameraAdapter>("camera")
                    .addProperty("position", &hpms::CameraAdapter::GetPosition, &hpms::CameraAdapter::SetPosition)
                    .addProperty("rotation", &hpms::CameraAdapter::GetRotation, &hpms::CameraAdapter::SetRotation)
                    .addProperty("near", &hpms::CameraAdapter::GetNear, &hpms::CameraAdapter::SetNear)
                    .addProperty("far", &hpms::CameraAdapter::GetFar, &hpms::CameraAdapter::SetFar)
                    .addProperty("fovy", &hpms::CameraAdapter::GetFovY, &hpms::CameraAdapter::SetFovY)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterLogic(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .addFunction("set_node_entity", &hpms::LuaExtensions::LSetNodeEntity)
                    .addFunction("set_node_camera", &hpms::LuaExtensions::LSetNodeCamera)
                    .addFunction("set_bone_node", &hpms::LuaExtensions::LSetBoneNode)
                    .addFunction("set_ambient", &hpms::LuaExtensions::LSetAmbient)
                    .addFunction("get_camera", &hpms::LuaExtensions::LGetCamera)
                    .addFunction("camera_lookat", &hpms::LuaExtensions::LCameraLookAt)
                    .addFunction("camera_fovy", &hpms::LuaExtensions::LCameraFovY)
                    .addFunction("get_animator", &hpms::LuaExtensions::LGetAnimator)
                    .addFunction("enable_controller", &hpms::LuaExtensions::LEnableController)
                    .addFunction("disable_controller", &hpms::LuaExtensions::LDisableController)
                    .addFunction("update_collisor", &hpms::LuaExtensions::LUpdateCollisor)
                    .addFunction("move_collisor_dir", &hpms::LuaExtensions::LMoveCollisor)
                    .addFunction("play_anim", &hpms::LuaExtensions::LPlayAnimation)
                    .addFunction("update_anim", &hpms::LuaExtensions::LUpdateAnimation)
                    .addFunction("stream_text", &hpms::LuaExtensions::LStreamText)
                    .endNamespace();
        }

        inline static void RegisterWalkMap(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<WalkmapAdapter>("walkmap")
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterTriangle(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<TriangleAdapter>("sector")
                    .addProperty("id", &hpms::TriangleAdapter::GetSectorId, &hpms::TriangleAdapter::SetSectorId)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterCollisor(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .beginClass<Collisor>("collisor")
                    .addProperty("position", &hpms::Collisor::GetPosition, &hpms::Collisor::SetPosition)
                    .addProperty("rotation", &hpms::Collisor::GetRotation, &hpms::Collisor::SetRotation)
                    .addProperty("sector", &hpms::Collisor::GetCurrentTriangle, &hpms::Collisor::SetCurrentTriangle)
                    .endClass()
                    .endNamespace();
        }

        inline static void RegisterDebug(lua_State* state)
        {
            getGlobalNamespace(state)
                    .beginNamespace("hpms")
                    .addFunction("debug_draw_clear", &hpms::LuaExtensions::DDebugDrawClear)
                    .addFunction("debug_draw_walkmap", &hpms::LuaExtensions::DDebugDrawWalkmap)
                    .addFunction("debug_draw_sampled_triangle", &hpms::LuaExtensions::DDebugDrawSampledTriangle)
                    .addFunction("debug_draw_collisor_triangle", &hpms::LuaExtensions::DDebugDrawCollisorTriangle)
                    .endNamespace();
        }


    };
}
