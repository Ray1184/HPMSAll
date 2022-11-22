/*!
 * File HPMSPathFinder.h
 */

#pragma once

#include <vector>
#include <map>
#include <list>
#include <api/HPMSWalkmapAdapter.h>

namespace hpms
{

	class PathFinder : public Object
	{
	private:
		std::map<int, std::vector<int>> adjacencies;
		std::map<int, PathStepAdapter*> pathById;
		hpms::WalkmapAdapter* walkmap;
		float tolerance;
		int v;
		bool* visited;
		int* pred;
		int* dist;
		std::list<glm::vec3> path;
		bool BFS(int src, int dest);
	public:
		PathFinder(hpms::WalkmapAdapter* walkmap, float tolerance);

		virtual ~PathFinder();

		void CalculatePath(const glm::vec3& from, const glm::vec3& to);

		glm::vec3 PopStep(const glm::vec3& from, const glm::vec3& to);

		virtual const std::string Name() const override;


		
	};
}