package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.HPMSProcess;
import org.ray1184.hpms.batch.commands.blend.BlenderProcess;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.*;
import org.ray1184.hpms.batch.tasks.t03.ScriptSection;
import org.ray1184.hpms.batch.tasks.utils.FileSystem;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.ray1184.hpms.batch.HPMSParams.IniParam.DEPENDENCIES;

@Slf4j
public class T03_GenerateScripts implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        SceneDataResponse sceneData = (SceneDataResponse) execCachedCommand(params, HPMSCommands.SCENE_DATA);
        if (sceneData.getReturnCode() == BlenderProcess.RETURN_ERROR) {
            return HPMSProcess.RET_CODE_ERROR;
        }
        FinalObjectWrapper<Integer> retWrapper = new FinalObjectWrapper<>();
        retWrapper.setObject(HPMSProcess.RET_CODE_OK);
        sceneData.getRooms().forEach(roomInfo -> {
            try {
                executeRoom(params, roomInfo);
            } catch (IOException e) {
                log.error(e.toString());
                retWrapper.setObject(HPMSProcess.RET_CODE_ERROR);
            }
        });
        return retWrapper.getObject();
    }

    private void executeRoom(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) throws IOException {
        String roomScriptPath = FileSystem.getInstance().toPath(FileSystem.Asset.SCRIPTS) + File.separator + roomInfo.getName() + ".lua";
        String version = String.valueOf(params.getIniParam(HPMSParams.IniParam.SCRIPTS_VERSION));
        File roomScriptFile = new File(roomScriptPath);
        LuaScriptGenerator generator = new LuaScriptGenerator();
        LuaScript roomScript;
        if (roomScriptFile.exists()) {
            log.info("Recovering room script {}", roomInfo.getName() + ".lua");
            String roomScriptContent = Files.readString(Paths.get(roomScriptFile.toURI()));
            roomScript = generator.restoreWithUserData(roomInfo.getName(), version, roomScriptContent);
        } else {
            log.info("Creating room script {}", roomInfo.getName() + ".lua");
            roomScript = generator.generateTemplate(roomInfo.getName(), version);
        }
        fillScript(params, roomInfo, roomScript);
        String result = roomScript.getScript();
        Files.writeString(Paths.get(roomScriptFile.toURI()), result);
    }

    private void fillScript(HPMSParams params, SceneDataResponse.RoomInfo roomInfo, LuaScript roomScript) {
        LuaMacroSection depRef = roomScript.getSection("dependencies");
        getDependencies(params).forEach(s -> {
            depRef.addStatement(new LuaStatement(s));
        });

        LuaMacroSection sceneRef = roomScript.getSection("scene");
        sceneRef.getCallback("setup").addStatementPre(ScriptSection.SETUP_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("setup").addStatementPost(ScriptSection.SETUP_POST.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("input").addStatementPre(ScriptSection.INPUT_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("input").addStatementPre(ScriptSection.INPUT_POST.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("update").addStatementPre(ScriptSection.UPDATE_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("update").addStatementPre(ScriptSection.UPDATE_POST.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("cleanup").addStatementPre(ScriptSection.CLEANUP_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("cleanup").addStatementPre(ScriptSection.CLEANUP_POST.getCustomStatement(params, roomInfo));
    }

    private List<String> getDependencies(HPMSParams params) {
        List<String> deps = new ArrayList<>();
        String[] includes = params.getIniParam(DEPENDENCIES).toString().split(",");
        Collections.addAll(deps, includes);
        return deps;
    }

    @Override
    public boolean enabled() {
        return true;
    }


    
}
