package org.ray1184.hpms.batch.tasks;

import lombok.Getter;
import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;

public class T03_GenerateScripts implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        return null;
    }

    @Override
    public boolean enabled() {
        return false;
    }

    public enum GlobalVariables {
        LIB("lib"),
        SCENE_MANAGER("scene_manager"),
        CURRENT_SECTOR("current_sector"),
        BACKGROUND("background");

        private final String varName;
        private String builtVarName;

        GlobalVariables(String varName) {
            this.varName = varName;
            this.builtVarName = varName;
        }

        private void resetVar() {
            builtVarName = varName;
        }

        public GlobalVariables postfix(String postfix) {
            builtVarName += postfix;
            return this;
        }

        public GlobalVariables prefix(String prefix) {
            builtVarName = prefix + builtVarName;
            return this;
        }

        public LuaStatement method(String function) {
            LuaStatement ret = new LuaStatement(varName + ":" + function);
            resetVar();
            return ret;
        }

        public LuaStatement field(String field) {
            LuaStatement ret = new LuaStatement(varName + "." + field);
            resetVar();
            return ret;
        }

        public LuaStatement var() {
            LuaStatement ret = new LuaStatement(varName);
            resetVar();
            return ret;
        }


    }

    public enum ScriptSections {
        VIEWS("setup") {
            @Override
            public LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo) {

                LuaStatementBuilder builder = new LuaStatementBuilder("VIEWS_STATS");
                roomInfo.getSectors().forEach(s -> {
                    SceneDataResponse.RoomInfo.SectorInfo.CameraInfo camInfo = s.getActiveCamera();
                    builder.function(GlobalVariables.SCENE_MANAGER.method("sample_view_by_callback"))
                            .expr("function() return ")
                            .expr(GlobalVariables.CURRENT_SECTOR.field("id").getScript())
                            .varExpr("== '?' end, ?, lib.vec3(?, ?, ?), lib.quat(?, ?, ?, ?)",
                                    GlobalVariables.BACKGROUND.postfix(camInfo.getName()).var(), camInfo.getPosition().getX(),
                                    camInfo.getPosition().getY(), camInfo.getPosition().getZ(),
                                    camInfo.getRotation().getW(), camInfo.getRotation().getX(),
                                    camInfo.getRotation().getY(), camInfo.getRotation().getZ())

                            .endFunction()
                            .build();
                });
                return builder.build();
            }
        };

        @Getter
        private final String section;

        ScriptSections(String section) {
            this.section = section;
        }

        public abstract LuaStatement getCustomStatement(HPMSParams params, SceneDataResponse.RoomInfo roomInfo);
    }
}
