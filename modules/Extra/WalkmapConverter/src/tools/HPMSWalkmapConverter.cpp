/*!
 * File WalkmapConverter.cpp
 */

#include <tools/HPMSWalkmapConverter.h>
#include <utils/HPMSCalcUtils.h>
#include <regex>
#include <algorithm>

hpms::WalkmapData* hpms::WalkmapConverter::LoadWalkmap(const std::string& path)
{
    std::vector<hpms::Sector> sectors;
    Polygon perimeter;
    std::vector<hpms::Polygon> obstacles;
    std::string basePath = path;
    std::string perimeterPath = basePath.replace(basePath.find(".walkmap.obj"), basePath.size(), ".perimeter.obj");
    std::string obstaclesPath = basePath.replace(basePath.find(".walkmap.obj"), basePath.size(), ".obstacles.obj");
    ProcessSectors(sectors, path);
    ProcessPerimeter(perimeter, perimeterPath);
    ProcessObstacles(obstacles, obstaclesPath);
    std::string roomName = hpms::GetFileName(path);
    auto* map = hpms::SafeNew<WalkmapData>(roomName, sectors);
    return map;
}

void hpms::WalkmapConverter::ProcessSectors(std::vector<hpms::Sector>& sectors, const std::string& path)
{
    std::vector<glm::vec3> vertices;
    std::vector<hpms::Face> faces;
    std::unordered_map<std::string, std::string> faceRefToSectorName;
    std::unordered_map<std::string, hpms::Sector> sectorsById;
    std::string currentSector;


    auto process = [&vertices, &faces, &faceRefToSectorName, &currentSector, &sectorsById](const std::string& line)
    {
        std::vector<std::string> tokens = hpms::Split(line, "\\s+");
        char type = tokens[0].at(0);
        switch (type)
        {
            case 'o':
                currentSector = tokens[1];
                sectorsById.insert({tokens[1], hpms::Sector(tokens[1])});
                break;
            case 'v':
                vertices.emplace_back(std::stof(tokens[1]), std::stof(tokens[2]), std::stof(tokens[3]));
                break;
            case 'f':
                faces.emplace_back(line, tokens[1], tokens[2], tokens[3]);
                faceRefToSectorName.insert({line, currentSector});
                break;
            default:
                break;
        }
    };
    hpms::ProcessFileLines(path, process);

    for (const auto& face : faces)
    {
        glm::vec3 t1 = glm::vec3(vertices[face.indexA].x, vertices[face.indexA].y, vertices[face.indexA].z);
        glm::vec3 t2 = glm::vec3(vertices[face.indexB].x, vertices[face.indexB].y, vertices[face.indexB].z);
        glm::vec3 t3 = glm::vec3(vertices[face.indexC].x, vertices[face.indexC].y, vertices[face.indexC].z);
        std::string sectorId = faceRefToSectorName[face.lineRef];
        Triangle tri = hpms::Triangle(sectorId, t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, t3.x, t3.y, t3.z);
        sectorsById[sectorId].AddTriangle(tri);
    }

    for (const auto& sec : sectorsById)
    {
        hpms::Sector sector = sec.second;
        sectors.push_back(sector);
    }

    ProcessPerimetralSides(sectors);
}


void hpms::WalkmapConverter::ProcessPerimetralSides(std::vector<hpms::Sector>& sectors)
{
    std::vector<Triangle> allTris;
    for (auto& sector : sectors)
    {
        for (const auto& tri : sector.GetTriangles())
        {
            allTris.push_back(tri);
        }
    }


    for (auto& sector : sectors)
    {
        std::vector<Triangle> tris;
        for (Triangle tri : sector.GetTriangles())
        {
            tri.SetPerimetralSides(hpms::CalculatePerimetralSides(tri, allTris));
            tris.push_back(tri);
        }

        sector.SetTriangles(tris);
    }

}

void hpms::WalkmapConverter::ProcessPerimeter(const hpms::Polygon& polygon, const std::string& path)
{
    std::vector<Polygon> polys;
    ProcessPolygons(polys, path);
    auto processedPoly = polys[0];
    //polygon.SetSides(processedPoly.GetSides());
}

void hpms::WalkmapConverter::ProcessObstacles(const std::vector<Polygon>& obstacles, const std::string& path)
{
    ProcessPolygons(obstacles, path);
}

void hpms::WalkmapConverter::ProcessPolygons(const std::vector<Polygon>& obstacles, const std::string& path)
{
    std::vector<glm::vec3> vertices;
    std::vector<glm::ivec2> lines;
    auto process = [&vertices, &lines](const std::string& line)
    {
        std::vector<std::string> tokens = hpms::Split(line, "\\s+");
        char type = tokens[0].at(0);
        switch (type)
        {
            case 'l':
                lines.emplace_back(std::stoi(tokens[1]), std::stoi(tokens[2]));
                break;
            case 'v':
                vertices.emplace_back(std::stof(tokens[1]), std::stof(tokens[2]), std::stof(tokens[3]));
                break;
            default:
                break;
        }
    };
    hpms::ProcessFileLines(path, process);
    std::vector<std::vector<glm::ivec2>> splittedSides = SplitSides(lines);
}

std::vector<std::vector<glm::ivec2>> hpms::WalkmapConverter::SplitSides(const std::vector<glm::ivec2>& lines)
{
    std::vector<std::vector<glm::ivec2>> splittedSides;

}

unsigned int hpms::Face::ProcessIndex(const std::string& token)
{
    int sIndex = token.find('/');
    if (sIndex < 0)
    {
        return std::stoi(token);
    } else
    {
        return std::stoi(token.substr(0, sIndex));
    }
}
