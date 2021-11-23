/*!
 * File HPMSUtils.h
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
#include <common/HPMSDefs.h>
#include <thirdparty/TPVariadicTable.h>
#include <cassert>
#include <iostream>
#include <cstdio>
#include <ctime>

#define HPMS_ASSERT(check, msg) assert(check)
#define LOG_ERROR(msg) hpms::ErrorHandler(__FILE__, __LINE__, msg)
#define LOG_WARN(msg) hpms::MsgHandler("HPMS-WARN ", msg)
#define LOG_INFO(msg) hpms::MsgHandler("HPMS-INFO ", msg)
#define LOG_RAW(msg) hpms::MsgHandler(msg)
#define LOG_INTERFACE(msg) hpms::MsgHandlerInterface(msg)

#ifndef NDEBUG
#define HPMS_DEBUG
#endif

#ifdef HPMS_DEBUG
#define LOG_DEBUG(msg) hpms::MsgHandler("HPMS-DEBUG", msg)
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

    struct LogBuffer
    {
        std::ofstream appHpms;
        bool opened{false};

        static LogBuffer& Instance();
        void Open();
        void Close();
        void Print(const std::stringstream& ss);
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

   

    inline void MsgHandler(const char* message)
    {
        std::stringstream ss;
        ss << message << std::endl;
        LogBuffer::Instance().Print(ss);
    }

    inline void MsgHandlerInterface(const char* message)
    {
        MsgHandler(message);
    }

    inline void ErrorHandler(const char* file, int line, const char* message)
    {
        std::stringstream ss;
        ss << "[HPMS-ERROR] - File " << file << ", at line " << std::to_string(line) << ": " << message;
        MsgHandler(ss.str().c_str());
        exit(-1);
    }

    inline void MsgHandler(const char* desc, const char* message)
    {
        std::stringstream ss;
        ss << "[" << desc << "] - " << message;
        MsgHandler(ss.str().c_str());
    }

    template<typename T, typename... ARGS>
    inline T* SafeNew(ARGS... args)
    {
        T* obj = new T(args...);
#ifdef HPMS_DEBUG

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
#ifdef HPMS_DEBUG
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

        if (ptr)
        {
#ifdef HPMS_DEBUG

        std::string name = ptr->Name();
        AllocCounter::Instance().allocMap[name]--;

#endif

            delete ptr;
            ptr = nullptr;
        }

    }


    template<typename T>
    inline void SafeDeleteArray(T*& ptr)
    {

#ifdef HPMS_DEBUG
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

    inline void MemoryDump()
    {

        VariadicTable<std::string, int> vt({ "OBJECT", "PENDING ALLOCATIONS" });

        std::ofstream dump;
        remove(HPMS_MEMORY_DUMP_FILE);
        dump.open(HPMS_MEMORY_DUMP_FILE);
        dump << "### MEMORY DUMP REPORT ###" << std::endl << std::endl;
        int leaks = 0;
        for (const auto& pair : hpms::AllocCounter::Instance().allocMap)
        {
            vt.addRow(pair.first, pair.second);
            leaks += pair.second;
        }
        vt.setTotal("TOTAL", leaks);
        
        if (leaks == 0)
        {
            dump << "OK, no potential memory leaks detected!" << std::endl;
        }
        else if (leaks > 0)
        {
            dump << "WARNING, potential memory leaks detected! " << leaks << " allocations not set free." << std::endl;
        }
        else
        {
            dump << "WARNING, unnecessary memory dealloc detected! " << -leaks << " useless de-allocations." << std::endl;
        }
        dump << "See details below..." << std::endl << std::endl;
        vt.print(dump);
        dump.close();
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

    bool IsNumber(const std::string& s);

    std::string ReplaceAll(const std::string& source, const std::string& from, const std::string& to);


    inline std::string GetFilenameExtension(const std::string& filename)
    {
        std::string::size_type idx;
        std::string extension("");

        idx = filename.rfind('.');

        if (idx != std::string::npos)
        {
            extension = filename.substr(idx + 1);
        }

        return extension;
    }

    void ProcessFileLines(const std::string& fileName, const std::function<void(const std::string&)>& callback);

    std::string ReadFile(const std::string& fileName);

    bool FileExists(const std::string& fileName);
    
    inline void WriteLinesToFile(const std::string& outputFile, const std::vector<std::string>& lines)
    {
        if (lines.empty())
        {
            return;
        }
        std::ofstream ostream(outputFile);
        for (auto& line : lines)
        {
            ostream << line << std::endl;
        }
        ostream.close();
    }

    void RandomString(char* s, int len);

    std::vector<std::string> Split(const std::string& stringToSplit, const std::string& reg);

    std::string GetFileName(const std::string& s);


}

