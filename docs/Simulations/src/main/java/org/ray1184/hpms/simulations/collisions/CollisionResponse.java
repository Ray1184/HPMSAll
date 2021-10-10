package org.ray1184.hpms.simulations.collisions;

import processing.core.PVector;

public class CollisionResponse {
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