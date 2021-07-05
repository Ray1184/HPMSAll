/*!
 * File HPMSLibsUtils.h
 */


#pragma once

#include <map>
#include "HPMSUtils.h"

namespace hpms
{
    template<typename T1, typename T2>
    T1 FindClosestKey(const std::map<T1, T2>& data, T1 key);
}