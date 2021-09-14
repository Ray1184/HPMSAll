package org.ray1184.hpms.batch.tasks.scene;

import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;

public enum ScriptSection {
    SETUP_PRE {
        @Override
        public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

            LuaStatementBuilder builder = new LuaStatementBuilder(name());
            // Base scene setup
            builder.expr("-- Base scene setup").newLine()//
                    .expr("lib = backend:get()").newLine()//
                    .expr("cam = lib.get_camera()").newLine()//
                    .expr("cam.near = ?", params.getIniParam(HPMSParams.IniParam.CAM_NEAR)).newLine()//
                    .expr("cam.far = ?", params.getIniParam(HPMSParams.IniParam.CAM_FAR)).newLine()//
                    .expr("cam.fovy = lib.to_radians(?)", params.getIniParam(HPMSParams.IniParam.CAM_FOVY)).newLine()//
                    .expr("light = lib.make_light(lib.vec3(0, 0, 0))").newLine()//
                    .expr("scn_mgr = scene_manager:new(scene.name, cam)").newLine().newLine();

            SceneObject.sortedValues(true).forEach(so -> so.getBehavior().handleSetupPre(builder, roomInfo));
            SceneObject.sortedValues(true).forEach(so -> so.getBehavior().handleSetupPost(builder, roomInfo));

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
            SceneObject.sortedValues(true).forEach(so -> so.getBehavior().handleUpdatePre(builder, roomInfo));
            builder.expr("scn_mgr:update()").newLine().newLine();
            SceneObject.sortedValues(true).forEach(so -> so.getBehavior().handleUpdatePost(builder, roomInfo));
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

            SceneObject.sortedValues(false).forEach(so -> so.getBehavior().handleCleanupPost(builder, roomInfo));

            // Base scene cleanup
            builder.expr("-- Base scene delete").newLine()
                    .expr("lib.delete_light(light)").newLine();

            return builder.build();
        }
    };

    public abstract LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo);
}