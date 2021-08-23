package org.ray1184.hpms.batch.commands;

import org.junit.jupiter.api.Test;
import org.ray1184.hpms.batch.lua.LuaScript;
import org.ray1184.hpms.batch.lua.LuaScriptGenerator;

public class LuaScriptTest {

    @Test
    public void testTemplate() {
        LuaScriptGenerator templateGen = new LuaScriptGenerator();
        LuaScript template = templateGen.generateTemplate("TestRoom", "1.0");
        System.out.println("######################################");
        System.out.println(template.getScript());
        System.out.println("######################################");
    }
}
