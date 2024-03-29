/*!
 * File HPMSMathUtils.cpp
 */

#include <common/HPMSMathUtils.h>
#include <iostream>
#include <glm/gtx/euler_angles.hpp>

float hpms::IntersectRayLineSegment(float originX, float originY, float dirX, float dirY, float aX, float aY, float bX,
	float bY)
{
	float v1X = originX - aX;
	float v1Y = originY - aY;
	float v2X = bX - aX;
	float v2Y = bY - aY;
	float invV23 = 1.0f / (v2Y * dirX - v2X * dirY);
	float t1 = (v2X * v1Y - v2Y * v1X) * invV23;
	float t2 = (v1Y * dirX - v1X * dirY) * invV23;
	if (t1 >= 0.0f && t2 >= 0.0f && t2 <= 1.0f)
	{
		return t1;
	}
	return -1.0f;
}

bool hpms::CircleLineIntersect(const glm::vec2& p1, const glm::vec2& p2, const glm::vec2& center, float radius)
{
	float dx = p2.x - p1.x;
	float dy = p2.y - p1.y;
	glm::mat4 transf = glm::eulerAngleZ(std::atan2(dy, dx));
	transf = glm::inverse(transf);
	transf = glm::translate(transf, glm::vec3(- center.x, -center.y, 0.0f));
	glm::vec2 p1a = hpms::MultVec2Mat4(p1, transf);
	glm::vec2 p2a = hpms::MultVec2Mat4(p2, transf);

	float y = p1a.y;
	float minX = std::min(p1a.x, p2a.x);
	float maxX = std::max(p1a.x, p2a.x);
	if (y == radius || y == -radius) 
	{
		return 0 <= maxX && 0 >= minX;
	}
	else if (y < radius && y > -radius) 
	{
		float x = std::sqrt(radius * radius - y * y);
		if (-x <= maxX && -x >= minX) 
		{
			return true;
		}
		return x <= maxX && x >= minX;
	}
	return false;
	
}

// UNUSED
bool hpms::IsBetween(const glm::vec2& pt1, const glm::vec2& pt2, const glm::vec2& pt)
{
	const float epsilon = 0.001f;

	if (pt.x - std::max(pt1.x, pt2.x) > epsilon ||
		std::min(pt1.x, pt2.x) - pt.x > epsilon ||
		pt.y - std::max(pt1.y, pt2.y) > epsilon ||
		std::min(pt1.y, pt2.y) - pt.y > epsilon)
		return false;

	if (std::abs(pt2.x - pt1.x) < epsilon)
		return std::abs(pt1.x - pt.x) < epsilon || std::abs(pt2.x - pt.x) < epsilon;
	if (std::abs(pt2.y - pt1.y) < epsilon)
		return std::abs(pt1.y - pt.y) < epsilon || std::abs(pt2.y - pt.y) < epsilon;

	float x = pt1.x + (pt.y - pt1.y) * (pt2.x - pt1.x) / (pt2.y - pt1.y);
	float y = pt1.y + (pt.x - pt1.x) * (pt2.y - pt1.y) / (pt2.x - pt1.x);

	return std::abs(pt.x - x) < epsilon || std::abs(pt.y - y) < epsilon;
	
}

bool hpms::PointInsideCircle(const glm::vec2& point, const glm::vec2& t, float radius)
{
	return std::pow(point.x - t.x, 2) + std::pow(point.y - t.y, 2) < std::pow(radius, 2);
}

bool hpms::PointInsidePolygon(const glm::vec2& point, const glm::vec2& t, const std::vector<glm::vec2>& polygon)
{

	float x = point.x - t.x;
	float y = point.y - t.y;
	unsigned int j = polygon.size() - 1;
	bool oddNodes = false;

	for (unsigned int i = 0; i < polygon.size(); i++)
	{
		if ((polygon[i].y + t.y < y && polygon[j].y + t.y >= y || polygon[j].y + t.y < y && polygon[i].y + t.y >= y) && (polygon[i].x + t.x <= x || polygon[j].x + t.x <= x))
		{
			oddNodes ^= (polygon[i].x + t.x + (y - polygon[i].y + t.y) / (polygon[j].y + t.y - polygon[i].y + t.y) * (polygon[j].x + t.x - polygon[i].x + t.x) < x);
		}
		j = i;
	}

	return oddNodes;
}

void hpms::CircleInteractPolygon(const glm::vec2& point, float radius, const glm::vec2& t, const std::vector<glm::vec2>& polygon, SideMode sideMode, CollisionResponse* response)
{	
	for (int i = 0; i < polygon.size() - 1; i++)
	{
		glm::vec2 translatedCenter = point + t;
		if (CircleLineIntersect(polygon[i], polygon[i + 1], translatedCenter, radius))
		{
			SingleCollisionResponse cr{ true, polygon[i], polygon[i + 1] };
			response->collisions.push_back(cr);
			if (response->collisions.size() >= 2)
			{
				break;
			}
		}
	}	
}

float hpms::CalcHeightOf2DPointInside3DSector(float fw1, float fw2, float fw3, float sd1, float sd2,
	float sd3, float up1, float up2, float up3, const glm::vec2& pos)
{
	float det = (fw2 - fw3) * (sd1 - sd3) + (sd3 - sd2) * (fw1 - fw3);
	float l1 = ((fw2 - fw3) * (SD(pos) - sd3) + (sd3 - sd2) * (FW(pos) - fw3)) / det;
	float l2 = ((fw3 - fw1) * (SD(pos) - sd3) + (sd1 - sd3) * (FW(pos) - fw3)) / det;
	float l3 = 1.0f - l1 - l2;
	return l1 * up1 + l2 * up2 + l3 * up3;
}