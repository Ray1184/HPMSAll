package org.ray1184.hpms.batch.tasks.t03;

import lombok.AllArgsConstructor;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;

import java.util.List;

@AllArgsConstructor
public enum SceneObject {

    CAM_ACTIVATOR("SECTOR", "ACTIVATE_CAM") {
        @Override
        public List<LuaStatement> solve(SceneDataResponse sceneDataResponse) {
            return null;
        }
    },
    ENTITY_DESCRIPTORS("ENTITY", "ENTITY_DESCRIPTORS") {
        @Override
        public List<LuaStatement> solve(SceneDataResponse sceneDataResponse) {
            return null;
        }
    };

    private String type;
    private String event;

    public abstract List<LuaStatement> solve(SceneDataResponse sceneDataResponse);

}
