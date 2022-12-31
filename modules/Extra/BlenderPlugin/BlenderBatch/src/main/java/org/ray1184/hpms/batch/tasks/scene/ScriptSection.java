package org.ray1184.hpms.batch.tasks.scene;

import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;

import java.util.Objects;

public enum ScriptSection {
    SETUP_PRE {
        @Override
        public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

            LuaStatementBuilder builder = new LuaStatementBuilder(name());
            // Base scene setup
            builder.expr("-- Base scene setup").newLine()//
                    .expr("context_disable_dummy()").newLine()//
                    .expr("disable_debug()").newLine().newLine()//
                    .expr("lib = backend:get()").newLine()//
                    .expr("cam = lib.get_camera()").newLine()//
                    .expr("cam.near = ?", params.getIniParam(HPMSParams.IniParam.CAM_NEAR)).newLine()//
                    .expr("cam.far = ?", params.getIniParam(HPMSParams.IniParam.CAM_FAR)).newLine()//
                    .expr("cam.fovy = lib.to_radians(?)", params.getIniParam(HPMSParams.IniParam.CAM_FOVY)).newLine().newLine()//
                    .expr("sceneManager = scene_manager:new(scene.name, cam)").newLine()//
                    .expr("roomState = room_state:ret(scene.name)").newLine()//
                    .expr("stateManager = global_state_manager:new()").newLine()//
                    .expr("inputProfile = input_profile:new(context_get_input_profile())").newLine()//
                    .expr("sceneManager = scene_manager:new(scene.name, cam)").newLine()//
                    .expr("actorsManager = actors_manager:new(sceneManager)").newLine()//
                    .expr("workflow = workflow:new(sceneManager)").newLine()//
                    .expr("eventManager = event_queue_manager:new()").newLine().newLine();

            SceneObject.sortedValues(true).stream().map(SceneObject::getBehavior).filter(Objects::nonNull).forEach(bh -> bh.handleSetupPre(builder, roomInfo));
            SceneObject.sortedValues(true).stream().map(SceneObject::getBehavior).filter(Objects::nonNull).forEach(bh -> bh.handleSetupPost(builder, roomInfo));

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
            SceneObject.sortedValues(true).stream().map(SceneObject::getBehavior).filter(Objects::nonNull).forEach(bh -> bh.handleUpdatePre(builder, roomInfo));
            builder.expr("sceneManager:poll_events(tpf)").newLine()//
                    .expr("actorsManager:poll_events(tpf)").newLine()//
                    .expr("workflow:poll_events(tpf)").newLine().newLine();
            SceneObject.sortedValues(true).stream().map(SceneObject::getBehavior).filter(Objects::nonNull).forEach(bh -> bh.handleUpdatePost(builder, roomInfo));
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

            SceneObject.sortedValues(false).stream().map(SceneObject::getBehavior).filter(Objects::nonNull).forEach(bh -> bh.handleCleanupPost(builder, roomInfo));

            // Base scene cleanup
            builder.expr("-- Base scene delete").newLine()
                    .expr("context_delete_all_volatile()").newLine()//
                    .expr("roomState:delete_dropped_collectibles()").newLine()//
                    .expr("actorsManager:delete_all()").newLine()//
                    .expr("sceneManager:delete_all()").newLine()//
                    .expr("sequence:delete_all()").newLine().newLine();

            return builder.build();
        }
    };

    public abstract LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo);
}