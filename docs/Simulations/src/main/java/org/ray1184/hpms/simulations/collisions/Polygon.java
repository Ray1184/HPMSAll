package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Polygon {

    PVector[] perimeter;
    PApplet applet;

    Polygon(final PVector[] perimeter, final PApplet applet) {
        this.applet = applet;
        this.perimeter = perimeter;
    }


    public List<CollisionResponse> bcOutside(BoundingCircle bc) {
        return CollisionMath.circleOutsidePolygon(bc, perimeter, new PVector(0, 0));
    }

    public List<CollisionResponse> bcInside(BoundingCircle bc) {
        return CollisionMath.circleInsidePolygon(bc, perimeter, new PVector(0, 0));
    }

    public void render() {
        for (int i = 0; i < perimeter.length - 1; i++) {
            this.applet.line((perimeter[i].x), (perimeter[i].y), (perimeter[i + 1].x), (perimeter[i + 1].y));
        }
    }

    public static RawPolygon loadPolysData(String data, float factor, float tx, float ty) {

        String[] lines = data.split("\n");

        List<PVector> vertices = new ArrayList<PVector>();
        List<PVector> sides = new ArrayList<PVector>();
        for (String line : lines) {
            char type = line.charAt(0);
            String content = line.substring(2).trim();
            String[] tokens = content.split(" ");
            switch (type) {
                case 'v' -> vertices.add(new PVector(Float.parseFloat(tokens[0]) * factor + tx, Float.parseFloat(tokens[1]) * factor + ty, Float.parseFloat(tokens[2]) * factor));
                case 'l' -> sides.add(new PVector(Integer.parseInt(tokens[0]), Integer.parseInt(tokens[1])));
            }
        }

        return new RawPolygon(vertices, splitSides(sides));
    }


    private static List<List<PVector>> splitSides(List<PVector> sides) {

        sides.sort((o1, o2) -> (int) (o1.x - o2.x));
        List<PVector> refSides = new ArrayList<>(sides);
        List<List<PVector>> splittedSides = new ArrayList<>();
        List<PVector> subSides = null;
        PVector next = null;
        while (!refSides.isEmpty()) {
            subSides = new ArrayList<>();
            splittedSides.add(subSides);
            while ((next = getNextIndex(next, refSides)) != null) {
                subSides.add(next);
                refSides.remove(next);
            }
        }


        return splittedSides;
    }

    public static List<Polygon> load(String data, float factor, float tx, float ty, final PApplet applet) {
        RawPolygon polyData = Polygon.loadPolysData(data, factor, tx, ty);
        List<Polygon> polygons = new ArrayList<>();
        for (List<PVector> sides : polyData.sides) {
            List<PVector> sortedData = new ArrayList<PVector>();
            List<PVector> vertices = polyData.vertices;
            assert (sides.size() > 2); // at least a triangle
            Integer first = PApplet.parseInt(sides.get(0).x);
            Integer second = PApplet.parseInt(sides.get(0).y);
            PVector vertA = vertices.get(first - 1);
            PVector vertB = vertices.get(second - 1);
            PVector lastIndex = sides.get(0);
            sortedData.add(vertA);
            sortedData.add(vertB);

            for (int i = 1; i < sides.size(); i++) {
                PVector next = Polygon.getNextIndex(lastIndex, sides);
                PVector vert = vertices.get((int) (next.y - 1));
                sortedData.add(vert);
                lastIndex = next;
            }
            polygons.add(new Polygon(sortedData.toArray(new PVector[sortedData.size()]), applet));
        }
        return polygons;
    }

    public static PVector getNextIndex(PVector current, List<PVector> sides) {
        if (current == null) {
            return sides.get(0);
        }
        for (PVector side : sides) {
            if (PApplet.parseInt(side.x) == current.y) {
                return side;
            }
        }
        PApplet.println("SIDE NOT FOUND WITH INDEX " + current.y);
        return null;
    }
}