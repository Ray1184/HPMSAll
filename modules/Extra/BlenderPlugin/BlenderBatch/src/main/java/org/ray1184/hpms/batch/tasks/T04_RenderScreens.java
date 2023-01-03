package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.HPMSProcess;
import org.ray1184.hpms.batch.commands.CommandResponse;
import org.ray1184.hpms.batch.commands.blend.BlenderProcess;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;
import org.ray1184.hpms.batch.commands.impl.res.ExportResponse;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;
import org.ray1184.hpms.batch.tasks.utils.FileSystem;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T04_RenderScreens implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        if (!params.isRender()) {
            log.info("Skip render phase");
            return HPMSProcess.RET_CODE_OK;
        }
        SceneDataResponse sceneInfo = (SceneDataResponse) execCachedCommand(params, HPMSCommands.SCENE_DATA);
        if (sceneInfo.getReturnCode() == BlenderProcess.RETURN_ERROR) {
            return HPMSProcess.RET_CODE_ERROR;
        }
        sceneInfo.getRooms().stream()//
                .filter(r -> CollectionUtils.isEmpty(params.getFilterRooms()) || params.getFilterRooms().contains(r.getName()))//
                .forEach(r -> {
                    Integer res = RET_CODE_OK;
                    params.getSessionParams().put("CURRENT_ROOM", r.getName());
                    res += render(params, SceneObject.filter(r, SceneObject.CAMERA));
                    if (res != RET_CODE_OK) {
                        throw new RuntimeException("Something wrong rendering cam for room " + r.getName());
                    }
                });

        return HPMSProcess.RET_CODE_OK;
    }

    private Integer render(HPMSParams params, List<SceneDataResponse.RoomInfo.ObjectInfo> objs) {
        Map<String, Object> args = new HashMap<>();
        String roomName = (String) params.getSessionParams().get("CURRENT_ROOM");
        String outputPath = FileSystem.getInstance().toPythonPath(FileSystem.Asset.BACKGROUNDS.appendFolder(roomName));
        args.put("OUTPUT_PATH", outputPath);
        args.put("CAMS_TO_RENDER", StringUtils.join(objs.stream().map(SceneDataResponse.RoomInfo.ObjectInfo::getName).collect(Collectors.toList()), ","));
        return execCachedCommand(params, HPMSCommands.RENDERING, args).getReturnCode();
    }

    @Override
    public boolean enabled() {
        return true;
    }
}
