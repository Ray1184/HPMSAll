package org.ray1184.hpms.batch.lua;

import lombok.Getter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class LuaScript implements LuaScriptPart {

    private static final DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
    @Getter
    private final String name;
    private final List<LuaScriptPart> sections;
    private final Map<String, LuaMacroSection> sectionsMap;

    public LuaScript(String name) {
        this.name = name;
        sections = new ArrayList<>();
        sectionsMap = new HashMap<>();
    }

    public LuaScript() {
        this("Template");
    }

    @Override
    public String getScript() {
        String currentDate = DATE_FORMAT.format(new Date());
        StringBuilder scriptData = new StringBuilder();
        scriptData.append("-- ")
                .append(name)
                .append("\n-- ")
                .append("Generated with Blend2HPMS batch on date ")
                .append(currentDate);

        sections.forEach(s -> Arrays.asList(s.getScript().split("\\r?\\n")).forEach(l -> scriptData.append("\n").append(l)));
        return scriptData.toString();
    }

    public void addSection(LuaMacroSection section) {
        sections.add(section);
        sectionsMap.put(section.getName(), section);
    }

    public LuaMacroSection getSection(String name) {
        return sectionsMap.get(name);
    }
}
