package org.ray1184.hpms.batch.commands.impl;

import org.ray1184.hpms.batch.commands.CommandBuilder;
import org.ray1184.hpms.batch.commands.CommandProcessor;
import org.ray1184.hpms.batch.commands.CommandResponse;
import org.ray1184.hpms.batch.commands.impl.res.BlenderInfoResponse;
import org.ray1184.hpms.batch.commands.impl.res.ExportResponse;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;

import java.util.HashMap;
import java.util.Map;

public enum HPMSCommands {

    // @formatter:off
    BL_VERSION          (BlenderInfoResponse.class   ,    "req/bl_info.py"              ,  "Retrieve installed blender version"     ),
    SCENE_DATA          (SceneDataResponse.class     ,    "req/scene_data.py"           ,  "Retrieve info for current scene"        ),
    EXPORT_ENTITIES     (ExportResponse.class        ,    "req/export_entities.py"      ,  "Export all entities"                    ),
    EXPORT_DEPTH        (ExportResponse.class        ,    "req/export_depth.py"         ,  "Export all depth masks"                 ),
    EXPORT_COLLISIONS   (ExportResponse.class        ,    "req/export_collisions.py"    ,  "Export all collision maps"              ),
    RENDERING           (ExportResponse.class        ,    "req/render.py"               ,  "Rendering by given cams"                );
    // @formatter:on

    private final CommandProcessor commandProcessor;

    private final Map<String, Object> params;

    HPMSCommands(Class<? extends CommandResponse> responseClass, String scriptName, String info) {
        params = new HashMap<>();
        commandProcessor = new CommandBuilder()//
                .request(scriptName)//
                .response(responseClass)//
                .info(name() + " - [" + info + "]")//
                .build();
    }

    public HPMSCommands param(String name, Object value) {
        params.put(name, value);
        return this;
    }

    public CommandResponse exec() {
        return exec(params);
    }

    public CommandResponse exec(Map<String, Object> params) {
        return commandProcessor.exec(params);
    }
}
