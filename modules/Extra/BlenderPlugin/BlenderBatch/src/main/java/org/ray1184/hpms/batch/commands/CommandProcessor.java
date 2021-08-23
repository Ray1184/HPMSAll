package org.ray1184.hpms.batch.commands;

import com.google.gson.Gson;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.batch.commands.blend.BlenderProcess;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;

@Slf4j
public class CommandProcessor {

    public static final Gson GSON = new Gson();

    private final CommandFactory<?, ?> commandFactory;

    private final String info;

    public CommandProcessor(CommandFactory<?, ?> commandFactory, String info) {
        this.commandFactory = commandFactory;
        this.info = info;
    }

    public CommandProcessor(CommandFactory<?, ?> commandFactory) {
        this(commandFactory, null);
    }

    @SneakyThrows
    public CommandResponse exec() {
        return exec(null);
    }

    @SneakyThrows
    public CommandResponse exec(Map<String, Object> params) {

        CommandRequest req = commandFactory.getRequestInstance();
        String scriptContent = req.buildScript(params);
        String commandName = info != null ? info : req.getClass().getSimpleName();
        log.debug("IN ---> Request command {} \n{}", commandName, scriptContent);
        if (BlenderContext.getInstance().isMock()) {
            return getMockResponse(req, commandName);
        }
        return getBlenderResponse(req, scriptContent, commandName);
    }

    @SneakyThrows
    private CommandResponse getMockResponse(CommandRequest req, String commandName) {
        String mockPath = "mocks/" + req.getScriptName() + ".json";
        URL res = getClass().getClassLoader().getResource(mockPath);
        assert res != null;
        String mockResponseContent = Files.readString(Paths.get(res.toURI()));
        BlenderProcess.ProcessResponse out = new BlenderProcess.ProcessResponse(mockResponseContent, BlenderProcess.RETURN_OK);
        log.debug("OUT <--- Response command (MOCK) {} {}", commandName, mockResponseContent);
        return serialize(commandFactory, out);
    }

    private CommandResponse getBlenderResponse(CommandRequest req, String scriptContent, String commandName) throws Exception {
        BlenderProcess process = new BlenderProcess();
        BlenderProcess.ProcessResponse out = process.run(scriptContent, req.getClass().getSimpleName());
        if (out.getRetCode() == BlenderProcess.RETURN_OK) {
            log.debug("OUT <--- Response command {} {}", commandName, out.getContent());
        } else {
            log.error("OUT <--- Partial response for diagnostics {} \n{}", commandName, out.getContent());
            throw new Exception("Wrong python code in command request");
        }
        return serialize(commandFactory, out);
    }

    private CommandResponse serialize(CommandFactory<?, ?> commandFactory, BlenderProcess.ProcessResponse out) {
        CommandResponse ret = GSON.fromJson(out.getContent(), commandFactory.getResponseInstance().getClass());
        ret.setReturnCode(out.getRetCode());
        return ret;
    }


}
