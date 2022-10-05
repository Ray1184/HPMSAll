/**
 * File HPMSLuaExtensions.h
 */

#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/quaternion.hpp>
#include <cmath>
#include <algorithm>
#include <api/HPMSInputUtils.h>
#include <common/HPMSMathUtils.h>
#include <facade/HPMSApiFacade.h>
#include <logic/interaction/HPMSCollisor.h>
#include <logic/interaction/HPMSCollisionEnv.h>
#include <logic/gui/HPMSGuiText.h>
#include <logic/anim/HPMSAnimationHelper.h>
#include <debug/HPMSDebugUtils.h>
#include <LuaBridge/Vector.h>

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

		static inline glm::vec3 ToEuler(const glm::quat& quat)
		{
			return glm::eulerAngles(quat);
		}

		static inline glm::quat FromAxisQuat(float angle, float xAxis, float yAxis, float zAxis)
		{
			return glm::angleAxis(angle, glm::vec3(xAxis, yAxis, zAxis));
		}

		static inline glm::vec3 GetDirection(const glm::quat& rot, const glm::vec3& forward)
		{
			return hpms::CalcDirection(rot, forward);
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
			return hpms::SafeNormalize(v);
		}

		static inline float DistVec3(const glm::vec3& v1, const glm::vec3& v2)
		{
			return hpms::DistanceVec3(v1, v2);
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
			return hpms::SafeNormalize(v);
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
			return hpms::SafeNormalize(v);
		}

		static inline float DistVec2(const glm::vec2& v1, const glm::vec2& v2)
		{
			return hpms::DistanceVec2(v1, v2);
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


		// Math calc utils.
		static inline float MCToRadians(float degrees)
		{
			return glm::radians(degrees);
		}

		static inline float MCToDegrees(float radians)
		{
			return glm::degrees(radians);
		}

		static inline bool MCPointInsideCircle(const glm::vec2& point, const glm::vec2& t, float radius) {
			return hpms::PointInsideCircle(point, t, radius);
		}

		static inline bool MCPointInsidePolygon(const glm::vec2& point, const glm::vec2& t, const std::vector<glm::vec2>& data) {
			return hpms::PointInsidePolygon(point, t, data);
		}

		static inline bool MCCircleIntersectLine(const glm::vec2& a, const glm::vec2& b, const glm::vec2& center, float radius) {
			return hpms::CircleLineIntersect(a, b, center, radius);
		}



		// LUA Key handling.
		static inline std::string KHKeyInput(const std::vector<hpms::KeyEvent>& events)
		{
			if (events.empty() || events[0].state != KeyEvent::PRESSED_FIRST_TIME) {
				return "";
			}
			if (events.size() >= 2 && (events[1].name == "LSHIFT" || events[1].name == "RSHIFT")) {
				return "SH_" + events[0].name;
			}
			if (events.size() >= 2 && (events[1].name == "LALT" || events[1].name == "RSALT")) {
				return "AL_" + events[0].name;
			}
			return events[0].name;
		}

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

		static inline void LSetNodeParticle(SceneNodeAdapter* node, ParticleAdapter* obj)
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

		static inline void LSRemoveNodeParticle(SceneNodeAdapter* node, ParticleAdapter* obj)
		{
			node->DetachObject(obj);
		}

		static inline void LAttachToEntityBone(const std::string& boneNode, EntityAdapter* objToAttach, EntityAdapter* boneOwner, const glm::vec3& offsetPosition = glm::vec3(), const glm::quat& offsetRotation = glm::quat(), const glm::vec3& scale = glm::vec3())
		{
			boneOwner->AttachObjectToBone(boneNode, objToAttach, offsetPosition, offsetRotation, scale);
		}

		static inline void LDetachFromEntityBone(const std::string& boneNode, EntityAdapter* objToAttach, EntityAdapter* boneOwner)
		{
			boneOwner->DetachObjectFromBone(boneNode, objToAttach);
		}

		static inline void LPSAttachToEntityBone(const std::string& boneNode, ParticleAdapter* objToAttach, EntityAdapter* boneOwner, const glm::vec3& offsetPosition = glm::vec3(), const glm::quat& offsetRotation = glm::quat(), const glm::vec3& scale = glm::vec3())
		{
			boneOwner->AttachObjectToBone(boneNode, objToAttach, offsetPosition, offsetRotation, scale);
		}

		static inline void LPSDetachFromEntityBone(const std::string& boneNode, ParticleAdapter* objToAttach, EntityAdapter* boneOwner)
		{
			boneOwner->DetachObjectFromBone(boneNode, objToAttach);
		}

		static inline hpms::WalkmapAdapter* AMCreateWalkMap(const std::string& name)
		{
			return hpms::GetSupplier()->CreateWalkmap(name);
		}

		static inline void AMDeleteWalkMap(WalkmapAdapter* walkMap)
		{
			hpms::SafeDelete(walkMap);
		}

		static inline hpms::ParticleAdapter* AMCreateParticleSystem(const std::string& name, const std::string& templateName)
		{
			return hpms::GetSupplier()->CreateParticleSystem(name, templateName);
		}

		static inline void AMDeleteParticleSystem(ParticleAdapter* ps)
		{
			hpms::SafeDelete(ps);
		}

		static inline hpms::Collisor* AMCreateEntityCollisor(EntityAdapter* entity, WalkmapAdapter* walkMap, const hpms::CollisorConfig& config)
		{
			auto* c = hpms::SafeNew<hpms::Collisor>(entity, walkMap, config);
			return c;
		}

		static inline hpms::Collisor* AMCreateNodeCollisor(SceneNodeAdapter* node, WalkmapAdapter* walkMap, const hpms::CollisorConfig& config)
		{
			auto* c = hpms::SafeNew<hpms::Collisor>(node, walkMap, config);
			return c;
		}


		static inline void AMDeleteCollisor(Collisor* collisor)
		{
			hpms::SafeDelete(collisor);
		}

		static inline hpms::CollisionEnv* AMCreateCollisionEnv()
		{
			auto* c = hpms::SafeNew<hpms::CollisionEnv>();
			return c;
		}

		static inline void AMDeleteCollisionEnv(hpms::CollisionEnv* env)
		{
			hpms::SafeDelete(env);
		}

		static inline hpms::CollisorConfig AMGetCollisorConfig(bool active, float gravityAffection, float maxStepHeight, float boundingRadius, const glm::vec2& boundingRect) {
			return hpms::CollisorConfig{ gravityAffection, maxStepHeight, active, boundingRadius, boundingRect };
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

		static inline void LUpdateCollisionEnv(hpms::CollisionEnv* env, float tpf)
		{
			env->Update(tpf);
		}

		static inline void LUpdateCollisionEnvNoColls(hpms::CollisionEnv* env, float tpf)
		{
			env->Update(tpf, true);
		}

		static inline void LUpdateCollisor(hpms::Collisor* coll, float tpf)
		{
			coll->CollidesWalkmap(tpf);
		}

		static inline void LAddCollisorToEnv(hpms::CollisionEnv* env, const std::string& collisorName, hpms::Collisor* coll)
		{
			env->AddCollisor(collisorName, coll);
		}

		static inline void LSetWalkmapToEnv(hpms::CollisionEnv* env, hpms::WalkmapAdapter* walkmap)
		{
			env->SetWalkmap(walkmap);
		}

		static inline hpms::CollisionInfo LGetCollisionStateByName(hpms::CollisionEnv* env, const std::string& collisorName)
		{
			return env->GetCollisionState(collisorName);
		}

		static inline hpms::CollisionInfo LGetCollisionStateByCollisor(hpms::Collisor* coll)
		{
			return coll->GetCollisionState();
		}

		static inline void LMoveCollisor(hpms::Collisor* collisor, const glm::vec3& position, glm::vec2 direction)
		{
			collisor->Move(position, direction);
		}

		static inline float LLookCollisorAt(hpms::Collisor* collisor, const glm::vec3& direction, float interpolateRatio)
		{
			return collisor->LookAt(direction, interpolateRatio);
		}

		static inline void LStopRewindAnimation(hpms::EntityAdapter* entity)
		{
			for (auto* anim : entity->GetAllAnimations())
			{
				anim->Zero();
			}
		}

		static inline bool LAnimationFinished(hpms::EntityAdapter* entity, const std::string& name)
		{
			auto* anim = entity->GetAnimationByName(name);
			return anim->CycleTerminated();
		}

		static inline void LPlayAnimation(hpms::EntityAdapter* entity, const std::string& animName)
		{
			entity->SetActiveAnimation(animName);
		}

		static inline void LSliceAnimation(hpms::EntityAdapter* entity, const std::string& name, int sliceFactor)
		{
			auto* anim = entity->GetAnimationByName(name);
			anim->SetSliceFactor(sliceFactor);
		}

		static inline void LUpdateAnimation(hpms::EntityAdapter* entity, float tpf, bool blend, float transitionTimeRatio)
		{
			hpms::AnimationHelper::UpdateInterpolate(entity, tpf, blend, transitionTimeRatio);
		}

		static inline bool LPointInsideWalkmap(hpms::WalkmapAdapter* walkmap, const glm::vec3& point)
		{
			return walkmap->SampleTriangle(point, 0) != nullptr;
		}

		static inline bool LCircleInsideWalkmap(hpms::WalkmapAdapter* walkmap, const glm::vec3& point, float radius)
		{
			CollisionResponse collisionResponse;
			walkmap->Collides(point, radius, &collisionResponse);
			bool outOfWalkmap = collisionResponse.AnyCollision();
			return !outOfWalkmap;
		}

		static inline void LOverlayAlpha(hpms::OverlayImageAdapter* overlayImage, float alpha)
		{
			overlayImage->SetAlpha(alpha);
		}

		static inline void LParticleGoToTime(hpms::ParticleAdapter* particles, float time)
		{
			particles->GoToTime(time);
		}

		static inline void InitAnimatedParticle(hpms::ParticleAdapter* particles, const std::string& textureBaseName)
		{
			particles->InitAnimatedParticle(textureBaseName);
		}

		static inline void UpdateNoLoopAnimatedParticle(hpms::ParticleAdapter* particles, const std::string& textureBaseName)
		{
			particles->UpdateNoLoopAnimatedParticle(textureBaseName);
		}

		// System Logic.     
		static inline void SLLogMessage(const std::string& logMsg)
		{
			LOG_INTERFACE(logMsg.c_str());
		}

		static std::string SLLoadStringFile(const std::string& filePath)
		{
			return hpms::ReadFile(filePath);
		}

		static void SLWriteStringFile(const std::string& fileName, const std::string& data)
		{
			return hpms::WriteStringData(fileName, data);
		}


		static inline void SLCleanupPending()
		{
			hpms::GetSupplier()->CleanupPending();
		}

		// Debug Utils.
		static inline void DDebugDrawClear()
		{
			hpms::DebugUtils::ClearAllDraws();
		}

		static inline void DDebugDrawBoundingBox(hpms::Collisor* entity)
		{
			hpms::DebugUtils::DrawBoundingBox(entity);
		}

		static inline void DDebugDrawWalkmap(hpms::WalkmapAdapter* walkmap)
		{
			hpms::DebugUtils::DrawWalkmap(walkmap);
		}

		static inline void DDebugDrawCollisorTriangle(hpms::Collisor* collisor)
		{
			hpms::DebugUtils::DrawCollisorSector(collisor);
		}

		static inline void DDebugDrawSampledTriangle(hpms::WalkmapAdapter* walkmap, hpms::ActorAdapter* actor)
		{
			hpms::DebugUtils::DrawSampledSector(walkmap, actor);
		}

		static inline void DDebugDrawPerimeter(hpms::WalkmapAdapter* walkmap)
		{
			hpms::DebugUtils::DrawPerimeter(walkmap);
		}


	};
}
