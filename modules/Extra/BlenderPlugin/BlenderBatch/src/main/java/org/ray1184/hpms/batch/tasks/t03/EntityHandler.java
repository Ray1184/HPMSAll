package org.ray1184.hpms.batch.tasks.t03;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.utils.SceneObject;

import java.util.Optional;

public class EntityHandler {

    @AllArgsConstructor
    @Getter
    public enum Descriptor {
        PLAYER("player") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }

            @Override
            public void handleCleanupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }
        },
        COLLISOR("collisor") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
                Optional<SceneDataResponse.RoomInfo.ObjectInfo> sectorInfoOpt = SceneObject.filter(roomInfo, SceneObject.SECTOR).stream().findFirst();
                if (sectorInfoOpt.isEmpty()) {
                    throw new RuntimeException("Cannot create collisors without sector map");
                }
                SceneDataResponse.RoomInfo.ObjectInfo sectorInfo = sectorInfoOpt.get();
                scriptBuilder.dummy()
                        .expr("collisor_? = lib.make_node_collisor(entity_node_, map_?, TRESHOLD)", e.getName().toLowerCase(), e.getName().toLowerCase(), sectorInfo.getName().toLowerCase());
            }

            @Override
            public void handleCleanupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }
        },
        NPC("npc") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }

            @Override
            public void handleCleanupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }
        };

        private String label;

        public static Descriptor byLabel(String label) {
            for (Descriptor t : values()) {
                if (t.label.equalsIgnoreCase(label)) {
                    return t;
                }
            }
            throw new RuntimeException("Type " + label + " is not a valid entity description");
        }

        public abstract void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e);

        public abstract void handleCleanupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e);
    }
}