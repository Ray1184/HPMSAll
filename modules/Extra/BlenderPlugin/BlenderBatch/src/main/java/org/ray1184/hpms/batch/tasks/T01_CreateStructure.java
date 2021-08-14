package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.ray1184.hpms.batch.HPMSParams;

import java.io.File;
import java.io.IOException;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T01_CreateStructure implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        String outputPath = params.getOutputPath();
        File flagFile = new File(outputPath + File.separator + ".hpmsproj");
        boolean cleanup = params.isCleanup() || !flagFile.exists();
        if (!cleanup) {
            log.info("Keeping existing structure");
            return RET_CODE_OK;
        }
        log.info("Creating new base structure");
        FileUtils.deleteQuietly(new File(outputPath));
        boolean createChk = new File(params.getOutputPath() + File.separator + "resources/backgrounds").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "fonts").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "masks").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "models").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "overlays").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "scripts").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources" + File.separator + "walkmaps").mkdirs();
        try {
            boolean flagFileCreated = flagFile.createNewFile();
            if (!flagFileCreated) {
                log.error("Impossible to create {}, please check output folder permission", flagFile.getAbsolutePath());
                createChk = false;
            }
        } catch (IOException e) {
            log.error(e.toString());
            createChk = false;
        }

        if (!createChk) {
            log.error("Error creating base structure");
            return RET_CODE_ERROR;
        }
        return RET_CODE_OK;
    }

    @Override
    public boolean enabled() {
        return true;
    }
}
