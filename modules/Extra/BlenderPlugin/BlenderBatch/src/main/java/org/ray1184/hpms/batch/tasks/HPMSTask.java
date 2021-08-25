package org.ray1184.hpms.batch.tasks;

import org.ray1184.hpms.batch.HPMSParams;
import org.ray1184.hpms.batch.commands.CommandResponse;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;

import java.util.HashMap;
import java.util.Map;

public interface HPMSTask {

    Integer execute(HPMSParams params);

    boolean enabled();

    default String name() {
        return getClass().getSimpleName();
    }

    default CommandResponse execCachedCommand(HPMSParams params, HPMSCommands command) {
        return execCachedCommand(params, command, null);
    }

    default CommandResponse execCachedCommand(HPMSParams params, HPMSCommands command, Map<String, Object> args) {
        if (args == null) {
            args = new HashMap<>();
        }
        String cacheKey = command.name() + "-" + args.hashCode();
        Map<String, Object> finalArgs = args;
        params.getSessionParams().computeIfAbsent(cacheKey, k -> command.exec(finalArgs));
        return (CommandResponse) params.getSessionParams().get(cacheKey);
    }
}
