package org.ray1184.hpms.batch.lua;

import lombok.Getter;
import lombok.Setter;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LuaCallback implements LuaScriptPart {

    @Getter
    private final String name;
    private final List<String> params;
    private final List<LuaStatement> statementsPre;
    private final List<LuaStatement> statementsPost;

    @Setter
    private LuaUserCode userCode;

    public LuaCallback(String name, List<String> params) {
        this.params = params;
        this.name = name;
        statementsPre = new ArrayList<>();
        statementsPost = new ArrayList<>();
    }

    public LuaCallback(String name) {
        this(name, null);
    }

    @Override
    public String getScript() {
        StringBuilder callback = new StringBuilder();
        String paramsDesc = "";
        if (CollectionUtils.isNotEmpty(params)) {
            paramsDesc = StringUtils.join(params, ", ");
        }
        callback.append(name)
                .append(" = function(")
                .append(paramsDesc)
                .append(")");

        statementsPre.forEach(s -> Arrays.asList(s.getScript().split("\\r?\\n")).forEach(l -> callback.append("\n").append(INDENT).append(l)));

        if (userCode == null) {
            userCode = new LuaUserCode("-- TODO", name);
        } else {
            userCode.setCallbackName(name);
        }
        Arrays.asList(userCode.getScript().split("\\r?\\n")).forEach(l -> callback.append("\n").append(INDENT).append(l));
        callback.append("\n");


        statementsPost.forEach(s -> Arrays.asList(s.getScript().split("\\r?\\n")).forEach(l -> callback.append("\n").append(INDENT).append(l)));
        callback.append("\nend\n");
        return callback.toString();
    }

    public void addStatementPre(LuaStatement statement) {
        if (statement == null) {
            return;
        }
        statementsPre.add(statement);
    }

    public void addStatementPost(LuaStatement statement) {
        if (statement == null) {
            return;
        }
        statementsPost.add(statement);
    }

}
