package org.ray1184.hpms.batch;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

@Slf4j
public class HPMSRunner {


    @SneakyThrows

    public static void main(String[] args) {
        log.info("#########################################################");
        log.info("HPMS Batch STARTED");
        log.info("#########################################################");
        HPMSParams params = HPMSParams.build(args);
        log.info("Params:");
        Arrays.stream(params.getCmdParams()).forEach(o -> log.info(StringUtils.rightPad(o.getDescription() + " ", 45, "-") + "> " + (o.hasArg() ? o.getValue() : "Yes")));
        log.info("#########################################################");
        ExecutorService executor = Executors.newFixedThreadPool(1);
        Future<Integer> future = executor.submit(new HPMSProcess(params));
        Integer ret = future.get();
        log.info("#########################################################");
        log.info("HPMS Batch FINISHED");
        log.info("#########################################################");
        System.exit(ret);

    }
}
