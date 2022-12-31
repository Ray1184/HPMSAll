package org.ray1184.hpms.batch;

import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.batch.commands.BlenderContext;
import org.ray1184.hpms.batch.tasks.*;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

@Slf4j
public class HPMSProcess implements Callable<Integer> {

    public static final int RET_CODE_OK = 0;

    public static final int RET_CODE_ERROR = 1;

    private static final List<Class<? extends HPMSTask>> TASKS = new ArrayList<>();

    static {
        TASKS.add(T01_CreateStructure.class);
        TASKS.add(T02_ExportResources.class);
        TASKS.add(T03_GenerateScripts.class);
        TASKS.add(T04_RenderScreens.class);
        TASKS.add(T05_Validate.class);

    }

    private final HPMSParams params;

    public HPMSProcess(HPMSParams params) {
        this.params = params;
    }


    @Override
    public Integer call() {
        FinalObjectWrapper<Integer> retCode = new FinalObjectWrapper<>(RET_CODE_OK);
        BlenderContext.getInstance().init(params);
        TASKS.forEach(t -> {
            try {
                HPMSTask task = t.getDeclaredConstructor().newInstance();
                if (retCode.getObject() == RET_CODE_ERROR) {
                    return;
                }
                if (!task.enabled()) {
                    log.warn("SKIPPING task {}", task.name());
                    return;
                }
                log.error("EXECUTING task {}", task.name());
                Integer ret = task.execute(params);
                log.info("Task finished with code: {}", ret);
                retCode.setObject(ret);
            } catch (Exception e) {
                log.error("Batch error:", e);
                retCode.setObject(RET_CODE_ERROR);
            }
        });
        return retCode.getObject();
    }
}
