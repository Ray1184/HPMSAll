package org.ray1184.hpms.batch.commands;

import lombok.Getter;
import lombok.Setter;
import lombok.SneakyThrows;

@Setter
@Getter
public class CommandBuilder {


    private CommandFactory<?, ?> commandFactory;
    private CommandRequest request;
    private CommandResponse response;
    private String info;


    public CommandProcessor build() {
        return new CommandProcessor(new CommandFactory<>() {
            @Override
            @SneakyThrows
            public CommandRequest getRequestInstance() {
                return request;
            }

            @Override
            @SneakyThrows
            public CommandResponse getResponseInstance() {
                return response;
            }
        }, info);
    }

    @SneakyThrows
    public CommandBuilder request(String resource, String scriptName) {
        this.request = new CommandRequestExternalResource(resource, scriptName);
        return this;
    }

    @SneakyThrows
    public CommandBuilder response(Class<? extends CommandResponse> response) {
        this.response = response.getConstructor().newInstance();
        return this;
    }

    public CommandBuilder info(String info) {
        this.info = info;
        return this;
    }




}

