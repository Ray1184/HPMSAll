/*!
 * File HPMSTestLibraries.cpp
 */

#include <map>
#include <stdexcept>
#include <iostream>

template<typename T1, typename T2>
T1 FindClosestKey(const std::map<T1, T2>& data, T1 key);

int main()
{
    std::map<float, std::string> map;
    map.insert({0.025, "A"});
    map.insert({0.035, "B"});
    map.insert({0.037, "C"});
    map.insert({0.045, "D"});
    map.insert({0.0455, "E"});
    map.insert({0.049, "F"});
    map.insert({0.065, "G"});
    map.insert({0.067, "H"});
    map.insert({0.068, "I"});

    std::cout << map[FindClosestKey(map, 1.0f)] << std::endl;

}

template<typename T1, typename T2>
T1 FindClosestKey(const std::map<T1, T2>& data, T1 key)
{
    if (data.empty())
    {
        throw std::out_of_range("Received empty map.");
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