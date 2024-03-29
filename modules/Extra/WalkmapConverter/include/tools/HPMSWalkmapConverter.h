/*!
 * File HPMSWalkmapConverter.h
 */

#pragma once

#include <utility>
#include <resource/HPMSWalkmap.h>
#include <common/HPMSUtils.h>
#include <glm/glm.hpp>

namespace hpms
{

	struct RawPolygon
	{
		std::vector<glm::vec3> vertices;
		std::vector<std::vector<glm::ivec2>> sideGroups;
	};

	class WalkmapConverter
	{
	public:
		static hpms::WalkmapData* LoadWalkmap(const std::string& path);

	private:
		static void ProcessSectors(std::vector<hpms::Sector>& sectors, const std::string& path);

		static void ProcessPerimetralSides(std::vector<hpms::Sector>& vector);

		static void ProcessPolygons(std::vector<Polygon>& polys, const std::string& path);

		static void ProcessPerimeter(Polygon* polygon, const std::string& path);

		static void ProcessObstacles(std::vector<Polygon>& obstacles, const std::string& path);

		static void ProcessPaths(std::vector<PathStep>& pathSteps, const std::string& path);

		static std::vector<std::vector<glm::ivec2>> SplitSides(const std::vector<glm::ivec2>& lines);

		static glm::ivec2* Next(glm::ivec2* current, const std::vector<glm::ivec2>& sides);

		static void ParsePolygons(std::vector<Polygon>& polys, const RawPolygon& rawPoly);
	};

	class Face
	{
	public:
		unsigned int indexA;

		unsigned int indexB;

		unsigned int indexC;

		std::string lineRef;

		Face(std::string lineRef, const std::string& tokenX, const std::string& tokenY,
			const std::string& tokenZ) : lineRef(std::move(lineRef)),
			indexA(ProcessIndex(tokenX) - 1),
			indexB(ProcessIndex(tokenY) - 1),
			indexC(ProcessIndex(tokenZ) - 1)
		{
		}

	private:
		static unsigned int ProcessIndex(const std::string& token);
	};

}
