package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

public class EntityBehavior extends SceneObjectBehavior {


    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(e -> {
            builder.expr("-- Entity ? setup", e.getName()).newLine()//
                    .expr("entity_? = lib.make_entity('?.mesh')", e.getName().toLowerCase(), e.getName()).newLine()//
                    .expr("entity_node_? = lib.make_node('?Node')", e.getName().toLowerCase(), e.getName()).newLine()//
                    .expr("entity_node_?.scale = lib.vec3(?, ?, ?)", e.getName().toLowerCase(), e.getScale().getX(), e.getScale().getY(), e.getScale().getZ()).newLine()//
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
            builder.expr("-- Entity ? cleanup", e.getName()).newLine()//
                    .expr("lib.delete_node(entity_node_?)", e.getName().toLowerCase()).newLine()//
                    .expr("lib.delete_entity(entity_?)", e.getName().toLowerCase()).newLine().newLine();


        });
    }
}
