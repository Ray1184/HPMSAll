package org.ray1184.hpms.batch.tasks.utils;

import lombok.Getter;

import java.io.File;

public class FileSystem {

    private static final String RES_FOLDER = "resources";
    private static FileSystem instance;

    @Getter
    private String rootPath;

    private FileSystem() {
    }

    public static FileSystem getInstance() {
        if (instance == null) {
            instance = new FileSystem();
        }
        return instance;
    }

    public void init(String rootPath) {
        this.rootPath = rootPath;
    }

    public String toPath(Asset asset) {
        return rootPath + File.separator + RES_FOLDER + File.separator + asset.dir;
    }

    public String toPythonPath(Asset asset) {
        return toPath(asset).replace(File.separator, "/");
    }

    public File toFile(Asset asset) {
        return new File(toPath(asset));
    }

    public boolean createFolder(Asset asset) {
        return toFile(asset).mkdirs();
    }

    public File flagFile() {
        return new File(rootPath + File.separator + ".hpmsproj");
    }

    public boolean flagExists() {
        return flagFile().exists();
    }

    public boolean createFlagFile() {
        return flagFile().mkdirs();
    }

    public enum Asset {
        // @formatter:off
		FONTS("fonts"),
		MASKS("masks"),
		BACKGROUNDS("backgrounds"),
		OVERLAYS("overlays"),
		MODELS("models"),
		SCRIPTS("scripts"),
		WALKMAPS("walkmaps"),
		SOUNDS("sounds");
		// @formatter:on
        private final String dir;

        Asset(String dir) {
            this.dir = dir;
        }
    }


}
