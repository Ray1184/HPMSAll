package org.ray1184.hpms.batch.lua;

import lombok.Setter;

public class LuaUserCode implements LuaScriptPart {

    private final String content;

    @Setter
    private String callbackName;

    public LuaUserCode(String content, String callbackName) {
        this.content = content;
        this.callbackName = callbackName;
    }

    public LuaUserCode() {
        this(null, "dummy");
    }

    @Override
    public String getScript() {
        StringBuilder userContent = new StringBuilder();
        userContent.append("\n")
                .append(USER_SECTION_START)
                .append(" [")
                .append(callbackName)
                .append("]\n")
                .append(content)
                .append('\n')
                .append(USER_SECTION_END)
                .append(" [")
                .append(callbackName)
                .append("]");
        return userContent.toString();
    }

    @Override
    public String getName() {
        return callbackName + "-userdata";
    }
}
