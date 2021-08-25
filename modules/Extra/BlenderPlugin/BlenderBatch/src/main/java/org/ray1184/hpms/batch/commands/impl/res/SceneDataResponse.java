package org.ray1184.hpms.batch.commands.impl.res;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.ray1184.hpms.batch.commands.CommandResponse;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class SceneDataResponse extends CommandResponse {

    private List<RoomInfo> rooms;

    @Data
    public static class RoomInfo {
        private String name;
        private List<ObjectInfo> objects;

        @Data
        public static class ObjectInfo {
            private String name;
            private String type;
            private List<EventInfo> events;
            private PositionInfo position;
            private RotationInfo rotation;

            @Data
            public static class EventInfo {
                private String name;
                private String params;
            }


            @Data
            public static class PositionInfo {
                private Double x;
                private Double y;
                private Double z;


            }

            @Data
            public static class RotationInfo {
                private Double w;
                private Double x;
                private Double y;
                private Double z;

            }


        }

    }


}
