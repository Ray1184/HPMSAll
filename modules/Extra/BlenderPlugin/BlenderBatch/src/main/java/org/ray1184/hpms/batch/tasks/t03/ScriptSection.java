package org.ray1184.hpms.batch.tasks.t03;

import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.utils.SceneObject;

public enum ScriptSection {
        SETUP_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.dummy()//
                        .expr("lib = backend:get()").newLine()//
                        .expr("cam = lib.get_camera()").newLine()//
                        .expr("cam.near = ?", params.getIniParam(HPMSParams.IniParam.CAM_NEAR)).newLine()//
                        .expr("cam.far = ?", params.getIniParam(HPMSParams.IniParam.CAM_FAR)).newLine()//
                        .expr("cam.fovy = lib.to_radians(?)", params.getIniParam(HPMSParams.IniParam.CAM_FOVY)).newLine()//
                        .expr("light = lib.make_light(lib.vec3(0, 0, 0))").newLine()//
                        .expr("scn_mgr = scene_manager:new(scene.name, cam)").newLine();
                SceneObject.filter(roomInfo, SceneObject.VIEW_ACTIVATOR).forEach(a -> {
                    SceneObject.filter(roomInfo, SceneObject.CAMERA).stream()//
                            .filter(c -> a.getEvents().stream().anyMatch(e -> e.getParams().contains(c.getName())))//
                            .forEach(c -> builder.dummy()//
                                    .expr("back_? = lib.make_background('?')", c.getName().toLowerCase(), roomInfo.getName() + "/" + c.getName() + ".png").newLine()
                                    .expr("scn_mgr:sample_view_by_callback(function() return sector.id == '?' end, back_?, lib.vec3(?, ?, ?), lib.quat(?, ?, ?, ?))",
                                            a.getName(), c.getName().toLowerCase(), c.getPosition().getX(), c.getPosition().getY(), c.getPosition().getZ(),
                                            c.getRotation().getW(), c.getRotation().getX(), c.getRotation().getY(), c.getRotation().getZ()).newLine());
                });

                return builder.build();
            }

        },
        SETUP_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return null;
            }
        },
        INPUT_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return null;
            }
        },
        INPUT_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return null;
            }
        },
        UPDATE_PRE {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                return null;
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

                return null;
            }
        },
        CLEANUP_POST {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder(name());
                builder.expr("lib.delete(light)").newLine();

                SceneObject.filter(roomInfo, SceneObject.VIEW_ACTIVATOR).forEach(a -> SceneObject.filter(roomInfo, SceneObject.CAMERA).stream().filter(c -> a.getEvents().stream().anyMatch(e -> e.getParams().contains(c.getName()))).forEach(c -> {
                    builder.expr("lib.delete(back_?)", c.getName().toLowerCase()).newLine();
                }));
                return builder.build();
            }
        };

        public abstract LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo);
    }