package org.ray1184.hpms.batch.commands;

import lombok.Getter;
import lombok.Setter;
import org.ray1184.hpms.batch.HPMSParams;

@Getter
@Setter
public class BlenderContext {

    private static BlenderContext instance;

    private String blenderExecPath;
    private String blenderSourcePath;
    private String blenderVersion;
    private boolean mock;

    private BlenderContext() {
    }

    public static BlenderContext getInstance() {
        if (instance == null) {
            instance = new BlenderContext();
        }
        return instance;
    }

    public void init(HPMSParams params) {
        blenderExecPath = params.getRuntimeExe();
        blenderSourcePath = params.getBlendFilePath();
        mock = Boolean.parseBoolean(String.valueOf(params.getIniParam(HPMSParams.IniParam.MOCK)));
    }
}
