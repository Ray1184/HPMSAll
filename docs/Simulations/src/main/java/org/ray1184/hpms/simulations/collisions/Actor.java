package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PShape;
import processing.core.PVector;

public class Actor {

        PVector SIZE = new PVector(20, 20);

        PVector AXIS = new PVector(0, 0, 1);
        PVector position;
        PVector dir;
        Quaternion rotation;

        PShape graphics;
        float currentRot;
        PApplet applet;

        Actor(final PApplet applet) {
            this.applet = applet;
            position = new PVector(0, 0);
            dir = new PVector(0, -1);
            rotation = new Quaternion();
            graphics = applet.loadShape("collision/arrow.svg");
            applet.shapeMode(PConstants.CENTER);
            graphics.rotate(0);
        }

        public void setPosition(PVector pos) {
            position.set(pos);
        }

        public PVector getSize() {
            return SIZE;
        }

        public void rotate(float ratio) {
            this.applet.pushMatrix();
            graphics.rotate(ratio);
            dir.rotate(ratio);
            this.applet.popMatrix();
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
            this.applet.shape(graphics, position.x, position.y, SIZE.x, SIZE.y);
        }
    }