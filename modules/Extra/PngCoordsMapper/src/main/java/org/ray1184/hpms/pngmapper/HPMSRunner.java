package org.ray1184.hpms.pngmapper;

import lombok.SneakyThrows;
import org.ray1184.hpms.pngmapper.mapper.Coords;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.List;

public class HPMSRunner {

    @SneakyThrows
    public static void main(String[] args) {
        String path = "C:\\Users\\stron\\Desktop\\tmp\\sample.png";
        HPMSPngProcessor processor = new HPMSPngProcessor(ImageIO.read(new File(path)), 3f, "RDP");
        List<Coords> s = processor.map();
        BufferedImage bufferedImage = new BufferedImage(320, 200, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = bufferedImage.createGraphics();
        g2d.setBackground(Color.BLACK);
        BasicStroke bs = new BasicStroke(1);
        g2d.setStroke(bs);
        for (int i = 1; i < s.size(); i++) {
            Coords c1 = s.get(i - 1);
            Coords c2 = s.get(i);
            g2d.drawLine(c1.getX(), c1.getY(), c2.getX(), c2.getY());
        }
        Coords c1 = s.get(s.size() - 1);
        Coords c2 = s.get(0);
        g2d.drawLine(c1.getX(), c1.getY(), c2.getX(), c2.getY());

        File outputfile = new File("C:\\Users\\stron\\Desktop\\tmp\\sample-out.png");
        ImageIO.write(bufferedImage, "png", outputfile);
    }
}
