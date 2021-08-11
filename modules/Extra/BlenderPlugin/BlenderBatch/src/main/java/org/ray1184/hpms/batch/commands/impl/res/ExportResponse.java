package org.ray1184.hpms.batch.commands.impl.res;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.ray1184.hpms.batch.commands.CommandResponse;

import java.util.List;

@Getter
@Setter
@ToString
public class ExportResponse extends CommandResponse {
    private List<String> outputs;

}
