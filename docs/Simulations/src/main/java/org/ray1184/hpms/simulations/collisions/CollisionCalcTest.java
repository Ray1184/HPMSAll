package org.ray1184.hpms.simulations.collisions;

import processing.core.PVector;

public class CollisionCalcTest {

    public static void main(String[] args) {
        PVector pa = new PVector(5.5f, 2.2f);
        PVector pb = new PVector(12, 3.5f);
        PVector center = new PVector(7, 2.8f);
        float rad = 0.24f;
        System.out.println("----------------- COLLISION RESPONSE --------------------");
        System.out.println(CollisionMath.intersections(pa, pb, center, rad, true));
        System.out.println("---------------------------------------------------------");
    }


}
