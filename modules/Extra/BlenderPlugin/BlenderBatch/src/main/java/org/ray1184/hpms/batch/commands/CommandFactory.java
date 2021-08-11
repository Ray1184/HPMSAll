package org.ray1184.hpms.batch.commands;

public interface CommandFactory<R extends CommandRequest, S extends CommandResponse> {
    R getRequestInstance();

    S getResponseInstance();
}