/*!
 * File HPMSCollisionEnv.h
 */

#pragma once

#include <logic/interaction/HPMSCollisor.h>
#include <common/HPMSUtils.h>
#include <vector>
#include <unordered_map>
#include <api/HPMSWalkmapAdapter.h>

namespace hpms
{
	class CollisionEnv : public Object
	{
	public:
		void SetWalkmap(hpms::WalkmapAdapter* walkmapAdapter);

		void AddCollisor(const std::string& collisorName, hpms::Collisor* collisor);

		hpms::CollisionInfo GetCollisionState(const std::string& collisorName);

		void Update(float tpf, bool ignoreCollisions = false);

		virtual const std::string Name() const override;

	
	private:
		std::unordered_map<std::string, hpms::Collisor*> allCollisors;
		hpms::WalkmapAdapter* currentWalkmap;
	};
}