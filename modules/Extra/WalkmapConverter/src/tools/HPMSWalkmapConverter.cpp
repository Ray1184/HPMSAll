/*!
 * File WalkmapConverter.cpp
 */

#include <tools/HPMSWalkmapConverter.h>
#include <utils/HPMSCalcUtils.h>
#include <regex>
#include <algorithm>
#include <sstream>
#include <array>
#include <functional>

hpms::WalkmapData *hpms::WalkmapConverter::LoadWalkmap(const std::string &path)
{
    std::vector<hpms::Sector> sectors;
    Polygon perimeter;
    std::vector<hpms::Polygon> obstacles;
    std::string basePath = path;
    std::string perimeterPath = basePath.replace(basePath.find(".walkmap.obj"), basePath.size(), ".perimeter.obj");
    basePath = path;
    std::string obstaclesPath = basePath.replace(basePath.find(".walkmap.obj"), basePath.size(), ".obstacles.obj");
    ProcessSectors(sectors, path);
    ProcessPerimeter(&perimeter, perimeterPath);
    ProcessObstacles(obstacles, obstaclesPath);
    std::string roomName = hpms::GetFileName(path);
    auto *map = hpms::SafeNew<WalkmapData>(roomName, sectors, perimeter, obstacles);
    return map;
}

void hpms::WalkmapConverter::ProcessSectors(std::vector<hpms::Sector> &sectors, const std::string &path)
{
    if (!hpms::FileExists(path)) 
    {
        LOG_WARN("Sector data not found");
        return;
    }
    std::vector<glm::vec3> vertices;
    std::vector<hpms::Face> faces;
    std::unordered_map<std::string, std::string> faceRefToSectorName;
    std::unordered_map<std::string, hpms::Sector> sectorsById;
    std::string currentSector;

    auto process = [&vertices, &faces, &faceRefToSectorName, &currentSector, &sectorsById](const std::string &line)
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

    for (const auto &face : faces)
    {
        glm::vec3 t1 = glm::vec3(vertices[face.indexA].x, vertices[face.indexA].y, vertices[face.indexA].z);
        glm::vec3 t2 = glm::vec3(vertices[face.indexB].x, vertices[face.indexB].y, vertices[face.indexB].z);
        glm::vec3 t3 = glm::vec3(vertices[face.indexC].x, vertices[face.indexC].y, vertices[face.indexC].z);
        std::string sectorId = faceRefToSectorName[face.lineRef];
        Triangle tri = hpms::Triangle(sectorId, t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, t3.x, t3.y, t3.z);
        sectorsById[sectorId].AddTriangle(tri);
    }

    for (const auto &sec : sectorsById)
    {
        hpms::Sector sector = sec.second;
        sectors.push_back(sector);
    }

    ProcessPerimetralSides(sectors);
}

void hpms::WalkmapConverter::ProcessPerimetralSides(std::vector<hpms::Sector> &sectors)
{
    std::vector<Triangle> allTris;
    for (auto &sector : sectors)
    {
        for (const auto &tri : sector.GetTriangles())
        {
            allTris.push_back(tri);
        }
    }

    for (auto &sector : sectors)
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

void hpms::WalkmapConverter::ProcessPerimeter(hpms::Polygon *polygon, const std::string &path)
{
    if (!hpms::FileExists(path)) 
    {
        LOG_WARN("Perimeter data not found");
        return;
    }
    std::vector<Polygon> polys;
    ProcessPolygons(polys, path);
    *polygon = polys[0];
}

void hpms::WalkmapConverter::ProcessObstacles(std::vector<Polygon> &obstacles, const std::string &path)
{
    if (!hpms::FileExists(path)) 
    {
        LOG_WARN("Obstacles data not found");
        return;
    }
    ProcessPolygons(obstacles, path);
}

void hpms::WalkmapConverter::ProcessPolygons(std::vector<Polygon> &polys, const std::string &path)
{
    std::vector<glm::vec3> vertices;
    std::vector<glm::ivec2> lines;
    auto process = [&vertices, &lines](const std::string &line)
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
    RawPolygon rawPoly{vertices, splittedSides};
    ParsePolygons(polys, rawPoly);
}

void hpms::WalkmapConverter::ParsePolygons(std::vector<Polygon> &polys, const RawPolygon &rawPoly)
{
    for (auto &sides : rawPoly.sideGroups)
    {
        HPMS_ASSERT(sides.size() > 2, "At least a triangle is required (size >= 3)");
        glm::ivec2 lastIndex = sides[0];
        unsigned int first = lastIndex.x;
        unsigned int second = lastIndex.y;
        glm::vec3 vertA = rawPoly.vertices[first - 1];
        glm::vec3 vertB = rawPoly.vertices[second - 1];
        std::vector<glm::vec2> sortedData;
        sortedData.push_back(vertA);
        sortedData.push_back(vertB);

        for (int i = 1; i < sides.size(); i++)
        {
            glm::ivec2* next = Next(&lastIndex, sides);
            glm::vec3 vert = rawPoly.vertices[lastIndex.y - 1];
            sortedData.push_back(V3_TO_V2(vert));
            lastIndex = *next;
            hpms::SafeDeleteRaw(next);
        }
        Polygon poly(sortedData);
        polys.push_back(poly);
    }
}

std::vector<std::vector<glm::ivec2>> hpms::WalkmapConverter::SplitSides(const std::vector<glm::ivec2> &lines)
{
    std::vector<std::vector<glm::ivec2>> splittedSides;
    std::vector<glm::ivec2> linesCopy = std::vector<glm::ivec2>(lines);
    auto sorter = [](glm::ivec2 a, glm::ivec2 b)
    { return a.x < b.x; };
    std::sort(std::begin(linesCopy), std::end(linesCopy), sorter);
    
    std::vector<glm::ivec2> refSides(linesCopy);
    glm::ivec2 *next = nullptr;
    std::vector<glm::ivec2 *> pointers;
    while (!refSides.empty())
    {
        std::vector<glm::ivec2> subSides;
        while (next = Next(next, refSides))
        {
            subSides.push_back(*next);
            pointers.push_back(next);
            auto finder = [&](const auto &val)
            { return val.x == next->x && val.y == next->y; };
            std::vector<glm::ivec2>::iterator i = std::find_if(refSides.begin(), refSides.end(), finder);
            refSides.erase(i);
        }
        splittedSides.push_back(subSides);
    }

    for (auto* pointer : pointers) {
        hpms::SafeDeleteRaw(pointer);
    }
    return splittedSides;
}

glm::ivec2* hpms::WalkmapConverter::Next(glm::ivec2 *current, const std::vector<glm::ivec2> &sides)
{
    if (current == nullptr)
    {
        return hpms::SafeNewRaw<glm::ivec2>(sides[0]);
    }
    for (auto &side : sides)
    {
        if (side.x == current->y)
        {
            return hpms::SafeNewRaw<glm::ivec2>(side);
        }
    }
    return nullptr;
}

unsigned int hpms::Face::ProcessIndex(const std::string &token)
{
    int sIndex = token.find('/');
    if (sIndex < 0)
    {
        return std::stoi(token);
    }
    else
    {
        return std::stoi(token.substr(0, sIndex));
    }
}
