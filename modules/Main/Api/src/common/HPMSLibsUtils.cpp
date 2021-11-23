/*!
 * File HPMSLibsUtils.cpp
 */

#include <common/HPMSLibsUtils.h>

template<typename T1, typename T2>
T1 hpms::FindClosestKey(const std::map<T1, T2>& data, T1 key)
{
    if (data.empty())
    {
        LOG_WARN("Cannot find closest key in empty map");
    }

    auto lower = data.lower_bound(key);

    if (lower == data.end())
    {
        return std::prev(lower)->first;
    }

    if (lower == data.begin())
    {
        return lower->first;
    }

    auto previous = std::prev(lower);
    if ((key - previous->first) < (lower->first - key))
    {
        return previous->first;
    }

    return lower->first;
}