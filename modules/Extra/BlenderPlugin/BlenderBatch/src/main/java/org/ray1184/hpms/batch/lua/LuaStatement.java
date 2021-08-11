package org.ray1184.hpms.batch.lua;

import lombok.Getter;
import lombok.Setter;

public class LuaStatement implements LuaScriptPart {

    @Setter
    private String content;

    @Getter
    private String name;

    public LuaStatement(String name, String content, boolean plainString) {
        if (plainString) {
            this.content = "'" + content + "'";
        } else {
            this.content = content;
        }
    }

    public LuaStatement(String name, String content) {
        this(name, content, false);
    }

    public LuaStatement(String content) {
        this("Stat_" + content.hashCode(), content, false);
    }

    public void addContent(String content) {
        addContent(content, false);
    }

    public void addContent(String content, boolean newLine) {
        this.content += content;
        if (newLine) {
            this.content += "\n";
        }
    }


    @Override
    public String getScript() {
        return content;
    }


}
