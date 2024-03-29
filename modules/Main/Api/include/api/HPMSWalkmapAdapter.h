/*!
 * File HPMSWalkmapAdapter.h
 */

#pragma once

#include <common/HPMSObject.h>
#include <common/HPMSMathUtils.h>
#include <vector>
#include <string>
#include <glm/glm.hpp>
#include <functional>

namespace hpms
{

    class SideAdapter : public Object
    {
    public:

        inline const std::string Name() const override
        {
            return "SideAdapter";
        }

        inline virtual ~SideAdapter()
        {

        }

        virtual unsigned int IdX1() = 0;

        virtual unsigned int IdX2() = 0;
    };

    class TriangleAdapter : public Object
    {
    public:

        inline const std::string Name() const override
        {
            return "TriangleAdapter";
        }

        inline virtual ~TriangleAdapter()
        {

        }

        virtual float X1() = 0;

        virtual float X2() = 0;

        virtual float X3() = 0;

        virtual float Y1() = 0;

        virtual float Y2() = 0;

        virtual float Y3() = 0;

        virtual float Z1() = 0;

        virtual float Z2() = 0;

        virtual float Z3() = 0;

        virtual bool IsPerimetral() = 0;

        virtual std::string GetSectorId() const = 0;

        inline virtual void SetSectorId(const std::string& sectorId)
        {
            // Not implemented.
        }

        virtual const std::vector<SideAdapter*>& GetPerimetralSides() const = 0;

    };

    class SectorAdapter : public Object
    {
    public:

        inline const std::string Name() const override
        {
            return "SectorAdapter";
        }

        inline virtual ~SectorAdapter()
        {

        }

        virtual std::string GetId() = 0;
    };

    class PathStepAdapter : public Object
    {
    public:

        inline const std::string Name() const override
        {
            return "PathStepAdapter";
        }

        inline virtual ~PathStepAdapter()
        {

        }

        virtual int GetId() = 0;

        virtual TriangleAdapter* GetTriangle() = 0;

        virtual bool IsBound(PathStepAdapter* path) = 0;

        virtual std::vector<int> GetAllLinked() = 0;

        virtual glm::vec2 GetCoords() = 0;
    };

    class WalkmapAdapter : public Object
    {

    public:

        inline const std::string Name() const override
        {
            return "WalkmapAdapter";
        }

        inline virtual ~WalkmapAdapter()
        {

        }

        virtual std::string GetId() = 0;

        virtual TriangleAdapter* SampleTriangle(const glm::vec3& pos, float tolerance) = 0;

        virtual PathStepAdapter* SamplePath(const glm::vec3& pos, float tolerance) = 0;

        virtual void Collides(const glm::vec3& pos, float radius, CollisionResponse* response) = 0;

        virtual void ForEachTriangle(const std::function<bool(TriangleAdapter* tri)>& visitor) = 0;

        virtual void ForEachSide(const std::function<bool(const glm::vec2& sizeAPos, const glm::vec2& sizeBPos)>& visitor) = 0;

        virtual void ForEachPathStep(const std::function<bool(PathStepAdapter* path)>& visitor) = 0;

        virtual std::pair<glm::vec2, glm::vec2> GetSideCoordsFromTriangle(hpms::TriangleAdapter* tri, hpms::SideAdapter* side) = 0;

    };
}