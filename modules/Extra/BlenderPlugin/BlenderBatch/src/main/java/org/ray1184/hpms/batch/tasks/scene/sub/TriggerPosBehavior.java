package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;


public class TriggerPosBehavior extends SceneObjectBehavior {


    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(t -> {
            SceneDataResponse.RoomInfo.ObjectInfo.EventInfo event = t.getEvents().get(0);
            String entity = SceneObject.getParam(event, 0);
            Double tolerance = t.getEvents().size() > 1 ? Double.parseDouble(SceneObject.getParam(event, 1)) : 0.0d;
            builder.expr("-- Trigger on position ?", t.getName()).newLine()//
                    .expr("trigger_on_position(?, lib.vec3(?, ?, ?), ?, ?, function() trigger_?() end)", t.getName().toLowerCase(), t.getPosition().getX(), t.getPosition().getY(), t.getPosition().getZ(),
                            entity, tolerance, t.getName().toLowerCase()).newLine();
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

    }
}
