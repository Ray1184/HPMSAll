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
		CollisionInfo collStateWalkmap = GetCollisionState(currentName);
		currentCollisor->ResetCollisionState();
		CollisionInfo collStateCollisor;
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
			collStateCollisor = GetCollisionState(currentName);	
			if (collStateCollisor.collision) {				
				break;
			}	
			
		}
		if (collStateWalkmap.skipCorrection || (collStateWalkmap.collision && collStateCollisor.collision))
		{
			// If collision is in blind spot (like corner) or both walkmap and collisor, don't move the actor.
			break;
		}
		else if (collStateWalkmap.collision)
		{
			currentCollisor->GetActor()->SetPosition(collStateWalkmap.nextPosition);
		}
		else if (collStateCollisor.collision)
		{
			currentCollisor->GetActor()->SetPosition(collStateCollisor.nextPosition);
		}
		else
		{
			currentCollisor->GetActor()->SetPosition(currentCollisor->GetNextStep());
		}

		currentCollisor->UpdateBounding();

	}
	
}

const std::string hpms::CollisionEnv::Name() const
{
	return "CollisionEnv";
}

