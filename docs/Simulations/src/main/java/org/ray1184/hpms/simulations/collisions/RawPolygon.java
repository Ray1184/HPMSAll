package org.ray1184.hpms.simulations.collisions;

import processing.core.PVector;

import java.util.List;

public class RawPolygon {

    RawPolygon(List<PVector> vertices, List<List<PVector>> sides) {
        this.vertices = vertices;
        this.sides = sides;
    }

    List<PVector> vertices;
    List<List<PVector>> sides;
}