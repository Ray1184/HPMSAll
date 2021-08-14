package org.ray1184.hpms.batch.lua;

import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

public class LuaStatementBuilder {

    private final LuaStatement statement;
    private final FinalObjectWrapper<Integer> bracketsCount;
    private final FinalObjectWrapper<Integer> openedIf;
    private final FinalObjectWrapper<Integer> openedCbs;
    private String indent;

    public LuaStatementBuilder(String name) {
        statement = new LuaStatement(name, "");
        indent = "";
        bracketsCount = new FinalObjectWrapper<>();
        bracketsCount.setObject(0);
        openedIf = new FinalObjectWrapper<>();
        openedIf.setObject(0);
        openedCbs = new FinalObjectWrapper<>();
        openedCbs.setObject(0);
    }

    private String strv(LuaFieldType fieldType, String val) {
        if (fieldType == LuaFieldType.STRING) {
            return "'" + val + "'";
        }
        return val;
    }

    private void addIndent() {
        indent += "    ";
    }

    private void remIndent() {
        if (indent.length() >= 4) {
            indent = indent.substring(0, indent.length() - 2);
        }
    }

    private void validate() {
        boolean check = bracketsCount.getObject() == 0;
        check &= openedIf.getObject() == 0;
        check &= openedCbs.getObject() == 0;
        if (!check) {
            throw new RuntimeException("Validation failed for statement " + statement.getName());
        }
    }

    public LuaStatement build() {
        validate();
        return statement;
    }

    public LuaStatementBuilder reset() {
        statement.setContent("");
        return this;
    }

    public LuaStatementBuilder expr(String template, Object... tokens) {
        template = template.replace("\\?", "__$$QSTNMRK$$__");
        for (Object token : tokens) {
            template = StringUtils.replaceOnce(template, "?", String.valueOf(token));
        }
        template = template.replace("__$$QSTNMRK$$__", "?");
        statement.addContent(template);
        return this;
    }

    public LuaStatementBuilder expr(String content) {
        statement.addContent(content);
        return this;
    }


    public LuaStatementBuilder newLine() {
        statement.addContent("\n" + LuaScriptPart.INDENT);
        return this;
    }

    public LuaStatementBuilder newLineIndentMore() {
        addIndent();
        return newLine();
    }

    public LuaStatementBuilder newLineIndentLess() {
        remIndent();
        return newLine();
    }


    public LuaStatementBuilder append(LuaStatement content) {
        statement.addContent(content.getScript());
        return this;
    }


    public LuaStatementBuilder dummy() {
        return this;
    }

    public LuaStatementBuilder assignment(LuaAssignmentOperator op, String var, LuaStatement stat) {
        return assignment(op, var, stat, LuaFieldType.EXPR);
    }


    public LuaStatementBuilder assignment(LuaAssignmentOperator op, String var, LuaStatement stat, LuaFieldType fieldType) {
        statement.addContent(var);
        statement.addContent(" ");
        statement.addContent(op.getValue());
        statement.addContent(" ");
        String val = strv(fieldType, stat.getScript());
        statement.addContent(val);
        return this;
    }

    public LuaStatementBuilder binary(LuaBinaryOperator op, LuaStatement stat1, LuaStatement stat2) {
        return binary(op, stat1, stat2, LuaFieldType.EXPR, LuaFieldType.EXPR);
    }

    public LuaStatementBuilder binary(LuaBinaryOperator op, LuaStatement stat1, LuaStatement stat2, LuaFieldType fieldType1, LuaFieldType fieldType2) {
        String val1 = strv(fieldType1, stat1.getScript());
        String val2 = strv(fieldType2, stat2.getScript());
        statement.addContent(val1);
        statement.addContent(" ");
        statement.addContent(op.getValue());
        statement.addContent(" ");
        statement.addContent(val2);
        return this;
    }

    public LuaStatementBuilder logical(LuaLogicalOperator op) {
        statement.addContent(" ");
        statement.addContent(op.getValue());
        statement.addContent(" ");
        return this;
    }

    public LuaStatementBuilder unary(LuaUnaryOperator op, LuaStatement stat) {
        statement.addContent(op.getValue());
        statement.addContent(stat.getScript());
        return this;
    }

    public LuaStatementBuilder openBracket() {
        statement.addContent("(");
        bracketsCount.setObject(bracketsCount.getObject() + 1);
        return this;
    }

    public LuaStatementBuilder closeBracket() {
        statement.addContent(")");
        bracketsCount.setObject(bracketsCount.getObject() - 1);
        return this;
    }

    public LuaStatementBuilder iif() {
        statement.addContent("if ");
        openedIf.setObject(openedIf.getObject() + 1);
        return this;
    }

    public LuaStatementBuilder then() {
        statement.addContent(" then");
        return this;
    }

    public LuaStatementBuilder elseif() {
        statement.addContent("elseif ");
        return this;
    }

    public LuaStatementBuilder eelse() {
        statement.addContent("else");
        return this;
    }

    public LuaStatementBuilder endif() {
        statement.addContent("end");
        openedIf.setObject(openedIf.getObject() - 1);
        return this;
    }

    public LuaStatementBuilder function(String name) {
        statement.addContent(name);
        statement.addContent("(");
        openedCbs.setObject(openedCbs.getObject() + 1);
        return this;
    }

    public LuaStatementBuilder function(LuaStatement fn) {
        return function(fn.getScript());
    }

    public LuaStatementBuilder endFunction() {
        statement.addContent(")");
        openedCbs.setObject(openedCbs.getObject() - 1);
        return this;
    }

    public LuaStatementBuilder callback() {
        statement.addContent("function()");
        openedCbs.setObject(openedCbs.getObject() + 1);
        return this;
    }

    public LuaStatementBuilder endCallback() {
        statement.addContent("end");
        openedCbs.setObject(openedCbs.getObject() - 1);
        return this;
    }

    public LuaStatementBuilder space() {
        statement.addContent(" ");
        return this;
    }

    public LuaStatementBuilder comma() {
        statement.addContent(", ");
        return this;
    }


    public enum LuaAssignmentOperator {
        SET("="),
        INCR("+="),
        DECR("-="),
        INCR_M("*="),
        DECR_D("/=");

        @Getter
        private final String value;

        LuaAssignmentOperator(String value) {
            this.value = value;
        }
    }

    public enum LuaUnaryOperator {
        NOT("not "),
        NEGATE("-"),
        LENGTH("#");

        @Getter
        private final String value;

        LuaUnaryOperator(String value) {
            this.value = value;
        }
    }

    public enum LuaLogicalOperator {
        AND("and"),
        OR("or");

        @Getter
        private final String value;

        LuaLogicalOperator(String value) {
            this.value = value;
        }
    }

    public enum LuaBinaryOperator {
        EQ("=="),
        GT(">"),
        GE(">="),
        LT("<"),
        LE("<="),
        NOT_EQ("~=");

        @Getter
        private final String value;

        LuaBinaryOperator(String value) {
            this.value = value;
        }
    }
}
