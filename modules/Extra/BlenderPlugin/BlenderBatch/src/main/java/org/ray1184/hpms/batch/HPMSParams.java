package org.ray1184.hpms.batch;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.cli.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Slf4j
public class HPMSParams {


    private final CommandLine cmd;

    private final Map<String, Object> sessionParams;

    private HPMSParams(CommandLine cmd) {
        this.cmd = cmd;
        sessionParams = new HashMap<>();
    }

    @SneakyThrows
    public static HPMSParams fromCmdLine(String[] args) {
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
        return Arrays.asList(cmd.getOptionValue("filter").split(","));
    }

    public boolean isRender() {
        return Boolean.parseBoolean(cmd.getOptionValue("render"));
    }

    public boolean isCleanup() {
        return Boolean.parseBoolean(cmd.getOptionValue("cleanup"));
    }

    public Option[] getCmdParams() {
        return cmd.getOptions();
    }

    public Map<String, Object> getSessionParams() {
        return sessionParams;
    }
}