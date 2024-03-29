package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;
import org.ray1184.hpms.batch.commands.impl.res.ExportResponse;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;
import org.ray1184.hpms.batch.tasks.utils.FileSystem;
import org.ray1184.hpms.batch.tasks.utils.NativeConverter;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_ERROR;
import static org.ray1184.hpms.batch.HPMSProcess.RET_CODE_OK;

@Slf4j
public class T02_ExportResources implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        log.debug("Retrieving scene data from {}", params.getBlendFilePath());
        execCachedCommand(params, HPMSCommands.CLEAR_LOG);
        SceneDataResponse sceneInfo = (SceneDataResponse) execCachedCommand(params, HPMSCommands.SCENE_DATA);
        if (sceneInfo.getReturnCode() != RET_CODE_OK) {
            return RET_CODE_ERROR;
        }
        sceneInfo.getRooms().stream()//
                .filter(r -> CollectionUtils.isEmpty(params.getFilterRooms()) || params.getFilterRooms().contains(r.getName()))//
                .forEach(r -> {
                    Integer res = RET_CODE_OK;
                    params.getSessionParams().put("CURRENT_ROOM", r.getName());
                    res += exportSectors(params, SceneObject.filter(r, SceneObject.PERIMETER));
                    res += exportEntities(params, SceneObject.filter(r, SceneObject.ENTITY));
                    res += exportCollisionData(params, SceneObject.filter(r, SceneObject.COLLISION_DATA));
                    res += exportDepthData(params, SceneObject.filter(r, SceneObject.DEPTH_DATA));
                    if (res != RET_CODE_OK) {
                        throw new RuntimeException("Something wrong exporting data for room " + r.getName());
                    }
                });
        return RET_CODE_OK;
    }

    private Integer exportDepthData(HPMSParams params, List<SceneDataResponse.RoomInfo.ObjectInfo> objs) {
        Map<String, Object> args = new HashMap<>();
        String outputPath = FileSystem.getInstance().toPythonPath(FileSystem.Asset.MASKS);
        args.put("OUTPUT_PATH", outputPath);
        args.put("OBJECTS", StringUtils.join(objs.stream().map(SceneDataResponse.RoomInfo.ObjectInfo::getName).collect(Collectors.toList()), ","));
        ExportResponse exportResponse = (ExportResponse) execCachedCommand(params, HPMSCommands.EXPORT_OGRE, args);
        if (exportResponse.getReturnCode() != RET_CODE_OK) {
            return RET_CODE_ERROR;
        }
        FinalObjectWrapper<Boolean> resWrapper = new FinalObjectWrapper<>();
        resWrapper.setObject(true);
        exportResponse.getOutputs().forEach(o -> {
            boolean converted = NativeConverter.OGRE_MESH.convert(params, o);
            resWrapper.setObject(resWrapper.getObject() && converted);
        });
        return resWrapper.getObject() ? RET_CODE_OK : RET_CODE_ERROR;
    }

    private Integer exportCollisionData(HPMSParams params, List<SceneDataResponse.RoomInfo.ObjectInfo> objs) {
        return RET_CODE_OK;
    }

    private Integer exportSectors(HPMSParams params, List<SceneDataResponse.RoomInfo.ObjectInfo> objs) {
        Map<String, Object> args = new HashMap<>();
        String roomName = (String) params.getSessionParams().get("CURRENT_ROOM");
        String outputPath = FileSystem.getInstance().toPythonPath(FileSystem.Asset.WALKMAPS);
        args.put("OUTPUT_PATH", outputPath);
        args.put("ITEMS_TO_AGGREGATE", StringUtils.join(objs.stream().map(SceneDataResponse.RoomInfo.ObjectInfo::getName).collect(Collectors.toList()), ","));
        args.put("FILE_NAME", roomName + ".obj.walkmap");
        args.put("COLLECTION_NAME", roomName);
        ExportResponse exportResponse = (ExportResponse) execCachedCommand(params, HPMSCommands.EXPORT_AGGR_OBJ, args);
        if (exportResponse.getReturnCode() != RET_CODE_OK) {
            return RET_CODE_ERROR;
        }
        FinalObjectWrapper<Boolean> resWrapper = new FinalObjectWrapper<>();
        resWrapper.setObject(true);
        exportResponse.getOutputs().forEach(o -> {
            boolean converted = NativeConverter.WALKMAP.convert(params, o);
            resWrapper.setObject(resWrapper.getObject() && converted);
        });
        return resWrapper.getObject() ? RET_CODE_OK : RET_CODE_ERROR;
    }

    private Integer exportEntities(HPMSParams params, List<SceneDataResponse.RoomInfo.ObjectInfo> objs) {
        Map<String, Object> args = new HashMap<>();
        String outputPath = FileSystem.getInstance().toPythonPath(FileSystem.Asset.MODELS);
        args.put("OUTPUT_PATH", outputPath);
        args.put("OBJECTS", StringUtils.join(objs.stream().map(SceneDataResponse.RoomInfo.ObjectInfo::getName).collect(Collectors.toList()), ","));
        args.put("EXPORT_ANIMATIONS", true);
        args.put("EXPORT_MATERIALS", true);
        ExportResponse exportResponse = (ExportResponse) execCachedCommand(params, HPMSCommands.EXPORT_OGRE, args);
        if (exportResponse.getReturnCode() != RET_CODE_OK) {
            return RET_CODE_ERROR;
        }
        FinalObjectWrapper<Boolean> resWrapper = new FinalObjectWrapper<>();
        resWrapper.setObject(true);
        exportResponse.getOutputs().forEach(o -> {
            boolean converted = NativeConverter.OGRE_MESH.convert(params, o);
            resWrapper.setObject(resWrapper.getObject() && converted);
        });
        return resWrapper.getObject() ? RET_CODE_OK : RET_CODE_ERROR;
    }

    @Override
    public boolean enabled() {
        return true;
    }
}
