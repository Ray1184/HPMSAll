package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

public class PerimeterBehavior extends SceneObjectBehavior {

    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        if (SceneObject.filter(roomInfo, super.sceneObject).stream().findFirst().isPresent()) {
            builder.expr("-- Collision map ? setup", roomInfo.getName()).newLine()//
                    .expr("walkmap_? = lib.make_walkmap('?.walkmap')", roomInfo.getName().toLowerCase(), roomInfo.getName()).newLine().newLine();

        }
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
        if (SceneObject.filter(roomInfo, super.sceneObject).stream().findFirst().isPresent()) {
            builder.expr("-- Collision map ? delete", roomInfo.getName()).newLine()//
                    .expr("lib.delete_walkmap(walkmap_?)", roomInfo.getName().toLowerCase()).newLine().newLine();

        }
    }
}
