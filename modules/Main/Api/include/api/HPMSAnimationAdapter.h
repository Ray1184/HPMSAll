/*!
 * File HPMSAnimationAdapter.h
 */

#pragma once

#include <common/HPMSObject.h>

namespace hpms
{
	class AnimationAdapter : public Object
	{

	public:

		inline const std::string Name() const override
		{
			return "AnimationAdapter";
		}

		inline virtual ~AnimationAdapter()
		{

		}

		virtual void Zero() = 0;

		virtual void Update(float tpf) = 0;

		virtual bool IsPlaying() const = 0;

		virtual void SetPlaying(bool playing) = 0;

		virtual bool IsLoop() const = 0;

		virtual void SetLoop(bool loop) = 0;

		virtual bool CycleTerminated() = 0;

		virtual void SetSliceFactor(int sliceFactor) = 0;

		virtual int GetSliceFactor() const = 0;
	};
}
