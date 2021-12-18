/**
 * File HPMSLuaExtensions.h
 */

#pragma once
#include <api/HPMSEntityAdapter.h>

namespace hpms
{

	class AnimationHelper
	{

	public:
		inline static void UpdateInterpolate(hpms::EntityAdapter* entity, float tpf, bool blend, float transitionTimeRatio)
		{
			std::string activeAnimationName = entity->GetActiveAnimation();
			std::string lastAnimationName = entity->GetLastAnimation();
			auto* activeAnimation = entity->GetAnimationByName(activeAnimationName);

			if (!activeAnimation->IsPlaying())
			{
				activeAnimation->SetPlaying(true);

			}

			if (blend && activeAnimationName != lastAnimationName && lastAnimationName != NO_ANIM)
			{
				auto* lastAnimation = entity->GetAnimationByName(lastAnimationName);
				float draw = tpf / transitionTimeRatio;
				if (lastAnimation->GetWeight() > 0.0) {

					float lastAnimWeight = lastAnimation->GetWeight() - draw;
					if (lastAnimWeight <= 0) {
						lastAnimWeight = 0.0f;
					}
					lastAnimation->SetWeight(lastAnimWeight);
				}
				if (activeAnimation->GetWeight() < 1.0) {
					float activeAnimWeight = activeAnimation->GetWeight() + draw;
					if (activeAnimWeight >= 1) {
						activeAnimWeight = 1.0f;
						for (auto& anim : entity->GetAllAnimations())
						{
							anim->SetWeight(0.0f);
						}
					}
					activeAnimation->SetWeight(activeAnimWeight);
				}
				lastAnimation->Update(tpf);
			}
			activeAnimation->Update(tpf);
		}
	};
}