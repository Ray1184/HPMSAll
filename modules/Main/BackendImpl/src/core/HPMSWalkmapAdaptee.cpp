/*!
 * File HPMSWalkmapAdaptee.cpp
 */

#include <core/HPMSWalkmapAdaptee.h>
#include <utils/HPMSSectorUtils.h>
#include <common/HPMSMathUtils.h>

std::string hpms::WalkmapAdaptee::GetId()
{
    Check(walkmap.get());
    return walkmap->GetData()->GetId();
}

void hpms::WalkmapAdaptee::ForEachTriangle(const std::function<bool(TriangleAdapter *)> &visitor)
{
    Check(walkmap.get());
    for (const auto &sector : walkmap->GetData()->GetSectors())
    {
        for (const auto &tri : sector.GetTriangles())
        {
            bool exit = visitor(triangles[tri]);
            if (exit)
            {
                return;
            }
        }
    }
}

void hpms::WalkmapAdaptee::ForEachSide(const std::function<bool(const glm::vec2 &, const glm::vec2 &)> &visitor)
{
    Check(walkmap.get());
    int size = walkmap->GetData()->GetPerimeter().GetData().size();


    for (auto& obstacle : walkmap->GetData()->GetObstacles())
    {
        for (int i = 0; i < obstacle.GetData().size() - 1; i++)
        {
            glm::vec2 first = obstacle.GetData()[i];
            glm::vec2 second = obstacle.GetData()[i + 1];
            bool exit = visitor(first, second);
            if (exit)
            {
                return;
            }
        }
    }

    for (int i = 0; i < size - 1; i++)
    {
        glm::vec2 first = walkmap->GetData()->GetPerimeter().GetData()[i];
        glm::vec2 second = walkmap->GetData()->GetPerimeter().GetData()[i + 1];
        bool exit = visitor(first, second);
        if (exit)
        {
            return;
        }
    }

    
}

hpms::TriangleAdapter *hpms::WalkmapAdaptee::SampleTriangle(const glm::vec3 &pos, float tolerance)
{
    Check(walkmap.get());
    Triangle sampled;
    hpms::SampleTriangle(pos, walkmap, tolerance, &sampled);
    return triangles[sampled];
}

void hpms::WalkmapAdaptee::Collides(const glm::vec3 &pos, float radius, CollisionResponse *response)
{
    Check(walkmap.get());
    auto &perimeter = walkmap.get()->GetData()->GetPerimeter().GetData();
    glm::vec2 noTranslation = glm::vec2(0, 0);
    hpms::CircleInteractPolygon(pos, radius, noTranslation, perimeter, INSIDE, response);
    if (!response->AnyCollision())
    {
        for (auto &obstacle : walkmap.get()->GetData()->GetObstacles())
        {
            hpms::CircleInteractPolygon(pos, radius, noTranslation, obstacle.GetData(), OUTSIDE, response);
            if (response->AnyCollision())
            {
                return;
            }
        }
    }
}
std::pair<glm::vec2, glm::vec2> hpms::WalkmapAdaptee::GetSideCoordsFromTriangle(hpms::TriangleAdapter *tri, hpms::SideAdapter *side)
{
    Check(walkmap.get());
    return hpms::GetSideCoordsFromTriangle(&((TriangleAdaptee *)tri)->GetTriData(), &((SideAdaptee *)side)->GetSideData());
}

hpms::WalkmapAdaptee::WalkmapAdaptee(const std::string &mapName) : AdapteeCommon(nullptr)
{
    walkmap = hpms::WalkmapManager::GetSingleton().Create(mapName);
    for (const auto &sector : walkmap->GetData()->GetSectors())
    {
        for (const auto &tri : sector.GetTriangles())
        {
            auto *ad = hpms::SafeNew<TriangleAdaptee>(tri);
            triangles[tri] = ad;
        }
    }
}

hpms::WalkmapAdaptee::~WalkmapAdaptee()
{
    for (const auto &entry : triangles)
    {
        auto *ad = entry.second;
        hpms::SafeDelete(ad);
    }
}

float hpms::TriangleAdaptee::X1()
{
    return triData.x1;
}

float hpms::TriangleAdaptee::X2()
{
    return triData.x2;
}

float hpms::TriangleAdaptee::X3()
{
    return triData.x3;
}

float hpms::TriangleAdaptee::Y1()
{
    return triData.y1;
}

float hpms::TriangleAdaptee::Y2()
{
    return triData.y2;
}

float hpms::TriangleAdaptee::Y3()
{
    return triData.y3;
}

float hpms::TriangleAdaptee::Z1()
{
    return triData.z1;
}

float hpms::TriangleAdaptee::Z2()
{
    return triData.z2;
}

float hpms::TriangleAdaptee::Z3()
{
    return triData.z3;
}

bool hpms::TriangleAdaptee::IsPerimetral()
{
    return triData.IsPerimetral();
}

std::string hpms::TriangleAdaptee::GetSectorId() const
{
    return triData.GetSectorId();
}

const std::vector<hpms::SideAdapter *> &hpms::TriangleAdaptee::GetPerimetralSides() const
{
    return sides;
}

hpms::TriangleAdaptee::TriangleAdaptee(const hpms::Triangle &triData) : triData(triData)
{
    for (const auto &side : triData.GetPerimetralSides())
    {
        auto *ad = hpms::SafeNew<SideAdaptee>(side);
        sides.push_back(ad);
    }
}

hpms::TriangleAdaptee::~TriangleAdaptee()
{
    for (auto *ad : sides)
    {
        hpms::SafeDelete(ad);
    }
}

const hpms::Triangle &hpms::TriangleAdaptee::GetTriData() const
{
    return triData;
}

unsigned int hpms::SideAdaptee::IdX1()
{
    return sideData.idx1;
}

unsigned int hpms::SideAdaptee::IdX2()
{
    return sideData.idx2;
}

hpms::SideAdaptee::SideAdaptee(const hpms::Side &sideData) : sideData(sideData)
{
}

hpms::SideAdaptee::~SideAdaptee()
{
}

const hpms::Side &hpms::SideAdaptee::GetSideData() const
{
    return sideData;
}
