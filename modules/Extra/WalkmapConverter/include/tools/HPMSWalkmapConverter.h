/*!
 * File HPMSWalkmapConverter.h
 */

#pragma once

#include <utility>
#include <resource/HPMSWalkmap.h>
#include <common/HPMSUtils.h>

namespace hpms
{
    class WalkmapConverter
    {
    public:
        static hpms::WalkmapData* LoadWalkmap(const std::string& path);

    private:

        static void ProcessSectors(std::vector<hpms::Sector>& sectors, const std::string& path);

        static void ProcessPerimetralSides(std::vector<hpms::Sector>& vector);


        static void ProcessPerimeter(const Polygon& polygon, const std::string& path);

        static void ProcessObstacles(const std::vector<Polygon>& obstacles, const std::string& path);
    };

    class Face
    {
    public:
        unsigned int indexA;

        unsigned int indexB;

        unsigned int indexC;

        std::string lineRef;

        Face(std::string  lineRef, const std::string& tokenX, const std::string& tokenY,
             const std::string& tokenZ) :
                lineRef(std::move(lineRef)),
                indexA(ProcessIndex(tokenX) - 1),
                indexB(ProcessIndex(tokenY) - 1),
                indexC(ProcessIndex(tokenZ) - 1)
        {

        }

    private:
        static unsigned int ProcessIndex(const std::string& token);
    };

}

