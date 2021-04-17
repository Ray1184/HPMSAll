/*!
 * File HPMSWalkmapImporterMain.cpp
 */

#include <string>
#include <iostream>
#include <pods/buffers.h>
#include <resource/HPMSWalkmap.h>
#include <tools/HPMSWalkmapImporter.h>

struct ProcessResult {
    int code;
    std::string message;
};


std::string GetOutputPath(const std::string& inputPath);

ProcessResult Serialize(const std::string& inputPath, const std::string& outputPath);

ProcessResult SerializeBatch(const std::string& basicString);


int main(int argc, char** argv)
{
    if (argc < 2)
    {
        LOG_ERROR("At least 1 argument required");
        LOG_ERROR(" -input\t\tWalkmap input data to convert.");
        LOG_ERROR(" -output\t\tWalkmap output binary data path. (Optional)");
        return -1;
    }

    std::string inputPath(argv[1]);
    std::string outputPath;

    if (argc < 3)
    {
        outputPath = GetOutputPath(inputPath);
    } else
    {
        outputPath = std::string(argv[2]);
    }

    std::stringstream ss;
    ss << "Input path: " << inputPath << std::endl;
    ss << "Output path: " << outputPath << std::endl;
    LOG_INFO(ss.str().c_str());

    std::string fileExtension = hpms::GetFilenameExtension(inputPath);

    ProcessResult ret;

    if (fileExtension == ".obj")
    {
        LOG_INFO("Processing input in STANDARD mode.");
        ret = Serialize(inputPath, outputPath);

    }
    else if (fileExtension == ".batch")
    {
        LOG_INFO("Processing input in BATCH mode.");
        if (argc >= 3)
        {
            LOG_WARN("Output path ignored in batch mode.");
            ret =  SerializeBatch(inputPath);
        }
    }

    if (ret.code == 0)
    {
        LOG_INFO(ret.message.c_str());
    } else {
        LOG_ERROR(ret.message.c_str());
    }
    return ret.code;
}

std::string GetOutputPath(const std::string& inputPath)
{
    size_t lastIndex = inputPath.find_last_of('.');
    if (lastIndex < 0)
    {
        LOG_ERROR("Invalid input file extension, required format is *.walkmap.obj");
    }
    std::string newName = inputPath.substr(0, lastIndex);
    return newName;
}

ProcessResult Serialize(const std::string& inputPath, const std::string& outputPath)
{
    hpms::WalkmapData* item = hpms::WalkmapImporter::LoadWalkmap(inputPath);
    pods::ResizableOutputBuffer out;
    pods::BinarySerializer<decltype(out)> serializer(out);
    if (serializer.save(*item) != pods::Error::NoError)
    {
        std::stringstream ss;
        ss << "Error serializing " << inputPath << std::endl;
        hpms::SafeDelete(item);
        return ProcessResult{-1, ss.str()};
    }

    std::ofstream outFile;
    outFile.open(outputPath, std::ios::out | std::ios::binary);


    if (outFile.is_open())
    {
        outFile.write(out.data(), out.size());
    }

    outFile.close();
    hpms::SafeDelete(item);
    return ProcessResult{0, "Serialization completed successfully."};
}

ProcessResult SerializeBatch(const std::string& inputPath)
{
    size_t errors = 0;
    size_t good = 0;
    size_t totals = 0;
    std::vector<std::string> inputFiles;
    std::vector<std::string> okFiles;
    std::vector<std::string> koFiles;
    auto process = [&inputFiles](const std::string& line)
    {
        std::vector<std::string> tokens = hpms::Split(line, "\\s+");
        if (line.empty())
        {
            return;
        }
        char type = line.at(0);
        switch (type)
        {
            case '#':
                break;
            default:
                inputFiles.push_back(line);
        }

    };
    hpms::ProcessFileLines(inputPath, process);
    for (auto& file : inputFiles)
    {
        auto result = Serialize(file, GetOutputPath(file));
        if (result.code == 0)
        {
            koFiles.push_back(file + ";" + result.message);
            errors++;
        } else {
            okFiles.push_back(file);
            good++;
        }
        totals++;
    }

    std::string outBaseFile = GetOutputPath(inputPath);
    hpms::WriteLinesToFile(outBaseFile + ".done", okFiles);
    hpms::WriteLinesToFile(outBaseFile + ".error", koFiles);
    std::stringstream ss;
    ss << "Converted " << good << "/" << totals << " files, " << errors << " error/s." << std::endl;
    return ProcessResult{errors == 0 ? 0 : -1, ss.str()};
}
