package org.ray1184.hpms.batch.config;

import lombok.Data;

import java.util.List;

@Data
public class InputConfig {

    private List<RoomConfig> rooms;

    @Data
    public class RoomConfig {


    }
}
