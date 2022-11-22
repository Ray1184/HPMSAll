/*!
 * File HPMSWalkmapAdaptee.h
 */

#pragma once

#include <api/HPMSWalkmapAdapter.h>
#include <resource/HPMSWalkmapManager.h>
#include <core/HPMSAdapteeCommon.h>
#include <map>

namespace hpms
{
    struct SideHash
    {
        std::size_t operator()(const Side& k) const
        {
            return std::hash<unsigned int>()(k.idx1)
                   ^ std::hash<unsigned int>()(k.idx2);
        }
    };

    class SideAdaptee : public SideAdapter
    {
    private:
        hpms::Side sideData;
    public:
        SideAdaptee(const Side& sideData);

        virtual ~SideAdaptee() override;

        virtual unsigned int IdX1() override;

        virtual unsigned int IdX2() override;

        const Side& GetSideData() const;
    };

    struct TriangleHash
    {
        std::size_t operator()(const Triangle& k) const
        {
            return std::hash<bool>()(k.IsPerimetral())
                   ^ std::hash<std::string>()(k.GetSectorId())
                   ^ std::hash<float>()(k.x1)
                   ^ std::hash<float>()(k.x2)
                   ^ std::hash<float>()(k.x3)
                   ^ std::hash<float>()(k.y1)
                   ^ std::hash<float>()(k.y2)
                   ^ std::hash<float>()(k.y3)
                   ^ std::hash<float>()(k.z1)
                   ^ std::hash<float>()(k.z2)
                   ^ std::hash<float>()(k.z3);
        }
    };

    struct PathStepHash
    {
        std::size_t operator()(const PathStep& k) const
        {
            return std::hash<int>()(k.GetId());
        }
    };

    class TriangleAdaptee : public TriangleAdapter
    {
    private:
        hpms::Triangle triData;
        std::vector<SideAdapter*> sides;
    public:
        explicit TriangleAdaptee(const hpms::Triangle& tri);

        virtual ~TriangleAdaptee() override;

        virtual float X1() override;

        virtual float X2() override;

        virtual float X3() override;

        virtual float Y1() override;

        virtual float Y2() override;

        virtual float Y3() override;

        virtual float Z1() override;

        virtual float Z2() override;

        virtual float Z3() override;

        virtual bool IsPerimetral() override;

        virtual std::string GetSectorId() const override;

        virtual const std::vector<SideAdapter*>& GetPerimetralSides() const override;

        const Triangle& GetTriData() const;

    };

    class PathStepAdaptee : public PathStepAdapter
    {
    private:
        hpms::PathStep pathData;
        hpms::TriangleAdapter* triangle;
    public:  

        explicit PathStepAdaptee(const PathStep& pathStep);

        virtual ~PathStepAdaptee() override;

        virtual int GetId() override;

        virtual TriangleAdapter* GetTriangle() override;

        virtual bool IsBound(PathStepAdapter* path) override;

        virtual std::vector<int> GetAllLinked() override;

        virtual glm::vec2 GetCoords() override;
    };

    class WalkmapAdaptee : public WalkmapAdapter, public AdapteeCommon
    {
    private:
        hpms::WalkmapPtr walkmap;
        std::unordered_map<hpms::Triangle, TriangleAdaptee*, TriangleHash> triangles;
        std::unordered_map<hpms::PathStep, PathStepAdaptee*, PathStepHash> paths;
        std::unordered_map<hpms::Triangle, PathStepAdaptee*, TriangleHash> pathsByTriangles;
    public:
        WalkmapAdaptee(const std::string& mapName);

        virtual ~WalkmapAdaptee() override;

        virtual std::string GetId() override;

        virtual TriangleAdapter* SampleTriangle(const glm::vec3& pos, float tolerance) override;

        virtual PathStepAdapter* SamplePath(const glm::vec3& pos, float tolerance) override;

        virtual void Collides(const glm::vec3& pos, float radius, CollisionResponse* response) override;

        virtual void ForEachTriangle(const std::function<bool(TriangleAdapter* tri)>& visitor) override;

        virtual void ForEachSide(const std::function<bool(const glm::vec2& sizeAPos, const glm::vec2& sizeBPos)>& visitor) override;

        virtual void ForEachPathStep(const std::function<bool(PathStepAdapter* path)>& visitor) override;

        virtual std::pair<glm::vec2, glm::vec2> GetSideCoordsFromTriangle(hpms::TriangleAdapter* tri, hpms::SideAdapter* side) override;
    };
}