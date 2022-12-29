package org.ray1184.hpms.batch.tasks.scene;

import lombok.Getter;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.tasks.scene.sub.*;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public enum SceneObject {
    // @formatter:off
    CAMERA              (0  , "CAMERA"    , null                    , null),
    PERIMETER           (1  , "PERIMETER" , null                    , new PerimeterBehavior()),
    OBSTACLE            (1  , "OBSTACLE"  , null                    , null),
    VIEW_ACTIVATOR      (2  , "SECTOR"    , "ACTIVATE_CAM"          , new ViewActivatorBehavior()),
    ENTITY              (3  , "ENTITY"    , null                    , new EntityBehavior()),
    ENTITY_DESCRIPTORS  (4  , "ENTITY"    , "ENTITY_DESCRIPTORS"    , new EntityDescriptorsBehavior()),
    COLLISION_DATA      (5  , "COLLISION" , null                    , null),
    DEPTH_DATA          (6  , "DEPTH"     , null                    , new DepthDataBehavior()),
    TRIGGER_POS         (7  , "TRIGGER"   , "BY_POSITION"           , new TriggerPosBehavior());
    // @formatter:on


    private final int priority;
    private final String type;
    private final String event;

    @Getter
    private final SceneObjectBehavior behavior;

    SceneObject(int priority, String type, String event, SceneObjectBehavior behavior) {
        this.priority = priority;
        this.type = type;
        this.event = event;
        this.behavior = behavior;
        if (this.behavior != null) {
            this.behavior.setSceneObject(this);
        }
    }

    public static List<SceneObject> sortedValues(boolean ascSorting) {
        SceneObject[] objects = SceneObject.values();
        List<SceneObject> objList = Arrays.asList(objects);
        objList.sort(Comparator.comparingInt(c -> ascSorting ? c.priority : -c.priority));
        return objList;
    }

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
