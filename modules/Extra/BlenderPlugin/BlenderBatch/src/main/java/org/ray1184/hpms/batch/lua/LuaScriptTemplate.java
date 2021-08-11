package org.ray1184.hpms.batch.lua;

import org.apache.commons.lang3.StringUtils;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.util.*;

public class LuaScriptTemplate {

    private static Map<String, String> extractUserDataBySections(String scriptContent) {
        Map<String, String> userDataBySection = new HashMap<>();
        List<String> lines = Arrays.asList(scriptContent.split("\\r?\\n"));
        FinalObjectWrapper<Boolean> userSectionFoundWrapper = new FinalObjectWrapper<>();
        userSectionFoundWrapper.setObject(false);
        FinalObjectWrapper<String> lastSectionWrapper = new FinalObjectWrapper<>();
        lastSectionWrapper.setObject("");
        List<String> userData = new ArrayList<>();
        lines.stream()//
                .map(String::trim)//
                .forEach(l -> {
                    if (l.startsWith(LuaScriptPart.USER_SECTION_START)) {
                        userSectionFoundWrapper.setObject(true);
                        lastSectionWrapper.setObject(l.substring(l.indexOf('[') + 1, l.indexOf(']')));
                    }
                    if (l.startsWith(LuaScriptPart.USER_SECTION_END)) {
                        userSectionFoundWrapper.setObject(false);
                        userData.remove(0);
                        int diff = userData.get(0).length() - userData.get(0).trim().length();
                        List<String> userDataFormatted = new ArrayList<>();
                        userData.forEach(sl -> userDataFormatted.add(sl.substring(diff + 1)));
                        userDataBySection.put(lastSectionWrapper.getObject(), StringUtils.join(userDataFormatted));
                        userData.clear();
                    }
                    if (l.trim().length() > 0 && userSectionFoundWrapper.getObject()) {
                        userData.add(l.trim());
                    }
                });
        return userDataBySection;
    }

    private static void setSectionUserData(LuaScript script, String section, String callback, Map<String, String> userDataBySection) {
        script.getSection(section).getCallback(callback).setUserCode(new LuaUserCode(userDataBySection.get(callback), callback));
    }

    public LuaScript restoreWithUserData(String scriptContent) {
        Map<String, String> userDataBySection = extractUserDataBySections(scriptContent);
        LuaScript template = generateTemplate();
        setSectionUserData(template, "scene", "setup", userDataBySection);
        setSectionUserData(template, "scene", "input", userDataBySection);
        setSectionUserData(template, "scene", "update", userDataBySection);
        setSectionUserData(template, "scene", "cleanup", userDataBySection);
        return template;
    }

    public LuaScript generateTemplate() {
        LuaScript template = new LuaScript("SceneTemplate");
        template.addSection(new LuaMacroSection("dependencies"));
        LuaMacroSection scene = new LuaMacroSection("scene");
        scene.addStatement(new LuaStatement("name = 'SceneTemplate'"));
        scene.addStatement(new LuaStatement("version = 1.0"));
        scene.addStatement(new LuaStatement("quit = false"));
        scene.addStatement(new LuaStatement("finished = false"));
        scene.addStatement(new LuaStatement("next = 'TBD'"));
        scene.addCallback(new LuaCallback("setup"));
        scene.addCallback(new LuaCallback("input", List.of("keys", "mouse_buttons", "x", "y")));
        scene.addCallback(new LuaCallback("update", List.of("tpf")));
        scene.addCallback(new LuaCallback("cleanup"));
        template.addSection(scene);
        return template;
    }


}
