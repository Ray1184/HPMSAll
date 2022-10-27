package org.ray1184.hpms.pngmapper;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.ray1184.hpms.pngmapper.mapper.LinkedChain;
import org.ray1184.hpms.pngmapper.mapper.Coords;
import org.ray1184.hpms.pngmapper.mapper.PngPartition;
import org.ray1184.hpms.pngmapper.mapper.ReduceAlgorithms;

import java.awt.image.BufferedImage;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
public class HPMSPngProcessor {

    private final BufferedImage image;
    private final float epsilon;
    private final ReduceAlgorithms reducer;
    private static final int GRID_SIZE = 2;

    public HPMSPngProcessor(BufferedImage image, float epsilon) {
        this(image, epsilon, ReduceAlgorithms.NONE.name());
    }
    @SneakyThrows
    public HPMSPngProcessor(BufferedImage image, float epsilon, String reduceAlgorithm) {
        this.image = image;
        this.epsilon = epsilon;
        reducer = ReduceAlgorithms.valueOf(reduceAlgorithm);
    }


    public List<Coords> map() {
        List<PngPartition> partitions = PngPartition.get(image, GRID_SIZE);
        List<Coords> sortedCoords = sortByNearest(partitions.stream().map(PngPartition::getCoords).collect(Collectors.toList()));
        List<Coords> simplifiedCoords = new LinkedList<>();
        reducer.simplify(sortedCoords, epsilon, simplifiedCoords);
        return simplifiedCoords;
    }

    private List<Coords> sortByNearest(List<Coords> coords) {
        LinkedChain<Coords> coordsChain = new LinkedChain<>(coords, (first, second) -> first.nextTo(second, GRID_SIZE));
        return coordsChain.build();
    }

}
