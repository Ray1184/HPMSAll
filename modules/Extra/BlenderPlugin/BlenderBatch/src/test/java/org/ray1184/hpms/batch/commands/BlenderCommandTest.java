package org.ray1184.hpms.batch.commands;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.ray1184.hpms.batch.commands.impl.HPMSCommands;

import java.io.File;
import java.net.URL;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Slf4j
public class BlenderCommandTest {


   @Test
   public void testBlenderVersion() {
       initBlenderContext();
       testing("Blender Version");
       CommandResponse proc = HPMSCommands.BL_VERSION.exec();
       log.info("Test output: {}", proc.toString());
       assertEquals(0, (int) proc.getReturnCode());
   }

   @Test
   public void testSceneData() {
       initBlenderContext();
       testing("Scene Data");
       CommandResponse proc = HPMSCommands.SCENE_DATA.exec();
       log.info("Test output: {}", proc.toString());
       assertEquals(0, (int) proc.getReturnCode());
   }

    @Test
    public void testRendering() {
        initBlenderContext();
        testing("Rendering");
        CommandResponse proc = HPMSCommands.RENDERING//
                .param("CAMS_TO_RENDER", "CAM_01")//
                .param("OUTPUT_PATH", "/home/nick/renders/HPMS")//
                .exec();
        log.info("Test output: {}", proc.toString());
        assertEquals(0, (int) proc.getReturnCode());
    }

    @SneakyThrows
    private void initBlenderContext() {
        //URL res = getClass().getClassLoader().getResource("blend/HPMSScene.blend");
        //assert res != null;
        //File file = Paths.get(res.toURI()).toFile();
        String absolutePath = "/home/nick/projects/HPMSDesign/Media/World/Debug/ShootingRange.blend";
        BlenderContext ctx = BlenderContext.getInstance();
        ctx.setBlenderSourcePath(absolutePath);
        ctx.setBlenderExecPath("blender");
        ctx.setBlenderVersion("3.4.1");
        HPMSCommands.CLEAR_LOG.exec();
    }

    private void testing(String testName) {
        log.info("*******************************************************************");
        log.info("Starting test {}", testName);
        log.info("*******************************************************************");
    }
}
