package org.ray1184.hpms.batch.tasks.scene.sub;

import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

public class ViewActivatorBehavior extends SceneObjectBehavior {


    @Override
    public void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo) {
        SceneObject.filter(roomInfo, super.sceneObject).forEach(a -> SceneObject.filter(roomInfo, SceneObject.CAMERA).stream()//
                .filter(c -> a.getEvents().stream().anyMatch(e -> e.getParams().contains(c.getName())))//
                .forEach(c -> {
                    builder.expr("-- View ? setup", c.getName()).newLine()//
                            .expr("background_? = lib.make_background('?')", c.getName().toLowerCase(), roomInfo.getName() + "/" + c.getName() + ".png").newLine();

                    if (SceneObject.filter(roomInfo, SceneObject.SECTOR).stream().findFirst().isPresent()) {
                        builder.expr("scn_mgr:sample_view_by_callback(function() if current_sector ~= nil then return current_sector.id == '?' else return false end end, background_?, lib.vec3(?, ?, ?), lib.quat(?, ?, ?, ?))",
                                a.getName(), c.getName().toLowerCase(), c.getPosition().getX(), c.getPosition().getY(), c.getPosition().getZ(),
                                c.getRotation().getW(), c.getRotation().getX(), c.getRotation().getY(), c.getRotation().getZ()).newLine().newLine();
                    } else {
                        builder.newLine();
                    }
                }));


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
        SceneObject.filter(roomInfo, super.sceneObject).forEach(a -> SceneObject.filter(roomInfo, SceneObject.CAMERA).stream().filter(c -> a.getEvents().stream().anyMatch(e -> e.getParams().contains(c.getName()))).forEach(c -> {
            builder.expr("-- View ? delete", c.getName()).newLine()//
                    .expr("lib.delete_background(background_?)", c.getName().toLowerCase()).newLine().newLine();
        }));
    }
}
