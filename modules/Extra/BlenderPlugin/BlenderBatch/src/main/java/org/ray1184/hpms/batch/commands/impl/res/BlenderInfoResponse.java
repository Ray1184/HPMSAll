package org.ray1184.hpms.batch.commands.impl.res;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.ray1184.hpms.batch.commands.CommandResponse;

@Getter
@Setter
@ToString
public class BlenderInfoResponse extends CommandResponse {
    private String version;

}
