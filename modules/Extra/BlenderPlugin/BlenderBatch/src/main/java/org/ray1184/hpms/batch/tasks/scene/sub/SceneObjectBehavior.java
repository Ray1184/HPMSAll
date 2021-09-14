package org.ray1184.hpms.batch.tasks.scene.sub;

import lombok.Getter;
import lombok.Setter;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;
import org.ray1184.hpms.batch.lua.LuaStatementBuilder;
import org.ray1184.hpms.batch.tasks.scene.SceneObject;

@Getter
@Setter
public abstract class SceneObjectBehavior {

    protected SceneObject sceneObject;

    public abstract void handleSetupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleSetupPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleInputPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleInputPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleUpdatePre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleUpdatePost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleCleanupPre(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);

    public abstract void handleCleanupPost(LuaStatementBuilder builder, SceneDataResponse.RoomInfo roomInfo);
}
