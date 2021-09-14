package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.EntityHandler;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

import java.util.Arrays;
import java.util.List;

public class EntityDescriptorsBehavior extends SceneObjectBehavior {


    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(e -> {
            SceneDataResponse.RoomInfo.ObjectInfo.EventInfo event = e.getEvents().get(0);
            List<String> types = Arrays.asList(event.getParams().split(","));
            if (!types.contains("collisor")) {
                types.add("no_collisor");
            } else {
                types.remove("no_collisor");
            }
            for (String type : types) {
                EntityHandler.Descriptor.byLabel(type).handleSetupPre(roomInfo, builder, e);
            }

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
            SceneDataResponse.RoomInfo.ObjectInfo.EventInfo event = e.getEvents().get(0);
            String[] types = event.getParams().split(",");
            for (String type : types) {
                EntityHandler.Descriptor.byLabel(type).handleCleanupPost(roomInfo, builder, e);
            }

        });
    }
}
