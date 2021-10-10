package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PVector;

public class CollisionMath {


    public static CollisionResponse circleInsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        boolean inside = CollisionMath.pointInsidePolygon(circle.origin, polygon, t);
        if (!inside) {
            return new CollisionResponse();
        }


        for (int i = 0; i < polygon.length - 1; i++) {
            if (CollisionMath.circleLineIntersect(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
                return new CollisionResponse(true, polygon[i], polygon[i + 1]);
            }
        }

        return new CollisionResponse();
    }

    public static CollisionResponse circleOutsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        boolean inside = CollisionMath.pointInsidePolygon(circle.origin, polygon, t);
        if (inside) {
            return new CollisionResponse();
        }


        for (int i = 0; i < polygon.length - 1; i++) {
            if (CollisionMath.circleLineIntersect(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
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
        float tmpSqrt = PApplet.sqrt(disc);
        float abScalingFactor1 = -pBy2 + tmpSqrt;
        PVector pointC = new PVector(pointA.x - baX * abScalingFactor1, pointA.y - baY * abScalingFactor1);
        return CollisionMath.isBetween(pointA, pointB, pointC);
    }

    public static boolean isBetween(PVector pt1, PVector pt2, PVector pt) {

        final float epsilon = 0.001f;

        if (pt.x - PApplet.max(pt1.x, pt2.x) > epsilon ||
                PApplet.min(pt1.x, pt2.x) - pt.x > epsilon ||
                pt.y - PApplet.max(pt1.y, pt2.y) > epsilon ||
                PApplet.min(pt1.y, pt2.y) - pt.y > epsilon)
            return false;

        if (PApplet.abs(pt2.x - pt1.x) < epsilon)
            return PApplet.abs(pt1.x - pt.x) < epsilon || PApplet.abs(pt2.x - pt.x) < epsilon;
        if (PApplet.abs(pt2.y - pt1.y) < epsilon)
            return PApplet.abs(pt1.y - pt.y) < epsilon || PApplet.abs(pt2.y - pt.y) < epsilon;

        float x = pt1.x + (pt.y - pt1.y) * (pt2.x - pt1.x) / (pt2.y - pt1.y);
        float y = pt1.y + (pt.x - pt1.x) * (pt2.y - pt1.y) / (pt2.x - pt1.x);

        return PApplet.abs(pt.x - x) < epsilon || PApplet.abs(pt.y - y) < epsilon;
    }

    public static boolean circleLineIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr) {
        return CollisionMath.circleLineIntersect(new PVector(x1, y1), new PVector(x2, y2), new PVector(cx, cy), cr);
    }

    public static PVector correctPosition(PVector prevPosition, PVector nextPosition, CollisionResponse cResp) {
        PVector dir = nextPosition.copy().sub(prevPosition);
        PVector side = cResp.sideCollidedB.copy().sub(cResp.sideCollidedA);
        float alpha = PVector.angleBetween(side, dir);
        float mag = dir.mag() * PApplet.cos(alpha);
        PVector slide = side.copy().normalize().mult(mag);
        PVector correctPosition = prevPosition.copy().add(slide);
        return correctPosition;
    }

    public static PVector perp(PVector in) {
        PVector perp = new PVector();
        perp.set(in.y, -in.x);
        return perp;
    }


}
