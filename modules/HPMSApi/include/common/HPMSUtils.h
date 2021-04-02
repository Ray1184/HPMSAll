/*!
 * File Utils.h
 */

#pragma once

#include <cstring>
#include <string>
#include <regex>
#include <sstream>
#include <cstdio>
#include <fstream>
#include <unordered_map>
#include <functional>
#include <common/HPMSNames.h>
#include <cassert>
#include <stringapiset.h>

#define HPMS_ASSERT(check, msg) assert(check)
#define LOG_ERROR(msg) hpms::ErrorHandler(__FILE__, __LINE__, msg)
#define LOG_WARN(msg) hpms::MsgHandler("WARN ", msg)
#define LOG_INFO(msg) hpms::MsgHandler("INFO ", msg)
#define LOG_RAW(msg) hpms::MsgHandler(msg)

#if !defined(_DEBUG) && !defined(NDEBUG)
#define LOG_DEBUG(msg) hpms::MsgHandler("DEBUG", msg)
#else
#define LOG_DEBUG(msg)
#endif

#define ARRAY_SIZE(arr) sizeof(arr) / sizeof(arr[0])

namespace hpms
{
    // Some useful utilities for safe memory, I/O management etc...

    struct AllocCounter
    {
        std::unordered_map<std::string, int> allocMap;

        static AllocCounter& Instance();
    };


    struct ConfigManager
    {
        std::unordered_map<std::string, std::string> stringValues;
        std::unordered_map<std::string, bool> boolValues;
        std::unordered_map<std::string, float> numberValues;
        bool loaded;

        void Load(const std::string& path);

        static ConfigManager& Instance();
    };


    inline void ErrorHandler(const char* file, int line, const char* message)
    {
        printf("[ERROR] - File %s, at line %d: %s", file, line, message);
        exit(-1);
    }

    inline void MsgHandler(const char* desc, const char* message)
    {
        printf("[%s] - %s\n", desc, message);
    }

    inline void MsgHandler(const char* message)
    {
        printf("%s\n", message);
    }


    template<typename T, typename... ARGS>
    inline T* SafeNew(ARGS... args)
    {
        T* obj = new T(args...);
#if !defined(_DEBUG) && !defined(NDEBUG)

        std::string name = obj->Name();
        if (AllocCounter::Instance().allocMap.find(name) == AllocCounter::Instance().allocMap.end())
        {
            AllocCounter::Instance().allocMap[name] = 0;
        }
        AllocCounter::Instance().allocMap[name]++;


#endif
        return obj;
    }

    template<typename T>
    inline T* SafeNewArray(size_t size)
    {
        T* obj = new T[size];
#if !defined(_DEBUG) && !defined(NDEBUG)
        std::string name = "ARRAY";
        if (AllocCounter::Instance().allocMap.find(name) == AllocCounter::Instance().allocMap.end())
        {
            AllocCounter::Instance().allocMap[name] = 0;
        }
        AllocCounter::Instance().allocMap[name]++;
#endif
        return obj;
    }


    template<typename T>
    inline void SafeDelete(T*& ptr)
    {


#if !defined(_DEBUG) && !defined(NDEBUG)

        std::string name = ptr->Name();
        AllocCounter::Instance().allocMap[name]--;

#endif
        if (ptr)
        {
            delete ptr;
            ptr = nullptr;
        }

    }


    template<typename T>
    inline void SafeDeleteArray(T*& ptr)
    {

#if !defined(_DEBUG) && !defined(NDEBUG)
        std::string name = "ARRAY";
        AllocCounter::Instance().allocMap[name]--;
#endif
        delete[] ptr;
        ptr = nullptr;

    }


    template<typename T, typename... ARGS>
    inline T* SafeNewRaw(ARGS... args)
    {
        T* ptr = new T(args...);
        return ptr;
    }

    template<typename T, typename... ARGS>
    inline T* SafeNewArrayRaw(size_t size)
    {
        T* obj = new T[size];
        return obj;
    }

    template<typename T>
    inline void SafeDeleteRaw(T*& ptr)
    {
        if (ptr)
        {
            delete ptr;
            ptr = nullptr;
        }
    }

    template<typename T>
    inline void SafeDeleteArrayRaw(T*& ptr)
    {
        delete[] ptr;
        ptr = nullptr;
    }

    inline std::string Trim(const std::string& s)
    {
        auto wsfront = std::find_if_not(s.begin(), s.end(), [](int c)
        {
            return std::isspace(c);
        });
        auto wsback = std::find_if_not(s.rbegin(), s.rend(), [](int c)
        {
            return std::isspace(c);
        }).base();
        return (wsback <= wsfront ? std::string() : std::string(wsfront, wsback));
    }

    inline std::string UpperCase(std::string s)
    {
        for (char& l : s)
        {
            l = toupper(l);
        }
        return s;
    }

    inline std::string LowerCase(std::string s)
    {
        for (char& l : s)
        {
            l = tolower(l);
        }
        return s;
    }

    inline std::string GetConfS(const std::string& key, std::string defaultValue)
    {
        if (ConfigManager::Instance().stringValues.find(key) == ConfigManager::Instance().stringValues.end())
        {
            return defaultValue;
        }
        return ConfigManager::Instance().stringValues[key];
    }

    inline bool GetConfB(const std::string& key, bool defaultValue)
    {
        if (ConfigManager::Instance().boolValues.find(key) == ConfigManager::Instance().boolValues.end())
        {
            return defaultValue;
        }
        return ConfigManager::Instance().boolValues[key];
    }


    inline float GetConfF(const std::string& key, float defaultValue)
    {
        if (ConfigManager::Instance().numberValues.find(key) == ConfigManager::Instance().numberValues.end())
        {
            return defaultValue;
        }
        return ConfigManager::Instance().numberValues[key];
    }

    inline int GetConfI(const std::string& key, int defaultValue)
    {
        return (int) GetConfF(key, (float) defaultValue);
    }

    inline bool IsNumber(const std::string& s)
    {
        std::size_t charPost(0);

        charPost = s.find_first_not_of(' ');
        if (charPost == s.size())
        { return false; }

        if (s[charPost] == '+' || s[charPost] == '-')
        { ++charPost; }

        int nNm, nPt;
        for (nNm = 0, nPt = 0; std::isdigit(s[charPost]) || s[charPost] == '.'; ++charPost)
        {
            s[charPost] == '.' ? ++nPt : ++nNm;
        }
        if (nPt > 1 || nNm < 1)
        {
            return false;
        }


        while (s[charPost] == ' ')
        {
            ++charPost;
        }

        return charPost == s.size();
    }

    inline std::string ReplaceAll(const std::string& source, const std::string& from, const std::string& to)
    {
        std::string newString;
        newString.reserve(source.length());

        std::string::size_type lastPos = 0;
        std::string::size_type findPos;

        while (std::string::npos != (findPos = source.find(from, lastPos)))
        {
            newString.append(source, lastPos, findPos - lastPos);
            newString += to;
            lastPos = findPos + from.length();
        }

        newString += source.substr(lastPos);

        return newString;
    }

    inline const wchar_t* ConvertToUTF16(const char* pStr)
    {
        static wchar_t wszBuf[1024];
        MultiByteToWideChar(CP_OEMCP, 0, pStr, -1, wszBuf, sizeof(wszBuf));
        return wszBuf;
    }

    void ProcessFileLines(const std::string& fileName, std::function<void(const std::string&)> callback);

    std::string ReadFile(const std::string& fileName);

    void RandomString(char* s, int len);

    std::vector<std::string> Split(const std::string& stringToSplit, const std::string& reg);

    std::string GetFileName(const std::string& s);


}

