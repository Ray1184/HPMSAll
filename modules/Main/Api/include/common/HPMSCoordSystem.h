/*!
 * File HPMSCoordSystem.h
 */

#include <common/HPMSDefs.h>

#pragma once

#ifdef COORD_SYSTEM_BLENDER
#define SD1 x1
#define SD2 x2
#define SD3 x3
#define FW1 y1
#define FW2 y2
#define FW3 y3
#define UP1 z1
#define UP2 z2
#define UP3 z3
#define TO_SD1() X1()
#define TO_SD2() X2()
#define TO_SD3() X3()
#define TO_FW1() Y1()
#define TO_FW2() Y2()
#define TO_FW3() Y3()
#define TO_UP1() Z1()
#define TO_UP2() Z2()
#define TO_UP3() Z3()
#define SD(v) v.x
#define FW(v) v.y
#define UP(v) v.z
#define ADDV3_V2(v3, v2) glm::vec3(v3.x + v2.x, v3.y + v2.y, v3.z)
#define V2_TO_V3(v2) glm::vec3(v2.x, v2.y, 0)
#define V3_TO_V2(v3) glm::vec2(v3.x, v3.y)
#define VEC_FORWARD glm::vec3(0, 1, 0)
#define VEC_UP glm::vec3(0, 0, 1)
#else
#define SD1 x1
#define SD2 x2
#define SD3 x3
#define FW1 z1
#define FW2 z2
#define FW3 z3
#define UP1 y1
#define UP2 y2
#define UP3 y3
#define TO_SD1() X1()
#define TO_SD2() X2()
#define TO_SD3() X3()
#define TO_FW1() Z1()
#define TO_FW2() Z2()
#define TO_FW3() Z3()
#define TO_UP1() Y1()
#define TO_UP2() Y2()
#define TO_UP3() Y3()
#define SD(v) v.x
#define FW(v) v.z
#define UP(v) v.y
#define ADDV3_V2(v3, v2) glm::vec3(v3.x + v2.x, v3.y, v3.z + v2.y)
#define V2_TO_V3(v2) glm::vec3(v2.x, 1, v2.y)
#define V3_TO_V2(v3) glm::vec2(v3.x, v3.z)
#define VEC_FORWARD glm::vec3(1, 0, 0)
#define VEC_UP glm::vec3(0, 1, 0)
#endif