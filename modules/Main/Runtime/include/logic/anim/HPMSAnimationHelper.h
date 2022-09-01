/**
 * File HPMSLuaExtensions.h
 */

#pragma once
#include <api/HPMSEntityAdapter.h>
#include <unordered_map>


namespace hpms
{

	class AnimationHelper
	{

	private:
		inline static void CompleteCycles(hpms::EntityAdapter* entity, float draw)
		{
			std::string activeAnimationName = entity->GetActiveAnimation();
			
			if (activeAnimationName == NO_ANIM)
			{
				std::string msg = "No animation set for entity " + entity->GetName();
				LOG_WARN(msg.c_str());
				return;
			}
			auto* activeAnimation = entity->GetAnimationByName(activeAnimationName);

			if (activeAnimation->GetWeight() < 1.0) {
				float activeAnimWeight = activeAnimation->GetWeight() + draw;
				if (activeAnimWeight >= 1) {
					activeAnimWeight = 1.0f;
				}
				activeAnimation->SetWeight(activeAnimWeight);
			}

			for (auto& anim : entity->GetAllAnimations())
			{
				if (anim->GetName() != activeAnimationName)
				{
					float otherAnimWeight = anim->GetWeight() - draw / 2;
					if (otherAnimWeight <= 0) {
						otherAnimWeight = 0.0f;
					}
					anim->SetWeight(otherAnimWeight);
				}

			}
		
		}
		inline static bool Terminating(hpms::EntityAdapter* entity)
		{
			std::string activeAnimationName = entity->GetActiveAnimation();

			if (activeAnimationName == NO_ANIM)
			{
				return false;
			}

			auto* activeAnimation = entity->GetAnimationByName(activeAnimationName);
			if (activeAnimation->GetWeight() < 1)
			{
				return true;
			}

			for (auto& anim : entity->GetAllAnimations())
			{
				if (anim->GetName() != activeAnimationName)
				{
					if (anim->GetWeight() > 0)
					{
						return true;
					}
				}

			}

			return false;
		}

	public:
		inline static void UpdateInterpolate(hpms::EntityAdapter* entity, float tpf, bool blend, float transitionTimeRatio)
		{
			std::string activeAnimationName = entity->GetActiveAnimation();
			std::string lastAnimationName = entity->GetLastAnimation();
			if (activeAnimationName == NO_ANIM)
			{
				std::string msg = "No animation set for entity " + entity->GetName();
				LOG_WARN(msg.c_str());
				return;
			}
			auto* activeAnimation = entity->GetAnimationByName(activeAnimationName);
			if (!activeAnimation->IsPlaying())
			{
				activeAnimation->SetPlaying(true);
			}
			bool terminating = Terminating(entity);
			if ((blend && activeAnimationName != lastAnimationName && lastAnimationName != NO_ANIM) || terminating)
			{				
				float draw = transitionTimeRatio * tpf;

				CompleteCycles(entity, transitionTimeRatio * tpf);
			}

			activeAnimation->Update(tpf);

		}
	};
}

