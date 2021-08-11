package org.ray1184.hpms.batch.lua;

import lombok.Getter;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.util.*;

public class LuaMacroSection implements LuaScriptPart {

    @Getter
    private final String name;
    private final List<LuaStatement> statements;
    private final List<LuaCallback> callbacks;
    private final Map<String, LuaCallback> callbacksMap;

    public LuaMacroSection(String name) {
        this.name = name;
        statements = new ArrayList<>();
        callbacks = new ArrayList<>();
        callbacksMap = new HashMap<>();
    }

    @Override
    public String getScript() {
        StringBuilder scriptData = new StringBuilder();
        scriptData.append("\n")
                .append(name)
                .append(" = {");
        FinalObjectWrapper<Integer> countWrapper = new FinalObjectWrapper<>();
        countWrapper.setObject(0);
        FinalObjectWrapper<String> tokenWrapper = new FinalObjectWrapper<>();
        tokenWrapper.setObject("");
        statements.forEach(s -> {
            if (countWrapper.getObject() > 0) {
                tokenWrapper.setObject(",");
            }
            scriptData.append(tokenWrapper.getObject());
            Arrays.asList(s.getScript().split("\\r?\\n")).forEach(l -> scriptData.append("\n").append(INDENT).append(l));
            countWrapper.setObject(countWrapper.getObject() + 1);
        });

        callbacks.forEach(s -> {
            if (countWrapper.getObject() > 0) {
                tokenWrapper.setObject(",");
            }
            scriptData.append(tokenWrapper.getObject());
            Arrays.asList(s.getScript().split("\\r?\\n")).forEach(l -> scriptData.append("\n").append(INDENT).append(l));
            countWrapper.setObject(countWrapper.getObject() + 1);
        });

        scriptData.append("\n}");

        return scriptData.toString();
    }

    public void addStatement(LuaStatement statement) {
        statements.add(statement);
    }


    public void addCallback(LuaCallback callback) {
        callbacks.add(callback);
        callbacksMap.put(callback.getName(), callback);
    }


    public LuaCallback getCallback(String name) {
        return callbacksMap.get(name);
    }
}
