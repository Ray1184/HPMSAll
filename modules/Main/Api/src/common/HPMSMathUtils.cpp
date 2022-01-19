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
//bool hpms::CircleLineIntersect(const glm::vec2& pointA, const glm::vec2& pointB, const glm::vec2& origin, float radius)
{
	float dx = p2.x - p1.x;
	float dy = p2.y - p1.y;
	//std::stringstream ss;
	//ss << "DX: " << dx << std::endl;
	//ss << "DY: " << dy << std::endl;
	glm::mat4 transf = glm::eulerAngleZ(std::atan2(dy, dx));//glm::eulerAngleXY(dx, dy); 	
	//ss << "\nROTATED MATRIX:\n" << hpms::PrintMatrix(transf) << std::endl;
	transf = glm::inverse(transf);
	//ss << "\nINVERTED MATRIX:\n" << hpms::PrintMatrix(transf) << std::endl;
	transf = glm::translate(transf, glm::vec3(- center.x, -center.y, 0.0f));
	//transf = glm::transpose(transf);
	//ss << "\nTRANSLATED MATRIX:\n" << hpms::PrintMatrix(transf) << std::endl;
	glm::vec2 p1a = hpms::MultVec2Mat4(p1, transf); // glm::vec4(glm::vec3(p1.x, p1.y, 0.0f), 0.0f)* transf;
	glm::vec2 p2a = hpms::MultVec2Mat4(p2, transf); // glm::vec4(glm::vec3(p2.x, p2.y, 0.0f), 0.0f) * transf;

	//ss << "\nP1 * MATRIX: " << hpms::PrintVec2(p1a) << std::endl;
	//ss << "\nP2 * MATRIX: " << hpms::PrintVec2(p2a) << std::endl;

	//LOG_INFO(ss.str().c_str());

	float y = p1a.y;
	float minX = std::min(p1a.x, p2a.x);
	float maxX = std::max(p1a.x, p2a.x);
	if (y == radius || y == -radius) {
		return 0 <= maxX && 0 >= minX;
	}
	else if (y < radius && y > -radius) {
		float x = std::sqrt(radius * radius - y * y);
		if (-x <= maxX && -x >= minX) {
			return true;
		}
		return x <= maxX && x >= minX;
	}
	return false;
	
	//float theta = atan2(dy, dx);
	//transf = glm::rotate(transf, theta, glm::vec3(1, 0, 0));

	//bool segment = true;
	//std::vector<glm::vec2> res;
	//auto x0 = cp.x;
	//auto y0 = cp.y;
	//auto x1 = p1.x;
	//auto y1 = p1.y;
	//auto x2 = p2.x;
	//auto y2 = p2.y;
	//auto A = y2 - y1;
	//auto B = x1 - x2;
	//auto C = x2 * y1 - x1 * y2;
	//auto a = sq(A) + sq(B);
	//float b, c;
	//bool bnz = true;
	//if (abs(B) >= eps) {
	//	b = 2 * (A * C + A * B * y0 - sq(B) * x0);
	//	c = sq(C) + 2 * B * C * y0 - sq(B) * (sq(r) - sq(x0) - sq(y0));
	//}
	//else {
	//	b = 2 * (B * C + A * B * x0 - sq(A) * y0);
	//	c = sq(C) + 2 * A * C * x0 - sq(A) * (sq(r) - sq(x0) - sq(y0));
	//	bnz = false;
	//}
	//auto d = sq(b) - 4 * a * c; // discriminant
	//if (d < 0) {
	//	return false;
	//}
	//
	//// checks whether a glm::vec2 is within a segment
	//auto within = [x1, y1, x2, y2](float x, float y) {
	//	//auto d1 = sqrt(sq(x2 - x1) + sq(y2 - y1));  // distance between end-glm::vec2s
	//	//auto d2 = sqrt(sq(x - x1) + sq(y - y1));    // distance from glm::vec2 to one end
	//	//auto d3 = sqrt(sq(x2 - x) + sq(y2 - y));    // distance from glm::vec2 to other end
	//	//auto delta = d1 - d2 - d3;
	//	//return abs(delta) < eps;                    // true if delta is less than a small tolerance
	//	return IsBetween(glm::vec2(x1, y1), glm::vec2(x2, y2), glm::vec2(x, y));
	//};
	//
	//auto fx = [A, B, C](float x) {
	//	return -(A * x + C) / B;
	//};
	//
	//auto fy = [A, B, C](float y) {
	//	return -(B * y + C) / A;
	//};
	//
	//auto rxy = [segment, &res, within](float x, float y) {
	//	if (!segment || within(x, y)) {
	//		res.push_back(glm::vec2(x, y));
	//	}
	//};
	//
	//float x, y;
	//if (d == 0.0) {
	//	// line is tangent to circle, so just one intersect at most
	//	if (bnz) {
	//		x = -b / (2 * a);
	//		y = fx(x);
	//		rxy(x, y);
	//	}
	//	else {
	//		y = -b / (2 * a);
	//		x = fy(y);
	//		rxy(x, y);
	//	}
	//}
	//else {
	//	// two intersects at most
	//	d = sqrt(d);
	//	if (bnz) {
	//		x = (-b + d) / (2 * a);
	//		y = fx(x);
	//		rxy(x, y);
	//		x = (-b - d) / (2 * a);
	//		y = fx(x);
	//		rxy(x, y);
	//	}
	//	else {
	//		y = (-b + d) / (2 * a);
	//		x = fy(y);
	//		rxy(x, y);
	//		y = (-b - d) / (2 * a);
	//		x = fy(y);
	//		rxy(x, y);
	//	}
	//}

	//return !res.empty();
	
	/*
	float baX = pointB.x - pointA.x;
	float baY = pointB.y - pointA.y;
	float caX = origin.x - pointA.x;
	float caY = origin.y - pointA.y;

	float a = baX * baX + baY * baY;
	float bBy2 = baX * caX + baY * caY;
	float c = caX * caX + caY * caY - radius * radius;

	float pBy2 = bBy2 / a;
	float q = c / a;

	float disc = pBy2 * pBy2 - q;
	if (disc < 0)
	{
		return false;
	}
	float tmpSqrt = std::sqrt(disc);
	float abScalingFactor = -pBy2 + tmpSqrt;
	glm::vec2 pointC = glm::vec2(pointA.x - baX * abScalingFactor, pointA.y - baY * abScalingFactor);
	return IsBetween(pointA, pointB, pointC);*/
}

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
	response->collided = false;
	bool inside = PointInsidePolygon(point, t, polygon);

	if ((!inside && sideMode == INSIDE) || (inside && sideMode == OUTSIDE))
	{
		return;
	}

	std::vector<hpms::CollisionResponse> responses;
	for (int i = 0; i < polygon.size() - 1; i++)
	{
		glm::vec2 translatedCenter = point + t;
		if (CircleLineIntersect(polygon[i], polygon[i + 1], translatedCenter, radius))
		{
			CollisionResponse cr{ true, polygon[i], polygon[i + 1] };
			responses.push_back(cr);
			if (responses.size() >= 2)
			{
				break;
			}
		}
	}
	if (responses.size() == 1)
	{
		response->CopyFrom(responses[0]);
		return;
	}

	if (responses.size() >= 2)
	{
		
		if (!response->Equals(responses[0]))
		{
			response->CopyFrom(responses[1]);
		}	
		if (!response->Equals(responses[1]))
		{
			response->CopyFrom(responses[0]);
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