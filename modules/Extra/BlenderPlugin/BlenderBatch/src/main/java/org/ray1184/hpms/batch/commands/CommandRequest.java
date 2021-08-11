package org.ray1184.hpms.batch.commands;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.MapUtils;
import org.ray1184.hpms.batch.utils.FinalObjectWrapper;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@Slf4j
public abstract class CommandRequest {

    public static final String START_DELIMITER = "@@begin@@";
    public static final String END_DELIMITER = "@@end@@";
    protected String templateContent;

    @SneakyThrows
    public CommandRequest() {
        URL res = getClass().getClassLoader().getResource("templates/py_template.txt");
        assert res != null;
        templateContent = Files.readString(Paths.get(res.toURI()));
    }

    private static int getLogLevel() {
        if (log.isTraceEnabled()) {
            return 5;
        } else if (log.isDebugEnabled()) {
            return 4;
        } else if (log.isInfoEnabled()) {
            return 3;
        } else if (log.isWarnEnabled()) {
            return 2;
        }
        return 1;

    }

    protected abstract List<String> getStatements();

    @SneakyThrows
    public final String buildScript(Map<String, Object> params) {
        StringBuilder sb = new StringBuilder();
        List<String> statements = getStatements();
        if (CollectionUtils.isNotEmpty(statements)) {
            statements.forEach(s -> sb.append("\n").append(s));
        } else {
            throw new Exception("Command request must have at least one statement");
        }
        String content = sb.toString();
        templateContent = addParam("LOG_FN", getLogFunction().toString(), templateContent);
        templateContent = addParam("PY_CODE", content, templateContent);
        templateContent = addParam("LOG_LEVEL", getLogLevel(), templateContent);
        FinalObjectWrapper<String> retWrapper = new FinalObjectWrapper<>();
        retWrapper.setObject(templateContent);
        fillParams(params, retWrapper);
        return retWrapper.getObject();
    }

    protected StringBuilder getLogFunction() {
        StringBuilder sb = new StringBuilder();
        sb.append("logger.write(level['label'] + '|BLEND|' + date + '|Blender Thread|")//
                .append(" + msg + '\\n')\n");
        return sb;
    }

    private void fillParams(Map<String, Object> params, FinalObjectWrapper<String> retWrapper) {
        if (MapUtils.isNotEmpty(params)) {
            params.forEach((k, v) -> retWrapper.setObject(addUserParam(k, v, retWrapper.getObject())));
        }
    }

    private String addUserParam(String k, Object v, String script) {
        String val = v instanceof String ? "'" + v + "'" : String.valueOf(v);
        return addParam(k, val, script);
    }

    private String addParam(String k, Object v, String script) {
        String val = String.valueOf(v);
        script = script.replace("$" + k, val);
        script = script.replace("${" + k + "}", val);

        // Put as Null optional parameters base def
        script = script.replaceAll("\\$(.*?) or", "None or");
        return script;

    }


}
