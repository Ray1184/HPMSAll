/*!
 * File HPMSWalkmap.h
 */

#pragma once

#include <OgreResource.h>
#include <OgreResourceManager.h>
#include <common/HPMSObject.h>
#include <common/HPMSUtils.h>
#include <common/HPMSDefs.h>
#include <pods/pods.h>
#ifdef USE_PODS_MSG_PACK
#include <pods/msgpack.h>
#define  POD_SERIALIZER pods::MsgPackSerializer
#define  POD_DESERIALIZER pods::MsgPackDeserializer
#else
#include <pods/binary.h>
#define  POD_SERIALIZER pods::BinarySerializer
#define  POD_DESERIALIZER pods::BinaryDeserializer
#endif
#include <pods/buffers.h>
#include <common/HPMSCoordSystem.h>
#include <glm/glm.hpp>

#define UNDEFINED_SECTOR "__undef__"

namespace hpms
{

    class Side : public hpms::Object
    {

    public:
        unsigned int idx1, idx2;
        float x1, y1, z1;
        float x2, y2, z2;

        Side(unsigned int idx1, unsigned int idx2) : idx1(idx1), idx2(idx2)
        {
        }

        Side()
        {
        }

        PODS_SERIALIZABLE(
            1,
            PODS_OPT(idx1),
            PODS_OPT(idx2),
            PODS_OPT(x1),
            PODS_OPT(y1),
            PODS_OPT(z1),
            PODS_OPT(x2),
            PODS_OPT(y2),
            PODS_OPT(z2)

        );

        bool operator==(const Side &rhs) const
        {
            return x1 == rhs.x1 && y1 == rhs.y1 && z1 == rhs.z1 && x2 == rhs.x2 && y2 == rhs.y2 && z2 == rhs.z2;
        }

        bool operator!=(const Side &rhs) const
        {
            return !(rhs == *this);
        }

        virtual const std::string Name() const override
        {
            return "Side";
        }
    };

    class Triangle : public hpms::Object
    {
    private:
        std::string sectorId;
        std::vector<hpms::Side> perimetralSides;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(sectorId),
            PODS_OPT(perimetralSides),
            PODS_OPT(x1),
            PODS_OPT(y1),
            PODS_OPT(z1),
            PODS_OPT(x2),
            PODS_OPT(y2),
            PODS_OPT(z2),
            PODS_OPT(x3),
            PODS_OPT(y3),
            PODS_OPT(z3)

        );

        float x1, y1, z1;
        float x2, y2, z2;
        float x3, y3, z3;

        Triangle(const std::string &groupId,
                 const std::vector<Side> &perimetralSides, float x1, float y1, float z1, float x2, float y2, float z2,
                 float x3, float y3, float z3) : sectorId(groupId),
                                                 perimetralSides(perimetralSides), x1(x1), y1(y1), z1(z1), x2(x2),
                                                 y2(y2),
                                                 z2(z2), x3(x3), y3(y3), z3(z3)
        {
        }

        Triangle(const std::string &groupId,
                 float x1, float y1, float z1, float x2, float y2, float z2,
                 float x3, float y3, float z3) : sectorId(groupId),
                                                 x1(x1), y1(y1), z1(z1), x2(x2), y2(y2),
                                                 z2(z2), x3(x3), y3(y3), z3(z3)
        {
        }

        Triangle(const std::string &groupId,
                 const std::vector<Side> &perimetralSides) : sectorId(groupId),
                                                             perimetralSides(perimetralSides)
        {
        }

        Triangle(const std::string &groupId) : sectorId(groupId)
        {
        }

        Triangle() : sectorId(UNDEFINED_SECTOR)
        {
        }

        bool IsPerimetral() const
        {
            return !perimetralSides.empty();
        }

        const std::string &GetSectorId() const
        {
            return sectorId;
        }

        void SetSectorId(const std::string &sectorId)
        {
            LOG_WARN("Cannot change triangle sector id from script");
        }

        void SetPerimetralSides(const std::vector<Side> &sides)
        {
            Triangle::perimetralSides.insert(perimetralSides.end(), sides.begin(), sides.end());
        }

        const std::vector<Side> &GetPerimetralSides() const
        {
            return perimetralSides;
        }

        bool operator==(const Triangle &rhs) const
        {
            return sectorId == rhs.sectorId &&
                   x1 == rhs.x1 &&
                   y1 == rhs.y1 &&
                   z1 == rhs.z1 &&
                   x2 == rhs.x2 &&
                   y2 == rhs.y2 &&
                   z2 == rhs.z2 &&
                   x3 == rhs.x3 &&
                   y3 == rhs.y3 &&
                   z3 == rhs.z3;
        }

        bool operator!=(const Triangle &rhs) const
        {
            return !(rhs == *this);
        }

        virtual const std::string Name() const override
        {
            return "Triangle";
        }
    };

    class Sector : public hpms::Object
    {
    private:
        std::string id;
        std::vector<Triangle> triangles;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(id),
            PODS_OPT(triangles)

        );

        Sector(const std::string &id, const std::vector<Triangle> &triangles)
            : id(id), triangles(triangles)
        {
        }

        Sector(const std::string &id) : id(id)
        {
        }

        Sector()
        {
        }

        const std::string &GetId() const
        {
            return id;
        }

        void SetId(const std::string &id)
        {
            Sector::id = id;
        }

        void AddTriangle(const Triangle &tri)
        {
            triangles.push_back(tri);
        }

        const std::vector<Triangle> &GetTriangles() const
        {
            return triangles;
        }

        void SetTriangles(const std::vector<Triangle> &sectors)
        {
            Sector::triangles = sectors;
        }

        bool operator==(const Sector &rhs) const
        {
            return id == rhs.id;
        }

        bool operator!=(const Sector &rhs) const
        {
            return !(rhs == *this);
        }

        virtual const std::string Name() const override
        {
            return "Sector";
        }
    };

    class PathStep : public hpms::Object
    {
    private:
        std::string id;
        glm::vec2 coord;
        std::vector<std::string> linked;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(coord.x),
            PODS_OPT(coord.y),
            PODS_OPT(id),
            PODS_OPT(linked)

        );


        const glm::vec2& GetCoords() const
        {
            return coord;
        }

        void SetCoord(const glm::vec2& coord)
        {
            PathStep::coord = coord;
        }

        const std::string& GetId() const
        {
            return id;
        }

        void SetId(const std::string& id)
        {
            PathStep::id = id;
        }

        inline void Bind(const PathStep& path)
        {
            linked.push_back(path.id);
        }

        inline bool IsBound(const PathStep& path)
        {
            return std::find(linked.begin(), linked.end(), path.id) != linked.end();
        }
        virtual const std::string Name() const override
        {
            return "PathStep";
        }
    };

    class Line : public hpms::Object
    {
    private:
        glm::vec2 data;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(data.x),
            PODS_OPT(data.y)

        );

        inline Line(const glm::vec2 &data) : data(data)
        {
        }

        inline Line()
        {
        }

        inline Line(const Line &line)
        {
            Line::data = line.data;
        }

        const glm::vec2 &GetData() const
        {
            return data;
        }

        void SetData(const glm::vec2 &data)
        {
            Line::data = data;
        }

        virtual const std::string Name() const override
        {
            return "Line";
        }
    };

    class Polygon : public hpms::Object
    {
    private:
        std::vector<Line> dataSerializable;
        std::vector<glm::vec2> data;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(dataSerializable)

        );

        inline Polygon(const std::vector<Line> &dataSerializable) : dataSerializable(dataSerializable)
        {
        }

        inline Polygon(const std::vector<glm::vec2> &data) : data(data)
        {
        }

        inline Polygon()
        {
        }

        // FIXME: find better solution
        inline void BeforeSerialization() 
        {
            for (auto& v : data)
            {
                dataSerializable.emplace_back(v);            
            }
        }

        // FIXME: find better solution
        inline void AfterDeSerialization()
        {
            for (auto& v : dataSerializable)
            {
                glm::vec2 v2 = v.GetData();
                data.push_back(v2);            
            }
        }

        inline Polygon(const Polygon &poly)
        {
            Polygon::data = poly.data;
            Polygon::dataSerializable = poly.dataSerializable;
        }

        const std::vector<glm::vec2> &GetData() const
        {
            return data;
        }

        void SetData(const std::vector<glm::vec2> &data)
        {
            Polygon::data = data;
        }

        virtual const std::string Name() const override
        {
            return "Polygon";
        }
    };

    class WalkmapData : public hpms::Object
    {
    private:
        std::vector<Sector> sectors;
        Polygon perimeter;
        std::vector<Polygon> obstacles;
        std::vector<PathStep> paths;
        std::string id;

    public:
        PODS_SERIALIZABLE(
            1,
            PODS_OPT(id),
            PODS_OPT(sectors),
            PODS_OPT(perimeter),
            PODS_OPT(obstacles),
            PODS_OPT(paths)

        );

        inline WalkmapData(const std::string &id, const std::vector<Sector> &sectorGroups, const Polygon &perimeter, const std::vector<Polygon> &obstacles) : id(id),
                                                                                                                                                              sectors(sectorGroups),
                                                                                                                                                              perimeter(perimeter),
                                                                                                                                                              obstacles(obstacles)
        {
        }

        inline WalkmapData(const std::string &id, const std::vector<Sector> &sectorGroups) : id(id),
                                                                                             sectors(sectorGroups)
        {
        }

        inline WalkmapData()
        {
        }

        const std::vector<Sector> &GetSectors() const
        {
            return sectors;
        }

        void SetSectors(const std::vector<Sector> &sectors)
        {
            WalkmapData::sectors = sectors;
        }

        const Polygon &GetPerimeter() const
        {
            return perimeter;
        }

        void SetPerimeter(const Polygon &perimeter)
        {
            WalkmapData::perimeter = perimeter;
        }

        const std::vector<Polygon> &GetObstacles() const
        {
            return obstacles;
        }

        void SetObstacles(const std::vector<Polygon> &obstacles)
        {
            WalkmapData::obstacles = obstacles;
        }

        const std::vector<PathStep>& GetPaths() const
        {
            return paths;
        }

        void SetPaths(const std::vector<PathStep>& paths)
        {
            WalkmapData::paths = paths;
        }


        const std::string &GetId() const
        {
            return id;
        }

        void SetId(const std::string &id)
        {
            WalkmapData::id = id;
        }

        virtual const std::string Name() const override
        {
            return "WalkmapData";
        }
    };

    class Walkmap : public Ogre::Resource, public hpms::Object
    {
    private:
        WalkmapData *data;
        size_t size;

    protected:
        void loadImpl() override;

        void unloadImpl() override;

        size_t calculateSize() const override;

    public:
        Walkmap(Ogre::ResourceManager *creator, const std::string &name,
                Ogre::ResourceHandle handle, const std::string &group);

        virtual ~Walkmap();

        inline WalkmapData *GetData() const
        {
            return data;
        }

        virtual const std::string Name() const override
        {
            return "Walkmap";
        }
    };

    typedef Ogre::SharedPtr<Walkmap> WalkmapPtr;
}
