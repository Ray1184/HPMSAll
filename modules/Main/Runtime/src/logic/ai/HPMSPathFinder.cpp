/*!
 * File HPMSPathFinder.cpp
 */

#include <logic/ai/HPMSPathFinder.h>
#include <functional>

hpms::PathFinder::PathFinder(hpms::WalkmapAdapter* walkmap, float tolerance) : walkmap(walkmap), tolerance(tolerance), v(0)
{
	auto checkPath = [&](PathStepAdapter* pathStep)
	{
		auto bounds = pathStep->GetAllLinked();
		adjacencies[pathStep->GetId()] = bounds;
		pathById[pathStep->GetId()] = pathStep;
		v++;
		return false;
	};
	walkmap->ForEachPathStep(checkPath);
	visited = hpms::SafeNewArrayRaw<bool>(v);
	dist = hpms::SafeNewArrayRaw<int>(v);
	pred = hpms::SafeNewArrayRaw<int>(v);
}

hpms::PathFinder::~PathFinder()
{
	hpms::SafeDeleteArrayRaw(pred);
	hpms::SafeDeleteArrayRaw(dist);
	hpms::SafeDeleteArrayRaw(visited);
}

void hpms::PathFinder::CalculatePath(const glm::vec3& from, const glm::vec3& to)
{
	path.clear();

	PathStepAdapter* fromStep = walkmap->SamplePath(from, tolerance);
	PathStepAdapter* toStep = walkmap->SamplePath(to, tolerance);

	int source = fromStep->GetId();
	int dest = toStep->GetId();

	if (BFS(source, dest) == false)
	{
		std::string s("Path nodes " + std::to_string(source) + " and " + std::to_string(dest) + " are not connected with path");
		LOG_WARN(s.c_str());
		path.push_back(from);
		return;
	}

	int crawl = dest;
	auto first = pathById[crawl];
	path.push_back(V2_TO_V3(first->GetCoords()));
	while (pred[crawl] != -1) {
		auto curr = pathById[pred[crawl]];
		path.push_back(V2_TO_V3(curr->GetCoords()));
		crawl = pred[crawl];
	}
}

glm::vec3 hpms::PathFinder::PopStep(const glm::vec3& from, const glm::vec3& to)
{

}

bool hpms::PathFinder::BFS(int src, int dest)
{
	std::list<int> queue;
	for (int i = 0; i < v; i++) {
		visited[i] = false;
		dist[i] = INT_MAX;
		pred[i] = -1;
	}

	visited[src] = true;
	dist[src] = 0;
	queue.push_back(src);

	while (!queue.empty())
	{
		int u = queue.front();
		queue.pop_front();
		for (int i = 0; i < adjacencies[u].size(); i++)
		{
			if (visited[adjacencies[u][i]] == false)
			{
				visited[adjacencies[u][i]] = true;
				dist[adjacencies[u][i]] = dist[u] + 1;
				pred[adjacencies[u][i]] = u;
				queue.push_back(adjacencies[u][i]);

				if (adjacencies[u][i] == dest)
				{
					return true;
				}
			}
		}
	}

	return false;
}

const std::string hpms::PathFinder::Name() const
{
	return "PathFinder";
}

