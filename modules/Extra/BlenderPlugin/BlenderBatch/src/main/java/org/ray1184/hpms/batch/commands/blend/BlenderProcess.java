package org.ray1184.hpms.batch.commands.blend;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.batch.commands.BlenderContext;
import org.zeroturnaround.exec.ProcessExecutor;
import org.zeroturnaround.exec.stream.slf4j.Slf4jStream;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.ray1184.hpms.batch.commands.CommandRequest.END_DELIMITER;
import static org.ray1184.hpms.batch.commands.CommandRequest.START_DELIMITER;

@Slf4j
public class BlenderProcess {

    public static final int RETURN_OK = 0;

    public static final int RETURN_ERROR = 1;

    @SneakyThrows
    public ProcessResponse run(String pythonCode, String tmpFilePrefix) {
        BlenderContext ctx = BlenderContext.getInstance();
        Path tempFile = Files.createTempFile(tmpFilePrefix, ".py");
        Files.writeString(tempFile, pythonCode);
        String pythonFilePath = tempFile.toAbsolutePath().toString();
        String output = new ProcessExecutor().command(ctx.getBlenderExecPath(), "--background", ctx.getBlenderSourcePath(), "--python", pythonFilePath)//
                .redirectError(Slf4jStream.of(getClass()).asInfo())//
                .readOutput(true)//
                .execute()//
                .outputUTF8();
        Files.deleteIfExists(tempFile);
        if (!output.contains(START_DELIMITER) || !output.contains(END_DELIMITER)) {
            return new ProcessResponse(output, RETURN_ERROR);
        }
        output = output.substring(output.indexOf(START_DELIMITER) + 8, output.indexOf(END_DELIMITER));
        return new ProcessResponse(output.substring(1), RETURN_OK);

    }

    @Getter
    @Setter
    @AllArgsConstructor
    public static class ProcessResponse {
        private String content;
        private Integer retCode;
    }
}
