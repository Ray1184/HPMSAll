package org.ray1184.hpms.batch.commands.impl.res;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.ray1184.hpms.batch.commands.CommandResponse;

import java.util.List;

@Getter
@Setter
@ToString
public class SceneDataResponse extends CommandResponse {
    private List<RoomInfo> rooms;

    @Getter
    @Setter
    @ToString
    public static class RoomInfo {
        private String name;
        private List<SectorInfo> sectors;
        private List<TriggerInfo> triggers;
        private List<EntityInfo> entities;
        private CollisionInfo collisionData;
        private DepthInfo depthData;


        @Getter
        @Setter
        @ToString
        public static class SectorInfo {
            private String id;
            private CameraInfo activeCamera;


            @Getter
            @Setter
            @ToString
            public static class CameraInfo {
                private String name;
                private PositionInfo position;
                private RotationInfo rotation;


            }
        }

        @Getter
        @Setter
        @ToString
        public static class TriggerInfo {
            private String name;

        }

        @Getter
        @Setter
        @ToString
        public static class EntityInfo {
            private String name;
            private PositionInfo position;
            private RotationInfo rotation;
            private Boolean collisionBased;
            private Type type;

            enum Type {
                PLAYER,
                NPC,
                STATIC,
                PUSHABLE,
                COLLECTIBLE

            }
        }

        @Getter
        @Setter
        @ToString
        public static class CollisionInfo {
            private String name;

        }

        @Getter
        @Setter
        @ToString
        public static class DepthInfo {
            private String name;

        }
    }

    @Getter
    @Setter
    @ToString
    public static class PositionInfo {
        private Double x;
        private Double y;
        private Double z;


    }

    @Getter
    @Setter
    @ToString
    public static class RotationInfo {
        private Double w;
        private Double x;
        private Double y;
        private Double z;

    }
}
