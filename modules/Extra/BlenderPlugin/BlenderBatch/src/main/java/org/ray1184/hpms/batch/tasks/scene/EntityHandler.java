package org.ray1184.hpms.batch.tasks.scene;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;

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
            public void handleCleanupPost(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }
        },
        COLLISOR("collisor") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
                Optional<SceneDataResponse.RoomInfo.ObjectInfo> sectorInfoOpt = SceneObject.filter(roomInfo, SceneObject.PERIMETER).stream().findFirst();
                if (sectorInfoOpt.isEmpty()) {
                    throw new RuntimeException("Cannot create collisors without sector map");
                }
                scriptBuilder.expr("-- Collisor ? setup", e.getName()).newLine()//
                        .expr("collisor_? = lib.make_node_collisor(entity_node_?, walkmap_?, TRESHOLD)", e.getName().toLowerCase(), e.getName().toLowerCase(), roomInfo.getName().toLowerCase()).newLine()//
                        .expr("collisor_?.position = lib.vec3(?, ?, ?)", e.getName().toLowerCase(), e.getPosition().getX(), e.getPosition().getY(), e.getPosition().getZ()).newLine()//
                        .expr("collisor_?.rotation = lib.quat(?, ?, ?, ?)", e.getName().toLowerCase(), e.getRotation().getW(), e.getRotation().getX(), e.getRotation().getY(), e.getRotation().getZ()).newLine().newLine();//

            }

            @Override
            public void handleCleanupPost(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
                Optional<SceneDataResponse.RoomInfo.ObjectInfo> sectorInfoOpt = SceneObject.filter(roomInfo, SceneObject.PERIMETER).stream().findFirst();
                if (sectorInfoOpt.isEmpty()) {
                    throw new RuntimeException("Cannot delete collisors without sector map");
                }
                scriptBuilder.expr("-- Collisor ? delete", e.getName()).newLine()//
                        .expr("lib.delete_collisor(collisor_?)", e.getName().toLowerCase(), e.getName().toLowerCase()).newLine().newLine();
            }
        },
        NO_COLLISOR("no_collisor") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {

                scriptBuilder.expr("-- No-Collisor ? setup", e.getName()).newLine()//
                        .expr("entity_node_?.position = lib.vec3(?, ?, ?)", e.getPosition().getX(), e.getPosition().getY(), e.getPosition().getZ()).newLine()//
                        .expr("entity_node_?.rotation = lib.quat(?, ?, ?, ?)", e.getRotation().getW(), e.getRotation().getX(), e.getRotation().getY(), e.getRotation().getZ()).newLine().newLine();

            }

            @Override
            public void handleCleanupPost(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }
        },
        NPC("npc") {
            @Override
            public void handleSetupPre(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
            }

            @Override
            public void handleCleanupPost(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e) {
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

        public abstract void handleCleanupPost(SceneDataResponse.RoomInfo roomInfo, LuaStatementBuilder scriptBuilder, SceneDataResponse.RoomInfo.ObjectInfo e);
    }
}