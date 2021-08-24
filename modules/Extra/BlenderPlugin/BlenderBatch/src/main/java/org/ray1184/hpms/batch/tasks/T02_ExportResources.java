package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T02_ExportResources implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        log.debug("Retrieving scene data from {}", params.getBlendFilePath());
        SceneDataResponse sceneInfo = (SceneDataResponse) execCachedCommand(params, HPMSCommands.SCENE_DATA);
        if (sceneInfo.getReturnCode() != RET_CODE_OK) {
            return RET_CODE_ERROR;
        }
        sceneInfo.getRooms().stream()//
                .filter(r -> CollectionUtils.isEmpty(params.getFilterRooms()) || params.getFilterRooms().contains(r.getName()))//
                .forEach(r -> {
//                    exportEntities(params, r.getEntities());
//                    exportSectors(params, r.getSectors());
//                    exportCollisionData(params, r.getCollisionData());
//                    exportDepthData(params, r.getDepthData());
                });
        return RET_CODE_OK;
    }


    @Override
    public boolean enabled() {
        return false;
    }
}
