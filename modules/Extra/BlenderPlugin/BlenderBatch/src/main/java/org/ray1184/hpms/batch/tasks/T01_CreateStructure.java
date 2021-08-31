package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.tasks.utils.FileSystem;

import java.io.File;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T01_CreateStructure implements HPMSTask {

	@Override
	public Integer execute(HPMSParams params) {
		String outputPath = params.getOutputPath();
		FileSystem fs = FileSystem.getInstance();
		fs.init(outputPath);
		boolean cleanup = params.isCleanup() || !fs.flagExists();
		if (!cleanup) {
			log.info("Keeping existing structure");
			return RET_CODE_OK;
		}
		log.info("Creating new base structure");
		FileUtils.deleteQuietly(new File(outputPath));
		boolean createChk = true;
		for (FileSystem.Asset asset : FileSystem.Asset.values()) {
			createChk &= fs.createFolder(asset);
		}
		if (!fs.createFlagFile()) {
			log.error("Impossible to create .hpmsproj flag in path {}, please check output folder permission", fs.getRootPath());
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
