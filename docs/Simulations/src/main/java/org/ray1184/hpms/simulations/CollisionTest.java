package org.ray1184.hpms.simulations;

import processing.core.*;

import java.util.ArrayList;
import java.util.List;



public class CollisionTest extends PApplet {


    BoundingCircle bc;
    Polygon perimeter;
    List<Polygon> obstacles;
    Collisor collisor;
    float moveRatio = 0;
    float rotRatio = 0;


    public void setup() {
        /* size commented out by preprocessor */
        ;
        bc = new BoundingCircle(new PVector(0, 0), 30);
        String objData = new String(loadBytes("perimeter.obj"));
        String objData2 = new String(loadBytes("obstacles.obj"));
        perimeter = new Polygon(objData, 40, 500, 100);
        Polygon obstacle = new Polygon(objData2, 40, 500, 100);
        obstacles = new ArrayList<Polygon>();
        obstacles.add(obstacle);
        collisor = new Collisor(new Actor(), perimeter, obstacles, bc);
        collisor.setPosition(new PVector(400, 200));
        noFill();
        /* noSmooth commented out by preprocessor */
        ;
    }


    public void keyReleased() {
        if (key == CODED) {
            switch (keyCode) {
                case UP:
                case DOWN:
                    moveRatio = 0.0f;
                    break;
                case LEFT:
                case RIGHT:
                    rotRatio = 0.0f;
                    break;
            }
        }
    }


    public void keyPressed() {
        if (key == CODED) {
            switch (keyCode) {
                case UP:
                    moveRatio = 3;
                    break;
                case DOWN:
                    moveRatio = -3;
                    break;
                case LEFT:
                    rotRatio = -0.1f;
                    break;
                case RIGHT:
                    rotRatio = 0.1f;
                    break;
            }
        }
    }

    public void draw() {
        background(0);
        stroke(255);
        strokeWeight(1);

        pushMatrix();
        stroke(255);
        strokeWeight(1);
        perimeter.render();
        for (Polygon obstacle : obstacles) {
            obstacle.render();
        }
        collisor.render(moveRatio, rotRatio);
        popMatrix();
    }

    class Actor {

        PVector SIZE = new PVector(20, 20);

        PVector AXIS = new PVector(0, 0, 1);
        PVector position;
        PVector dir;
        Quaternion rotation;

        PShape graphics;
        float currentRot;

        Actor() {

            position = new PVector(0, 0);
            dir = new PVector(0, -1);
            rotation = new Quaternion();
            graphics = loadShape("arrow.svg");
            shapeMode(CENTER);
            graphics.rotate(0);
        }

        public void setPosition(PVector pos) {
            position.set(pos);
        }

        public PVector getSize() {
            return SIZE;
        }

        public void rotate(float ratio) {
            pushMatrix();
            graphics.rotate(ratio);
            dir.rotate(ratio);
            popMatrix();
        }

        public PVector getPosition() {
            return position;
        }

        public PVector getDir() {
            return dir;
        }


        public void move(float ratio) {
            position.add(ratio * dir.x, ratio * dir.y);
        }


        public void render(float moveRatio, float rotRatio) {
            rotate(rotRatio);
            shape(graphics, position.x, position.y, SIZE.x, SIZE.y);
        }
    }

    class BoundingCircle {
        PVector origin;
        float radius;

        BoundingCircle(PVector origin, float radius) {
            this.origin = new PVector(0, 0);
            this.origin.set(origin);
            this.radius = radius;
        }


        public void set(PVector origin, float radius) {
            this.origin.set(origin);
            this.radius = radius;
        }

        public void render() {
            ellipseMode(CENTER);
            ellipse(origin.x, origin.y, radius * 2, radius * 2);
        }
    }

    public static CollisionResponse circleInsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        boolean inside = pointInsidePolygon(circle.origin, polygon, t);
        if (!inside) {
            return new CollisionResponse();
        }


        for (int i = 0; i < polygon.length - 1; i++) {
            if (circleLineIntersect(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
                return new CollisionResponse(true, polygon[i], polygon[i + 1]);
            }
        }

        return new CollisionResponse();
    }

    public static CollisionResponse circleOutsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        boolean inside = pointInsidePolygon(circle.origin, polygon, t);
        if (inside) {
            return new CollisionResponse();
        }


        for (int i = 0; i < polygon.length - 1; i++) {
            if (circleLineIntersect(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
                return new CollisionResponse(true, polygon[i], polygon[i + 1]);
            }
        }

        return new CollisionResponse();
    }

    public static boolean pointInsidePolygon(PVector point, PVector[] polygon, PVector t) {

        float x = point.x - t.x;
        float y = point.y - t.y;
        int i, j = polygon.length - 1;
        boolean oddNodes = false;

        for (i = 0; i < polygon.length; i++) {
            if ((polygon[i].y < y && polygon[j].y >= y
                    || polygon[j].y < y && polygon[i].y >= y)
                    && (polygon[i].x <= x || polygon[j].x <= x)) {
                oddNodes ^= (polygon[i].x + (y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < x);
            }
            j = i;
        }

        return oddNodes;
    }

    public static boolean circleLineIntersect(PVector pointA, PVector pointB, PVector center, float radius) {
        float baX = pointB.x - pointA.x;
        float baY = pointB.y - pointA.y;
        float caX = center.x - pointA.x;
        float caY = center.y - pointA.y;

        float a = baX * baX + baY * baY;
        float bBy2 = baX * caX + baY * caY;
        float c = caX * caX + caY * caY - radius * radius;

        float pBy2 = bBy2 / a;
        float q = c / a;

        float disc = pBy2 * pBy2 - q;
        if (disc < 0) {
            return false;
        }
        float tmpSqrt = sqrt(disc);
        float abScalingFactor1 = -pBy2 + tmpSqrt;
        PVector pointC = new PVector(pointA.x - baX * abScalingFactor1, pointA.y - baY * abScalingFactor1);
        return isBetween(pointA, pointB, pointC);
    }

    public static boolean isBetween(PVector pt1, PVector pt2, PVector pt) {

        float epsilon = 0.001f;

        if (pt.x - max(pt1.x, pt2.x) > epsilon ||
                min(pt1.x, pt2.x) - pt.x > epsilon ||
                pt.y - max(pt1.y, pt2.y) > epsilon ||
                min(pt1.y, pt2.y) - pt.y > epsilon)
            return false;

        if (abs(pt2.x - pt1.x) < epsilon)
            return abs(pt1.x - pt.x) < epsilon || abs(pt2.x - pt.x) < epsilon;
        if (abs(pt2.y - pt1.y) < epsilon)
            return abs(pt1.y - pt.y) < epsilon || abs(pt2.y - pt.y) < epsilon;

        float x = pt1.x + (pt.y - pt1.y) * (pt2.x - pt1.x) / (pt2.y - pt1.y);
        float y = pt1.y + (pt.x - pt1.x) * (pt2.y - pt1.y) / (pt2.x - pt1.x);

        return abs(pt.x - x) < epsilon || abs(pt.y - y) < epsilon;
    }

    public static boolean circleLineIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr) {
        return circleLineIntersect(new PVector(x1, y1), new PVector(x2, y2), new PVector(cx, cy), cr);
    }

    public static PVector correctPosition(PVector prevPosition, PVector nextPosition, CollisionResponse cResp) {
        PVector dir = nextPosition.copy().sub(prevPosition);
        PVector side = cResp.sideCollidedB.copy().sub(cResp.sideCollidedA);
        float alpha = PVector.angleBetween(side, dir);
        float mag = dir.mag() * cos(alpha);
        PVector slide = side.copy().normalize().mult(mag);
        PVector correctPosition = prevPosition.copy().add(slide);
        return correctPosition;
    }

    public static PVector perp(PVector in) {
        PVector perp = new PVector();
        perp.set(in.y, -in.x);
        return perp;
    }

    static class CollisionResponse {
        boolean collided;
        PVector sideCollidedA;
        PVector sideCollidedB;

        CollisionResponse() {
            collided = false;
        }


        CollisionResponse(boolean collided, PVector sideCollidedA, PVector sideCollidedB) {
            this.collided = collided;
            this.sideCollidedA = sideCollidedA;
            this.sideCollidedB = sideCollidedB;
        }
    }

    class Collisor {
        Actor actor;
        Polygon perimeter;
        List<Polygon> obstacles;
        BoundingCircle bc;


        Collisor(Actor actor, Polygon perimeter, List<Polygon> obstacles, BoundingCircle bc) {
            this.bc = bc;
            this.actor = actor;
            this.perimeter = perimeter;
            this.obstacles = obstacles;
        }

        public void setPosition(PVector pos) {
            actor.setPosition(pos);
        }

        public void rotate(float ratio) {
            actor.rotate(ratio);
        }

        public void move(float ratio) {
            PVector nextPos = actor.getPosition().copy();
            PVector dir = actor.getDir();
            nextPos.add(ratio * dir.x, ratio * dir.y);
            bc.set(new PVector(nextPos.x - actor.getSize().x / 2, nextPos.y - actor.getSize().x / 2), bc.radius);
            CollisionResponse cResp = calcAnyCollision();
            boolean inside = !cResp.collided;
            if (inside) {
                actor.setPosition(nextPos);
            } else {
                PVector correctPosition = correctPosition(actor.getPosition(), nextPos, cResp);
                bc.set(new PVector(correctPosition.x - actor.getSize().x / 2, correctPosition.y - actor.getSize().x / 2), bc.radius);
                // SAFE CHECK FOR CORNERS - se dopo la correzione si finisce nuovamente fuori perimetro o contro un ostacolo interno, si ripristina la posizione originale senza correzione
                if (calcAnyCollision().collided) {
                    bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), bc.radius);
                } else {
                    actor.setPosition(correctPosition);
                }
            }
        }

        public CollisionResponse calcAnyCollision() {
            CollisionResponse cResp = perimeter.bcInside(bc);
            if (!cResp.collided) {
                for (Polygon obstacle : obstacles) {
                    cResp = obstacle.bcOutside(bc);
                    if (cResp.collided) {
                        return cResp;
                    }
                }
            }
            return cResp;
        }

        public BoundingCircle getBc() {
            return bc;
        }

        public void render(float moveRatio, float rotRatio) {
            move(moveRatio);
            actor.render(moveRatio, rotRatio);
            bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), bc.radius);
            bc.render();
        }
    }

    public static List<Polygon> load(String data, float factor, float tx, float ty) {
        List<Polygon> polys = new ArrayList<Polygon>();

        return polys;
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
                case 'v':
                    vertices.add(new PVector(Float.parseFloat(tokens[0]) * factor + tx, Float.parseFloat(tokens[1]) * factor + ty, Float.parseFloat(tokens[2]) * factor));
                    break;
                case 'l':
                    sides.add(new PVector(Integer.parseInt(tokens[0]), Integer.parseInt(tokens[1])));
                    break;
            }
        }

        return null;//new RawPolygon(vertices, sides);
    }

    public static PVector[] loadSortedSizesObj(String data, float factor, float tx, float ty) {
        RawPolygon polyData = loadPolysData(data, factor, tx, ty);
        List<PVector> sortedData = new ArrayList<PVector>();
        List<PVector> vertices = polyData.vertices;
        List<PVector> sides = polyData.sides;
        assert (sides.size() > 2); // at least a triangle
        Integer first = PApplet.parseInt(sides.get(0).x);
        Integer second = PApplet.parseInt(sides.get(0).y);
        PVector vertA = vertices.get(first - 1);
        PVector vertB = vertices.get(second - 1);
        Integer lastIndex = second;
        sortedData.add(vertA);
        sortedData.add(vertB);

        for (int i = 1; i < sides.size(); i++) {
            Integer next = getNextIndex(lastIndex, sides);
            PVector vert = vertices.get(next - 1);
            sortedData.add(vert);
            lastIndex = next;
        }


        return sortedData.toArray(new PVector[sortedData.size()]);
    }

    public static Integer getNextIndex(Integer index, List<PVector> sides) {

        for (PVector side : sides) {
            if (PApplet.parseInt(side.x) == index) {
                return PApplet.parseInt(side.y);
            }
        }
        println("SIDE NOT FOUND WITH INDEX " + index);
        return null;
    }

    class RawPolygon {

        RawPolygon(List<PVector> vertices, List<PVector> sides) {
            this.vertices = vertices;
            this.sides = sides;
        }

        List<PVector> vertices;
        List<PVector> sides;
    }

    class Polygon {

        PVector[] perimeter;

        Polygon(String data, float factor, float tx, float ty) {
            perimeter = loadSortedSizesObj(data, factor, tx, ty);
        }


        public CollisionResponse bcOutside(BoundingCircle bc) {
            return circleOutsidePolygon(bc, perimeter, new PVector(0, 0));
        }

        public CollisionResponse bcInside(BoundingCircle bc) {
            return circleInsidePolygon(bc, perimeter, new PVector(0, 0));
        }

        public void render() {
            for (int i = 0; i < perimeter.length - 1; i++) {
                line((perimeter[i].x), (perimeter[i].y), (perimeter[i + 1].x), (perimeter[i + 1].y));
            }
        }
    }

    public class Quaternion {

        public float x, y, z, w;

        public Quaternion() {
            x = y = z = 0;
            w = 1;
        }

        public Quaternion(float _x, float _y, float _z, float _w) {
            x = _x;
            y = _y;
            z = _z;
            w = _w;
        }

        public Quaternion(float angle, PVector axis) {
            setAngleAxis(angle, axis);
        }

        public Quaternion get() {
            return new Quaternion(x, y, z, w);
        }

        public Boolean equal(Quaternion q) {
            return x == q.x && y == q.y && z == q.z && w == q.w;
        }

        public void set(float _x, float _y, float _z, float _w) {
            x = _x;
            y = _y;
            z = _z;
            w = _w;
        }

        public void setAngleAxis(float angle, PVector axis) {
            axis.normalize();
            float hcos = cos(angle / 2);
            float hsin = sin(angle / 2);
            w = hcos;
            x = axis.x * hsin;
            y = axis.y * hsin;
            z = axis.z * hsin;
        }

        public Quaternion conj() {
            Quaternion ret = new Quaternion();
            ret.x = -x;
            ret.y = -y;
            ret.z = -z;
            ret.w = w;
            return ret;
        }

        public Quaternion mult(float r) {
            Quaternion ret = new Quaternion();
            ret.x = x * r;
            ret.y = y * r;
            ret.z = z * r;
            ret.w = w * w;
            return ret;
        }

        public Quaternion mult(Quaternion q) {
            Quaternion ret = new Quaternion();
            ret.x = q.w * x + q.x * w + q.y * z - q.z * y;
            ret.y = q.w * y - q.x * z + q.y * w + q.z * x;
            ret.z = q.w * z + q.x * y - q.y * x + q.z * w;
            ret.w = q.w * w - q.x * x - q.y * y - q.z * z;
            return ret;
        }


        public PVector mult(PVector v) {
            float px = (1 - 2 * y * y - 2 * z * z) * v.x +
                    (2 * x * y - 2 * z * w) * v.y +
                    (2 * x * z + 2 * y * w) * v.z;

            float py = (2 * x * y + 2 * z * w) * v.x +
                    (1 - 2 * x * x - 2 * z * z) * v.y +
                    (2 * y * z - 2 * x * w) * v.z;

            float pz = (2 * x * z - 2 * y * w) * v.x +
                    (2 * y * z + 2 * x * w) * v.y +
                    (1 - 2 * x * x - 2 * y * y) * v.z;

            return new PVector(px, py, pz);
        }

        public void normalize() {
            float len = w * w + x * x + y * y + z * z;
            float factor = 1.0f / sqrt(len);
            x *= factor;
            y *= factor;
            z *= factor;
            w *= factor;
        }
    }


    public void settings() {
        size(1000, 600);
        noSmooth();
    }

    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[]{"CollisionTest"};
        if (passedArgs != null) {
            PApplet.main(concat(appletArgs, passedArgs));
        } else {
            PApplet.main(appletArgs);
        }
    }
}
