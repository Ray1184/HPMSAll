package org.ray1184.hpms.batch.lua;

public interface LuaScriptPart {

    String INDENT = "    ";
    String USER_SECTION_START = "-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE";
    String USER_SECTION_END = "-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE";

    String getScript();

    String getName();
}
