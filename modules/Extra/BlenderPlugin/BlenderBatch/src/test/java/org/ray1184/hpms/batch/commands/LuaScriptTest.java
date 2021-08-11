package org.ray1184.hpms.batch.commands;

import org.junit.jupiter.api.Test;
import org.ray1184.hpms.batch.lua.LuaScript;
import org.ray1184.hpms.batch.lua.LuaScriptTemplate;

public class LuaScriptTest {

    @Test
    public void testTemplate() {
        LuaScriptTemplate templateGen = new LuaScriptTemplate();
        LuaScript template = templateGen.generateTemplate();
        System.out.println("######################################");
        System.out.println(template.getScript());
        System.out.println("######################################");
    }
}
