/*!
 * File HPMSUtils.cpp
 */

#include <common/HPMSUtils.h>

void hpms::ProcessFileLines(const std::string& fileName, const std::function<void(const std::string&)>& callback)
{
    std::ifstream file(fileName);
    if (file)
    {
        for (std::string line; getline(file, line);)
        {
            callback(hpms::Trim(line));
        }
    } else
    {
        std::stringstream ss;
        ss << "Cannot open/read file with name " << fileName;
        LOG_ERROR(ss.str().c_str());
    }
}

std::string hpms::ReadFile(const std::string& fileName)
{

    std::ifstream file(fileName);

    if (file)
    {
        std::stringstream buffer;
        buffer << file.rdbuf();        
        return buffer.str();
    } else
    {
        std::stringstream ss;
        ss << "Cannot open/read file with name " << fileName;
        LOG_ERROR(ss.str().c_str());
    }
    file.close();
    return "";
}

bool hpms::FileExists(const std::string& fileName)
{
    std::ifstream file(fileName);   
    bool exists = file.good();
    file.close();
    return exists;
}


std::vector<std::string> hpms::Split(const std::string& stringToSplit, const std::string& reg)
{
    std::vector<std::string> elems;

    std::regex rgx(reg);

    std::sregex_token_iterator iter(stringToSplit.begin(), stringToSplit.end(), rgx, -1);
    std::sregex_token_iterator end;

    while (iter != end)
    {
        elems.push_back(*iter);
        ++iter;
    }

    return elems;
}

std::string hpms::GetFileName(const std::string& s)
{

    char sep = '/';
#ifdef _WIN32
    sep = '\\';
#endif
    size_t i = s.rfind(sep, s.length());
    if (i != std::string::npos)
    {
        std::string filename = s.substr(i + 1, s.length() - i);
        size_t lastindex = filename.find_last_of(".");
        std::string rawname = filename.substr(0, lastindex);
        return (rawname);
    }

    return ("");
}

void hpms::RandomString(char* s, int len)
{
    static const char alphanum[] =
            "0123456789"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < len; ++i)
    {
        s[i] = alphanum[rand() % (sizeof(alphanum) - 1)];
    }

    s[len] = 0;
}

std::string hpms::ReplaceAll(const std::string& source, const std::string& from, const std::string& to)
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

bool hpms::IsNumber(const std::string& s)
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


void hpms::ConfigManager::Load(const std::string& path)
{
    if (loaded)
    {
        return;
    }
    loaded = true;
    auto process = [this](const std::string& line)
    {
        std::string clearString = hpms::Trim(line);
        if (clearString.length() == 0 || clearString.at(0) == '#')
        {
            return;
        }
        auto tokens = Split(clearString, "=");
        if (tokens.size() != 2)
        {
            return;
        }
        std::string key = hpms::Trim(tokens[0]);
        std::string val = hpms::Trim(tokens[1]);

        if ("TRUE" == UpperCase(val))
        {
            boolValues.insert({key, true});
        } else if ("FALSE" == UpperCase(val))
        {
            boolValues.insert({key, false});
        } else if (IsNumber(val))
        {
            numberValues.insert({key, std::stof(val)});
        } else
        {
            stringValues.insert({key, val});
        }

    };
    hpms::ProcessFileLines(path, process);

}

void hpms::LogBuffer::Open()
{
    if (!opened)
    {
        opened = true;
        remove(HPMS_CORE_LOG_FILE);
        appHpms.open(HPMS_CORE_LOG_FILE, std::ios_base::app);
    }
}

void hpms::LogBuffer::Close()
{
    if (opened)
    {
        opened = false;
        appHpms.close();
    }
}

void hpms::LogBuffer::Print(const std::stringstream& ss)
{
    
    std::time_t rawtime;
    std::tm* timeinfo;
    char buffer[80];

    std::time(&rawtime);
    timeinfo = std::localtime(&rawtime);

    std::strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    std::puts(buffer);    

    appHpms << buffer << " | " << ss.str();
   
}

hpms::LogBuffer& hpms::LogBuffer::Instance()
{
    static LogBuffer inst;
    return inst;
}

hpms::ConfigManager& hpms::ConfigManager::Instance()
{
    static ConfigManager inst;
    inst.Load(HPMS_CONFIG_FILE);
    return inst;
}

hpms::AllocCounter& hpms::AllocCounter::Instance()
{
    static AllocCounter inst;
    return inst;
}
