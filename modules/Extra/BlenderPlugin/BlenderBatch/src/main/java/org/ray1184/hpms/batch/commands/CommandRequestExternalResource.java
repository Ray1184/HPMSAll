package org.ray1184.hpms.batch.commands;

import lombok.Getter;
import lombok.SneakyThrows;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class CommandRequestExternalResource extends CommandRequest {

    private final List<String> fileContent;

    private final String fileName;

    @Getter
    private final String scriptName;

    @SneakyThrows
    public CommandRequestExternalResource(String fileName, String scriptName) {
        super();
        this.fileName = fileName;
        this.scriptName = scriptName;
        URL res = getClass().getClassLoader().getResource(fileName);
        assert res != null;
        fileContent = Files.readAllLines(Paths.get(res.toURI()));
    }

    @Override
    protected StringBuilder getLogFunction() {
        StringBuilder sb = new StringBuilder();
        sb.append("logger.write(level['label'] + '|BLEND|' + date + '|Blender Thread|")//
                .append(fileName)
                .append("|'")//
                .append(" + msg + '\\n')\n");
        return sb;
    }

    @Override
    protected List<String> getStatements() {
        return fileContent;
    }
}
