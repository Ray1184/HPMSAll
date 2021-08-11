package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.ray1184.hpms.batch.HPMSParams;

import java.io.File;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T01_CreateStructure implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        boolean cleanup = params.isCleanup();
        if (!cleanup) {
            log.info("Keeping existing structure");
            return RET_CODE_OK;
        }
        String outputPath = params.getOutputPath();
        FileUtils.deleteQuietly(new File(outputPath));
        boolean createChk = new File(params.getOutputPath() + File.separator + "resources/backgrounds").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/fonts").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/masks").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/models").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/overlays").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/scripts").mkdirs();
        createChk &= new File(params.getOutputPath() + File.separator + "resources/walkmaps").mkdirs();

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
