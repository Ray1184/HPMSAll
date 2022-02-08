/*!
 * File HPMSCollisor.h
 */

#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <api/HPMSActorAdapter.h>
#include <common/HPMSMathUtils.h>
#include <glm/gtx/perpendicular.hpp>
#include <common/HPMSUtils.h>

namespace hpms
{
	enum CollisionType
	{	
		ZERO_COLLISION = 0,
		VS_WALKMAP = 1,
		VS_COLLISOR = 2
	};
	struct CollisorConfig
	{
		float gravityAffection{ 9.81f };
		float maxStepHeight{ 0.1f };
		bool active{ true };
		float radius{ 1.0f };
		glm::vec2 rect{ 1.0f, 1.0f };
	};

	struct CollisionInfo
	{
		bool collision{ false };
		CollisionType type{ ZERO_COLLISION };
		std::string other;
		glm::vec3 nextPosition;
	};

	class Collisor : public ActorAdapter
	{
	private:
		hpms::ActorAdapter* actor;
		hpms::WalkmapAdapter* walkMap;
		bool ignore;
		float baseHeight;
		bool baseHeightDefined;
		glm::vec3 nextPosition{};
		glm::vec3 lastPosition{};
		glm::vec2 direction{};
		bool outOfDate;
		hpms::TriangleAdapter* currentTriangle{ nullptr };
		std::vector<glm::vec2> perimeter;
		CollisorConfig config;
		CollisionInfo collisionState;
		float currentVerticalSpeed;
	public:



		Collisor(ActorAdapter* actor, WalkmapAdapter* walkMap, const CollisorConfig& config = CollisorConfig{});

		virtual ~Collisor();


		void SetPosition(const glm::vec3& position) override;

		virtual glm::vec3 GetPosition() const override;

		virtual glm::quat GetRotation() const override;

		virtual glm::vec3 GetScale() const override;

		virtual void SetVisible(bool visible) override;

		virtual bool IsVisible() const override;

		void SetRotation(const glm::quat& rotation) override;

		void SetScale(const glm::vec3& scale) override;

		void Move(const glm::vec3& nextPosition, const glm::vec2 direction);

		virtual std::string GetName() const override;

		inline const std::string Name() const override
		{
			return "Collisor/" + GetName();
		}

		inline TriangleAdapter* GetCurrentTriangle() const
		{
			return currentTriangle;
		}

		inline void SetCurrentTriangle(const TriangleAdapter* currentTriangle)
		{
			// Not implemented.
			LOG_WARN("Cannot set sampled triangle inside script");
		}
				

		inline void SetVerticalSpeed(float verticalSpeed)
		{
			// Not implemented.
			LOG_WARN("Cannot change collisor vertical speed from script");
		}

		inline float GetVerticalSpeed() const
		{
			return currentVerticalSpeed;
		}

		inline const CollisionInfo& GetCollisionState() const
		{
			return collisionState;
		}

		inline const CollisorConfig& GetConfig() const
		{
			return config;
		}

		inline const glm::vec3 GetNextStep() const
		{
			return nextPosition;
		}

		inline ActorAdapter* GetActor()
		{
			return actor;
		}

		void Sample(float tpf);

		void CollidesWalkmap(float tpf);

		void CollidesCollisor(float tpf, hpms::Collisor* other);

	private:
		void DetectBySector();
		CollisionInfo DetectByBoundingRadius(float tpf);
		void CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec3* correctPosition);
		void CorrectPositionBoundingRadiusMode(const glm::vec2& sideA, const glm::vec2& sideB, glm::vec2* correctPosition);
		void CorrectPositionSectorMode(const glm::vec2& sideA, const glm::vec2& sideB, bool resampleTriangle);
		bool CorrectAndRetry(const SingleCollisionResponse& singleCollision, const glm::vec3& nextPosition, glm::vec3* correctPosition, float tpf);
		void ApplyGravity(glm::vec3* correctPosition, float tpf);
		float GetHeightInMap();
	};
}
