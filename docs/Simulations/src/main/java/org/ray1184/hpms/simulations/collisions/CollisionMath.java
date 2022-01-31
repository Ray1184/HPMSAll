package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PMatrix3D;
import processing.core.PVector;

import java.awt.geom.Point2D;
import java.util.ArrayList;
import java.util.List;

public class CollisionMath {

    public static PApplet papplet; // debug only

    private static CollisionResponse lastCollision;

    /*public static CollisionResponse circleInsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        //boolean inside = CollisionMath.pointInsidePolygon(circle.origin, polygon, t);
        //if (!inside) {
        //    return new CollisionResponse();
        //}


        // After one side collision check always the next side.
        // If previus collision was on the second side, use this response (to avoid stroke on corners)
        List<CollisionResponse> resps = new ArrayList<>();
        for (int i = 0; i < polygon.length - 1; i++) {
            if (CollisionMath.circleLineIntersections(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
                resps.add(new CollisionResponse(true, polygon[i], polygon[i + 1]));
                if (resps.size() >= 2) {
                    break;
                }
            }
        }
        if (!resps.isEmpty()) {
            if (resps.size() == 1 || lastCollision == null) {
                lastCollision = resps.get(0);
            }

            if (resps.size() == 2) {
                if (lastCollision.equals(resps.get(0))) {
                    lastCollision = resps.get(0);
                } else {
                    lastCollision = resps.get(1);
                }
            }

            return lastCollision;
        }

        return new CollisionResponse();
    }*/

    public static List<CollisionResponse> circleInsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        return circleOutsidePolygon(circle, polygon, t);
    }

    public static List<CollisionResponse> circleOutsidePolygon(BoundingCircle circle, PVector[] polygon, PVector t) {
        //boolean inside = CollisionMath.pointInsidePolygon(circle.origin, polygon, t);
        //if (inside) {
        //    return new CollisionResponse();
        //}

        // After one side collision check always the next side.
        // If previus collision was on the second side, use this response (to avoid stroke on corners)
        List<CollisionResponse> resps = new ArrayList<>();
        for (int i = 0; i < polygon.length - 1; i++) {
            if (CollisionMath.circleLineIntersections(polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y, circle.origin.x, circle.origin.y, circle.radius)) {
                resps.add(new CollisionResponse(true, polygon[i], polygon[i + 1]));
                if (resps.size() >= 2) {
                    break;
                }
            }
        }
        /*if (!resps.isEmpty()) {
            if (resps.size() == 1 || lastCollision == null) {
                lastCollision = resps.get(0);
            }

            if (resps.size() == 2) {
                if (lastCollision.equals(resps.get(0))) {
                    lastCollision = resps.get(0);
                } else {
                    lastCollision = resps.get(1);
                }
            }

            return lastCollision;
        }*/
    return resps;
        //return new CollisionResponse();
    }



    //public static boolean pointInsidePolygon(PVector point, PVector[] polygon, PVector t) {
//
    //    float x = point.x - t.x;
    //    float y = point.y - t.y;
    //    int i, j = polygon.length - 1;
    //    boolean oddNodes = false;
//
    //    for (i = 0; i < polygon.length; i++) {
    //        if ((polygon[i].y < y && polygon[j].y >= y
    //                || polygon[j].y < y && polygon[i].y >= y)
    //                && (polygon[i].x <= x || polygon[j].x <= x)) {
    //            oddNodes ^= (polygon[i].x + (y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < x);
    //        }
    //        j = i;
    //    }
//
    //    return oddNodes;
    //}

    //public static boolean circleLineIntersect2(PVector pointA, PVector pointB, PVector center, float radius) {
    //    float baX = pointB.x - pointA.x;
    //    float baY = pointB.y - pointA.y;
    //    float caX = center.x - pointA.x;
    //    float caY = center.y - pointA.y;
//
    //    float a = baX * baX + baY * baY;
    //    float bBy2 = baX * caX + baY * caY;
    //    float c = caX * caX + caY * caY - radius * radius;
//
    //    float pBy2 = bBy2 / a;
    //    float q = c / a;
//
    //    float disc = pBy2 * pBy2 - q;
    //    if (disc < 0) {
    //        return false;
    //    }
    //    float tmpSqrt = PApplet.sqrt(disc);
    //    float abScalingFactor1 = -pBy2 + tmpSqrt;
    //    PVector pointC = new PVector(pointA.x - baX * abScalingFactor1, pointA.y - baY * abScalingFactor1);
    //    papplet.pushMatrix();
    //    papplet.fill(0, 255, 0);
    //    papplet.rect(pointC.x, pointC.y, 5, 5);
    //    papplet.noFill();
    //    papplet.popMatrix();
    //    return CollisionMath.isBetween(pointA, pointB, pointC);
    //}


    public static boolean circleLineIntersections(PVector pointA, PVector pointB, PVector center, float radius) {
        return intersections(pointA, pointB, center, radius, true);
    }

    public static PVector toPvector(Point2D p) {
        return new PVector((float) p.getX(), (float) p.getY());
    }

    public static Point2D toPoint(PVector p) {
        return new Point2D.Float(p.x, p.y);
    }

    public static boolean intersections(PVector p1, PVector p2, PVector center,
                                        double radius, boolean isSegment) {

        int numOfIntersections = 0;
        float dx = (float) (p2.x - p1.x);
        float dy = (float) (p2.y - p1.y);
        //System.out.println("DX: " + dx);
        //System.out.println("DY: " + dy);
        PMatrix3D mat = new PMatrix3D();
        //System.out.println("\nORIGINAL MATRIX:\n" + printMatrix(mat));
        mat.rotate((float) Math.atan2(dy, dx));
        //System.out.println("\nROTATED MATRIX:\n" + printMatrix(mat));
        mat.invert();
        //System.out.println("\nINVERTED MATRIX:\n" + printMatrix(mat));
        mat.translate((float) -center.x, (float) -center.y);
        //System.out.println("\nTRANSLATED MATRIX:\n" + printMatrix(mat));
        PVector p1a = new PVector();
        PVector p2a = new PVector();
        mat.mult(p1, p1a);
        //System.out.println("\nP1 * MATRIX: " + printVector(p1a));
        mat.mult(p2, p2a);
        //System.out.println("\nP2 * MATRIX: " + printVector(p2a));

        float y = (float) p1a.y;
        float minX = (float) Math.min(p1a.x, p2a.x);
        float maxX = (float) Math.max(p1a.x, p2a.x);
        if (y == radius || y == -radius) {
            if (0 <= maxX && 0 >= minX) {
                return true;
            }
        } else if (y < radius && y > -radius) {
            float x = (float) Math.sqrt(radius * radius - y * y);
            if ((-x <= maxX && -x >= minX)) {
                return true;
            }
            if (x <= maxX && x >= minX) {
                return true;
            }
        }
        return false;
    }


    private static boolean circleLineIntersect2(float x1, float y1, float x2, float y2, float cx, float cy, float cr) {
        float dx = x2 - x1;
        float dy = y2 - y1;
        float a = dx * dx + dy * dy;
        float b = 2 * (dx * (x1 - cx) + dy * (y1 - cy));
        float c = cx * cx + cy * cy;
        c += x1 * x1 + y1 * y1;
        c -= 2 * (cx * x1 + cy * y1);
        c -= cr * cr;
        float disc = b * b - 4 * a * c;
        if (disc < 0) {
            return false;
        }
        float tmpSqrt = PApplet.sqrt(disc);
        float abScalingFactor1 = -b + tmpSqrt;
        PVector pointC = new PVector(x1 - dx * abScalingFactor1, y1 - dy * abScalingFactor1);
        PVector pointA = new PVector(x1, y1);
        PVector pointB = new PVector(x2, y2);
        return CollisionMath.isBetween(pointA, pointB, pointC);

    }


    public static boolean isBetween(PVector pt1, PVector pt2, PVector pt) {

        final float epsilon = 0.01f;

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

    public static boolean circleLineIntersections(float x1, float y1, float x2, float y2, float cx, float cy, float cr) {
        return CollisionMath.circleLineIntersections(new PVector(x1, y1), new PVector(x2, y2), new PVector(cx, cy), cr);
    }


    public static PVector correctPosition(PVector prevPosition, PVector nextPosition, CollisionResponse cResp) {
        //glm::vec2 n = glm::normalize(Perpendicular(sideA - sideB));
        PVector n = perp(new PVector().set(cResp.sideCollidedA).sub(cResp.sideCollidedB)).normalize();
        //System.out.println("A: " + cResp.sideCollidedA + "  ---  B: " + cResp.sideCollidedB);

        //glm::vec3 v = nextPosition - actor->GetPosition();
        PVector v = new PVector().set(nextPosition).sub(prevPosition);

        //glm::vec2 vn = n * glm::dot(glm::vec2(SD(v), FW(v)), n);
        PVector vn = new PVector().set(n).mult(new PVector().set(v).dot(n));

        //glm::vec2 vt = glm::vec2(SD(v), FW(v)) - vn;
        PVector vt = new PVector().set(v).sub(vn);

        //*correctPosition = ADDV3_V2(actor->GetPosition(), vt);
        return new PVector().set(prevPosition).add(vt);

    }

    public static PVector perp(PVector in) {
        PVector perp = new PVector();
        perp.set(in.y, -in.x);
        return perp;
    }

    private static String printMatrix(PMatrix3D m)
    {

        return "[" + m.m00 + "]" + "[" + m.m01 + "]" + "[" + m.m02 + "]" + "[" + m.m03 + "]\n"
        + "[" + m.m10 + "]" + "[" + m.m11 + "]" + "[" + m.m12 + "]" + "[" + m.m13 + "]\n"
        + "[" + m.m20 + "]" + "[" + m.m21 + "]" + "[" + m.m22 + "]" + "[" + m.m23 + "]\n"
        + "[" + m.m30 + "]" + "[" + m.m31 + "]" + "[" + m.m32 + "]" + "[" + m.m33 + "]";
    }

    private static String printVector(PVector m)
    {

        return "[" + m.x + "]" + "[" + m.y + "]";
    }


}
