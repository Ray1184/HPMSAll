package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

public class DepthDataBehavior extends SceneObjectBehavior {


    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(e -> {
            builder.expr("-- Depth mask ? setup", e.getName()).newLine()//
                    .expr("entity_? = lib.make_depth_entity('?.mesh')", e.getName().toLowerCase(), e.getName()).newLine()//
                    .expr("entity_node_? = lib.make_node('?Node')", e.getName().toLowerCase(), e.getName()).newLine()//
                    .expr("entity_node_?.position = lib.vec3(?, ?, ?)", e.getName().toLowerCase(), e.getPosition().getX(), e.getPosition().getY(), e.getPosition().getZ()).newLine()//
                    .expr("entity_node_?.rotation = lib.quat(?, ?, ?, ?)", e.getName().toLowerCase(), e.getRotation().getW(), e.getRotation().getX(), e.getRotation().getY(), e.getRotation().getZ()).newLine()//                        .
                    .expr("entity_node_?.scale = lib.vec3(?, ?, ?)", e.getName().toLowerCase(), e.getScale().getX(), e.getScale().getY(), e.getScale().getZ()).newLine()//                        .
                    .expr("lib.set_node_entity(entity_node_?, entity_?)", e.getName().toLowerCase(), e.getName().toLowerCase()).newLine().newLine();


        });
    }

    @Override
    public void handleSetupPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleInputPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleInputPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleUpdatePre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleUpdatePost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleCleanupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {

    }

    @Override
    public void handleCleanupPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(e -> {
            builder.expr("-- Depth mask ? cleanup", e.getName()).newLine()//
                    .expr("lib.delete_node(entity_node_?)", e.getName().toLowerCase()).newLine()//
                    .expr("lib.delete_depth_entity(entity_?)", e.getName().toLowerCase()).newLine().newLine();


        });
    }
}
