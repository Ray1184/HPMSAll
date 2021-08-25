package org.ray1184.hpms.batch.tasks.t03;

import lombok.AllArgsConstructor;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatement;

import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
public enum SceneObject {

    CAMS("CAMERA", null) {
        @Override
        public List<LuaStatement> solve(SceneDataResponse sceneDataResponse) {
            return null;
        }
    },
    VIEW_ACTIVATOR("SECTOR", "ACTIVATE_CAM") {
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

    public static List<SceneDataResponse.RoomInfo.ObjectInfo> filter(SceneDataResponse.RoomInfo roomInfo, SceneObject sceneObject) {
        return roomInfo.getObjects().stream().filter(o -> {
            if (sceneObject.event != null) {
                return o.getType().equalsIgnoreCase(sceneObject.type) &&
                        o.getEvents().stream().anyMatch(e -> e.getName().equalsIgnoreCase(sceneObject.event));
            } else {
                return o.getType().equalsIgnoreCase(sceneObject.type);
            }
        }).collect(Collectors.toList());
    }

    public abstract List<LuaStatement> solve(SceneDataResponse sceneDataResponse);

}
