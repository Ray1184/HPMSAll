package org.ray1184.hpms.batch.tasks.utils;

import lombok.AllArgsConstructor;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;

import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
public enum SceneObject {

    // @formatter:off
    CAMERA              ("CAMERA",      null                    ),
    SECTOR              ("SECTOR",      null                    ),
    ENTITY              ("ENTITY",      null                    ),
    COLLISION_DATA      ("COLLISION",   null                    ),
    DEPTH_DATA          ("DEPTH",       null                    ),
    TRIGGER_POS         ("TRIGGER",     "BY_POSITION"           ),
    VIEW_ACTIVATOR      ("SECTOR",      "ACTIVATE_CAM"          ),
    ENTITY_DESCRIPTORS  ("ENTITY",      "ENTITY_DESCRIPTORS"    );
    // @formatter:on

    private final String type;
    private final String event;

    public static SceneDataResponse.RoomInfo.ObjectInfo.EventInfo eventByName(SceneDataResponse.RoomInfo.ObjectInfo objectInfo, String eventName) {
        for (SceneDataResponse.RoomInfo.ObjectInfo.EventInfo e : objectInfo.getEvents()) {
            if (e.getName().equalsIgnoreCase(eventName)) {
                return e;
            }
        }
        return null;
    }

    public static <T> T getParam(SceneDataResponse.RoomInfo.ObjectInfo.EventInfo event, int index) {
        String[] tokens = event.getParams().split(",");
        String tok = tokens[index];
        try {
            return (T) Double.valueOf(tok);
        } catch (NumberFormatException e) {
            return (T) tok;
        }
    }

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


}
