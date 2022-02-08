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
	else 
	{
		return collisor->GetCollisionState();
	}
}

void hpms::CollisionEnv::Update(float tpf, bool ignoreCollisions)
{
	for (const auto& current : allCollisors)
	{	
		std::string currentName = current.first;
		auto* currentCollisor = current.second;

		currentCollisor->Sample(tpf);

		if (ignoreCollisions)
		{
			currentCollisor->GetActor()->SetPosition(currentCollisor->GetNextStep());
			continue;
		}

		currentCollisor->CollidesWalkmap(tpf);
		currentCollisor->GetActor()->SetPosition(GetCollisionState(currentName).nextPosition);

		for (const auto& other : allCollisors)
		{
			std::string otherName = other.first;
			auto* otherCollisor = other.second;

			// Skip collision test against itself.
			if (currentName == otherName)
			{
				continue;
			}

			currentCollisor->CollidesCollisor(tpf, otherCollisor);

			// At first collision jump to next.
			CollisionInfo collState = GetCollisionState(currentName);
			currentCollisor->GetActor()->SetPosition(collState.nextPosition);
			if (collState.collision)
			{				
				break;
			}
		}
	}
}

const std::string hpms::CollisionEnv::Name() const
{
	return "CollisionEnv";
}

