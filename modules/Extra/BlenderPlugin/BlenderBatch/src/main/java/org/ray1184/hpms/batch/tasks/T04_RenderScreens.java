package org.ray1184.hpms.batch.tasks;

import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.HPMSProcess;

public class T04_RenderScreens implements HPMSTask {

    @Override
    public Integer execute(HPMSParams params) {
        return HPMSProcess.RET_CODE_OK;
    }

    @Override
    public boolean enabled() {
        return true;
    }
}
