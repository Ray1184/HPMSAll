package org.ray1184.hpms.pngmapper.mapper;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.SneakyThrows;

import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@EqualsAndHashCode(of = {"coords"})
public class PngPartition {

    private int[][] pixels;
    private boolean perimeter;
    private Coords coords;

    @SneakyThrows
    public static List<PngPartition> get(BufferedImage image, int size) {
        return get(image, size, false);
    }

    @SneakyThrows
    public static List<PngPartition> get(BufferedImage image, int size, boolean allPartitions) {
        List<PngPartition> partitions = new ArrayList<>();

        int width = image.getWidth();
        int height = image.getHeight();

        if (width % size != 0 || height % size != 0) {
            throw new Exception("Partition size doesn't fit into image (resolution must be a multiple of size)");
        }

        int rows = height / size;
        int cols = width / size;

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                PngPartition partition = get(image, j * size, i * size, size);
                if (allPartitions || partition.isPerimeter()) {
                    partitions.add(partition);
                }
            }
        }

        return partitions;
    }

    public static PngPartition get(BufferedImage image, int x, int y, int size) {
        boolean foundColor = false;
        boolean foundTransparent = false;
        int width = image.getWidth();
        int height = image.getHeight();
        Coords coords = new Coords(x + (size / 2), y + (size / 2));

        int limitX = x + size == width ? 0 : 1;
        int limitY = y + size == height ? 0 : 1;
        int[][] pixels = new int[size + limitX][size + limitY];
        for (int i = 0; i < size + limitX; i++) {
            for (int j = 0; j < size + limitY; j++) {
                pixels[i][j] = image.getRGB(x + i, y + j);
                int alpha = alpha(pixels[i][j]);
                foundColor |= alpha > 0;
                foundTransparent |= alpha == 0;
            }
        }
        return new PngPartition(pixels, foundColor && foundTransparent, coords);
    }

    private static int alpha(int rgb) {
        return (0xff & (rgb >> 24));
    }
}
