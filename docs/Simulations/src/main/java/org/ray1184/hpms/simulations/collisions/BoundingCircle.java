package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PVector;

public class BoundingCircle {
        PVector origin;
        float radius;
        PApplet applet;

        BoundingCircle(PVector origin, float radius, final PApplet applet) {
            this.origin = new PVector(0, 0);
            this.origin.set(origin);
            this.radius = radius;
            this.applet = applet;
        }


        public void set(PVector origin, float radius) {
            this.origin.set(origin);
            this.radius = radius;
        }

        public void render() {
            this.applet.ellipseMode(PConstants.CENTER);
            this.applet.ellipse(origin.x, origin.y, radius * 2, radius * 2);
        }
    }