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
    class SideAdaptee : public SideAdapter
    {
    private:
        hpms::Side sideData;
    public:
        SideAdaptee(const Side& sideData);

        virtual ~SideAdaptee() override;

        virtual unsigned int IdX1() override;

        virtual unsigned int IdX2() override;
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

        virtual std::string GetSectorId() override;

        virtual const std::vector<SideAdapter*>& GetPerimetralSides() const override;

    };

    class WalkmapAdaptee : public WalkmapAdapter, public AdapteeCommon
    {
    private:
        hpms::WalkmapPtr walkmap;
        std::unordered_map<hpms::Triangle, TriangleAdaptee*, TriangleHash> triangles;
    public:
        WalkmapAdaptee(const std::string& mapName);

        virtual ~WalkmapAdaptee() override;

        virtual std::string GetId() override;

        virtual TriangleAdapter* SampleTriangle(const glm::vec3& pos, float tolerance) override;
    };
}