package org.ray1184.hpms.simulations.collisions;

import processing.core.PVector;

import java.util.Objects;

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

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        final CollisionResponse that = (CollisionResponse) o;
        return this.collided == that.collided && Objects.equals(this.sideCollidedA, that.sideCollidedA) && Objects.equals(this.sideCollidedB, that.sideCollidedB);
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.collided, this.sideCollidedA, this.sideCollidedB);
    }
}