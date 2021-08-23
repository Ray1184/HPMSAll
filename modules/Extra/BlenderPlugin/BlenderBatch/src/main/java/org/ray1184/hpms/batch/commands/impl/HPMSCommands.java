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
    BL_VERSION          (BlenderInfoResponse.class   ,    "py/bl_info.py"              ,  "Retrieve installed blender version"     ),
    SCENE_DATA          (SceneDataResponse.class     ,    "py/scene_data.py"           ,  "Retrieve info for current scene"        ),
    // EXPORT_ENTITIES     (ExportResponse.class        ,    "py/export_entities.py"      ,  "Export all entities"                    ),
    // EXPORT_DEPTH        (ExportResponse.class        ,    "py/export_depth.py"         ,  "Export all depth masks"                 ),
    // EXPORT_COLLISIONS   (ExportResponse.class        ,    "py/export_collisions.py"    ,  "Export all collision maps"              ),
    RENDERING           (ExportResponse.class        ,    "py/render.py"               ,  "Rendering by given cams"                );
    // @formatter:on

    private final CommandProcessor commandProcessor;

    private final Map<String, Object> params;

    HPMSCommands(Class<? extends CommandResponse> responseClass, String scriptPath, String info) {
        params = new HashMap<>();
        String[] scriptNameTokens = scriptPath.split("/");
        String scriptName = scriptNameTokens[scriptNameTokens.length - 1].replace(".py", "");
        commandProcessor = new CommandBuilder()//
                .request(scriptPath, scriptName)//
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
