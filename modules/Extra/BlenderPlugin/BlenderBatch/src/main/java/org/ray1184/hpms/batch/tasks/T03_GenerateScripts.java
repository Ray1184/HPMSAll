package org.ray1184.hpms.batch.tasks;

import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.HPMSProcess;
import org.ray1184.hpms.batch.commands.blend.BlenderProcess;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.*;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Slf4j
public class T03_GenerateScripts implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        String scriptsPath = params.getOutputPath() + File.separator + "resources" + File.separator + "scripts";
        SceneDataResponse sceneData = (SceneDataResponse) HPMSCommands.SCENE_DATA.exec();
        if (sceneData.getReturnCode() == BlenderProcess.RETURN_ERROR) {
            return HPMSProcess.RET_CODE_ERROR;
        }
        FinalObjectWrapper<Integer> retWrapper = new FinalObjectWrapper<>();
        retWrapper.setObject(HPMSProcess.RET_CODE_OK);
        sceneData.getRooms().forEach(roomInfo -> {
            try {
                executeRoom(params, scriptsPath, roomInfo);
            } catch (IOException e) {
                log.error(e.toString());
                retWrapper.setObject(HPMSProcess.RET_CODE_ERROR);
            }
        });
        return retWrapper.getObject();
    }

    private void executeRoom(HPMSParams params, String scriptsPath, SceneDataResponse.RoomInfo roomInfo) throws IOException {
        String roomScriptPath = scriptsPath + File.separator + roomInfo.getName() + ".lua";
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
        LuaMacroSection sceneRef = roomScript.getSection("scene");
        sceneRef.getCallback("setup").addStatementPre(ScriptSections.SETUP_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("setup").addStatementPost(ScriptSections.SETUP_POST.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("input").addStatementPre(ScriptSections.INPUT_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("input").addStatementPre(ScriptSections.INPUT_POST.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("update").addStatementPre(ScriptSections.UPDATE_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("update").addStatementPre(ScriptSections.UPDATE_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("cleanup").addStatementPre(ScriptSections.CLEANUP_PRE.getCustomStatement(params, roomInfo));
        sceneRef.getCallback("cleanup").addStatementPre(ScriptSections.CLEANUP_PRE.getCustomStatement(params, roomInfo));
    }

    @Override
    public boolean enabled() {
        return true;
    }


    public enum ScriptSections {
        SETUP_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.dummy()//
                        .expr("lib = backend:get()").newLine().newLine()//
                        .expr("cam = lib.get_camera()").newLine()//
                        .expr("cam.near = ?", params.getIniParam(HPMSParams.IniParam.CAM_NEAR)).newLine()//
                        .expr("cam.far = ?", params.getIniParam(HPMSParams.IniParam.CAM_FAR)).newLine()//
                        .expr("cam.fovy = lib.to_radians(?)", params.getIniParam(HPMSParams.IniParam.CAM_FOVY)).newLine().newLine()//
                        .expr("light = lib.make_light(lib.vec3(0, 0, 0))").newLine().newLine()//
                        .expr("scn_mgr = scene_manager:new(scene.name, cam)").newLine().newLine().newLine();
                roomInfo.getSectors().forEach(s -> {
                    SceneDataResponse.RoomInfo.SectorInfo.CameraInfo camInfo = s.getActiveCamera();
                    builder.dummy()//
                            .expr("back_? = lib.make_background('?')", camInfo.getName(), roomInfo.getName() + File.separator + camInfo.getName() + ".png").newLine()
                            .expr("scn_mgr:sample_view_by_callback(function() return sector.id == '?' end, back_?, lib.vec3(?, ?, ?), lib.quat(?, ?, ?, ?))",
                                    s.getId(), roomInfo.getName(), camInfo.getPosition().getX(), camInfo.getPosition().getY(), camInfo.getPosition().getZ(),
                                    camInfo.getRotation().getW(), camInfo.getRotation().getX(), camInfo.getRotation().getY(), camInfo.getRotation().getZ()).newLine().newLine();

                });
                return builder.build();
            }

        },
        SETUP_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return new LuaStatementBuilder(name()).build();
            }
        },
        INPUT_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return new LuaStatementBuilder(name()).build();
            }
        },
        INPUT_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return new LuaStatementBuilder(name()).build();
            }
        },
        UPDATE_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.expr("scn_mgr:update()").newLine().newLine();
                return builder.build();
            }
        },
        UPDATE_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.expr("scn_mgr:update()").newLine().newLine();
                return builder.build();
            }

        },
        CLEANUP_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return new LuaStatementBuilder(name()).build();
            }
        },
        CLEANUP_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.expr("lib.delete(light)").newLine().newLine();
                roomInfo.getSectors().forEach(s -> {
                    SceneDataResponse.RoomInfo.SectorInfo.CameraInfo camInfo = s.getActiveCamera();
                    builder.expr("lib.delete(back_?)", camInfo.getName()).newLine();
                });
                return builder.build();
            }
        };

        public abstract LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo);
    }
}
