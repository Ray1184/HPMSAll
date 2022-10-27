package org.ray1184.hpms.pngmapper.mapper;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString
public class Coords implements LinkedChain.Linkable {
    private int x;
    private int y;
    private boolean linked;

    public Coords(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean nextTo(Coords o, int ratio) {
        int nx = x / ratio;
        int ny = y / ratio;
        int nOx = o.x / ratio;
        int nOy = o.y / ratio;
        return Math.abs(nx - nOx) <= 1 && Math.abs(ny - nOy) <= 1;
    }


}
