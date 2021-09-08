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
            // Base scene setup
            builder.dummy()//
                    .expr("lib = backend:get()").newLine()//
                    .expr("cam = lib.get_camera()").newLine()//
                    .expr("cam.near = ?", params.getIniParam(HPMSParams.IniParam.CAM_NEAR)).newLine()//
                    .expr("cam.far = ?", params.getIniParam(HPMSParams.IniParam.CAM_FAR)).newLine()//
                    .expr("cam.fovy = lib.to_radians(?)", params.getIniParam(HPMSParams.IniParam.CAM_FOVY)).newLine()//
                    .expr("light = lib.make_light(lib.vec3(0, 0, 0))").newLine()//
                    .expr("scn_mgr = scene_manager:new(scene.name, cam)").newLine();

            // View setup/activation callback
            SceneObject.filter(roomInfo, SceneObject.VIEW_ACTIVATOR).forEach(a -> SceneObject.filter(roomInfo, SceneObject.CAMERA).stream()//
                    .filter(c -> a.getEvents().stream().anyMatch(e -> e.getParams().contains(c.getName())))//
                    .forEach(c -> builder.dummy()//
                            .expr("back_? = lib.make_background('?')", c.getName().toLowerCase(), roomInfo.getName() + "/" + c.getName() + ".png").newLine()
                            .expr("scn_mgr:sample_view_by_callback(function() return sector.id == '?' end, back_?, lib.vec3(?, ?, ?), lib.quat(?, ?, ?, ?))",
                                    a.getName(), c.getName().toLowerCase(), c.getPosition().getX(), c.getPosition().getY(), c.getPosition().getZ(),
                                    c.getRotation().getW(), c.getRotation().getX(), c.getRotation().getY(), c.getRotation().getZ()).newLine()));

            // Entities setup
            SceneObject.filter(roomInfo, SceneObject.ENTITY_DESCRIPTORS).forEach(t -> {

            });

            // Triggers setup
            SceneObject.filter(roomInfo, SceneObject.TRIGGER_POS).forEach(t -> {
                SceneDataResponse.RoomInfo.ObjectInfo.EventInfo event = t.getEvents().get(0);
                String entity = SceneObject.getParam(event, 0);
                Double tolerance = t.getEvents().size() > 1 ? Double.parseDouble(SceneObject.getParam(event, 1)) : 0.0d;
                builder.dummy()//
                        .expr("trigger_on_position(?, lib.vec3(?, ?, ?), ?, ?, function() trigger_?() end)", t.getName().toLowerCase(), t.getPosition().getX(), t.getPosition().getY(), t.getPosition().getZ(),
                                entity, tolerance, t.getName().toLowerCase());
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