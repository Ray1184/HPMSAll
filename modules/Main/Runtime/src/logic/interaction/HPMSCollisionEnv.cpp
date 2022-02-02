#include <logic/interaction/HPMSCollisionEnv.h>

void hpms::CollisionEnv::SetWalkmap(hpms::WalkmapAdapter* walkmapAdapter)
{
	CollisionEnv::currentWalkmap = walkmapAdapter;
}

void hpms::CollisionEnv::AddCollisor(const std::string& collisorName, hpms::Collisor* collisor)
{
	CollisionEnv::allCollisors[collisorName] = collisor;
}

hpms::CollisionInfo hpms::CollisionEnv::GetCollisionState(const std::string& collisorName)
{
	auto* collisor = allCollisors[collisorName];
	if (collisor == nullptr)
	{
		std::stringstream ss;
		ss << "Collisor with name " << collisorName << " not present in collision environment";
		LOG_ERROR(ss.str().c_str());
	}
	return collisor->GetCollisionState();
}

void hpms::CollisionEnv::Update(float tpf)
{
	for (const auto& current : allCollisors)
	{
		std::string currentName = current.first;
		auto* currentCollisor = current.second;
		currentCollisor->CollidesWalkmap(tpf);

		// Test collisor vs collisor only if there's no collision against walkmap.
		bool collision = GetCollisionInfo(currentName).collision;
		if (collision)
		{
			return;
		}

		for (const auto& other : allCollisors)
		{
			std::string otherName = current.first;
			auto* otherCollisor = current.second;

			// Skip collision test against itself.
			if (currentName == otherName)
			{
				continue;
			}

			currentCollisor->CollidesCollisor(tpf, otherCollisor);

			// At first collision return.
			bool collision = GetCollisionInfo(currentName).collision;
			if (collision)
			{
				return;
			}
		}
	}
}

const std::string hpms::Collisor::Name() const
{
	return "CollisionEnv";
}