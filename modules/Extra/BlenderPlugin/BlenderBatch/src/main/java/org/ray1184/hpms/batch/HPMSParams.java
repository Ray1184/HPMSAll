package org.ray1184.hpms.batch;

import lombok.Getter;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.cli.*;

import java.util.*;


@Slf4j
public class HPMSParams {


    private final CommandLine cmd;
    @Getter
    private final Map<String, Object> sessionParams;
    private final Map<IniParam, Object> iniParams;

    private HPMSParams(CommandLine cmd) {
        this.cmd = cmd;
        sessionParams = new HashMap<>();
        iniParams = loadIniParams();
    }

    @SneakyThrows
    public static HPMSParams build(String[] args) {
        Options options = new Options();
        options.addOption(Option.builder("e").longOpt("exe").hasArg(true).required(true).desc("Blender runtime exec path").build());
        options.addOption(Option.builder("b").longOpt("blend").hasArg(true).required(true).desc("Blender source file").build());
        options.addOption(Option.builder("o").longOpt("output").hasArg(true).required(true).desc("Output directory").build());
        options.addOption(Option.builder("s").longOpt("sysres").hasArg(true).required(true).desc("System binaries and resources directory").build());
        options.addOption(Option.builder("r").longOpt("render").hasArg(false).required(false).desc("Render views").build());
        options.addOption(Option.builder("c").longOpt("cleanup").hasArg(false).required(false).desc("Cleanup project instead of update").build());
        options.addOption(Option.builder("f").longOpt("filter").hasArg(true).required(false).desc("Filter on set on rooms (comma separated)").build());
        options.addOption(Option.builder("n").longOpt("name").hasArg(true).required(false).desc("Project and runtime name").build());

        CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        try {
            return new HPMSParams(parser.parse(options, args));
        } catch (ParseException e) {
            log.error(e.toString());
            formatter.printHelp("HPMSBatch", options);
            throw e;
        }
    }

    @SneakyThrows
    private Map<IniParam, Object> loadIniParams() {
        Map<IniParam, Object> ini = new HashMap<>();
        Properties props = new Properties();
        props.load(getClass().getClassLoader().getResourceAsStream("batch.ini"));
        for (IniParam iniParam : IniParam.values()) {
            ini.put(iniParam, props.get(iniParam.name()));
        }
        return ini;
    }

    public String getRuntimeExe() {
        return cmd.getOptionValue("exe");
    }

    public String getBlendFilePath() {
        return cmd.getOptionValue("blend");
    }

    public String getOutputPath() {
        return cmd.getOptionValue("output");
    }

    public String getSysResPath() {
        return cmd.getOptionValue("sysres");
    }

    public String getProjectName() {
        return cmd.getOptionValue("name");
    }

    public List<String> getFilterRooms() {
        String tokens = cmd.getOptionValue("filter");
        if (tokens == null) {
            return new ArrayList<>();
        }
        return Arrays.asList(tokens.split(","));
    }

    public boolean isRender() {
        return cmd.hasOption("render");
    }

    public boolean isCleanup() {
        return cmd.hasOption("cleanup");
    }

    public Option[] getCmdParams() {
        return cmd.getOptions();
    }

    public Object getIniParam(IniParam param) {
        return iniParams.get(param);
    }

    public enum IniParam {
        SCRIPTS_VERSION,
        CAM_FOVY,
        CAM_NEAR,
        CAM_FAR,
        MOCK,
        DEPENDENCIES
    }
}