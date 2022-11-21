/*!
 * File HPMSPathFinder.h
 */

#pragma once

#include <vector>
#include <list>
#include <api/HPMSWalkmapAdapter.h>

namespace hpms
{

	class PathFinder : public Object
	{
	public:
		PathFinder(hpms::WalkmapAdapter* walkmap);

		virtual ~PathFinder();

		std::vector<glm::vec2> GetPath(const glm::vec2& from, const glm::vec2& to);

		glm::vec2 GetNextStep(const glm::vec2& from, const glm::vec2& to);

		virtual const std::string Name() const override;

	private:
	};
}