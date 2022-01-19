package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PVector;

import java.util.ArrayList;
import java.util.List;


public class CollisionTest extends PApplet {


    BoundingCircle bc;
    Polygon perimeter;
    List<Polygon> obstacles;
    Collisor collisor;
    float moveRatio;
    float rotRatio;


    public void settings() {
        size(1000, 600);
    }


    public void setup() {
        CollisionMath.papplet = this;
        bc = new BoundingCircle(new PVector(0, 0), 20, this);
        String objData = new String(PApplet.loadBytes(getClass().getClassLoader().getResourceAsStream("collision/Dummy_Scene.perimeter.obj")));
        String objData2 = new String(PApplet.loadBytes(getClass().getClassLoader().getResourceAsStream("collision/Dummy_Scene.obstacles.obj")));
        perimeter = Polygon.load(objData, 40, 500, 200, this).get(0);
        obstacles = new ArrayList<>(); // Polygon.load(objData2, 40, 500, 200, this);
        collisor = new Collisor(new Actor(this), perimeter, obstacles, bc, this);
        collisor.setPosition(new PVector(500, 300));
        noFill();
    }


    public void keyReleased() {
        if (key == PConstants.CODED) {
            switch (keyCode) {
                case PConstants.UP, PConstants.DOWN -> moveRatio = 0.0f;
                case PConstants.LEFT, PConstants.RIGHT -> rotRatio = 0.0f;
            }
        }
    }


    public void keyPressed() {
        if (key == PConstants.CODED) {
            switch (keyCode) {
                case PConstants.UP -> moveRatio = 3;
                case PConstants.DOWN -> moveRatio = -3;
                case PConstants.LEFT -> rotRatio = -0.1f;
                case PConstants.RIGHT -> rotRatio = 0.1f;
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
        for (final Polygon obstacle : obstacles) {
            obstacle.render();
        }
        collisor.render(moveRatio, rotRatio);
        popMatrix();
    }















    public static void main(final String[] passedArgs) {
        PApplet.main(new String[]{CollisionTest.class.getName()});
    }
}
