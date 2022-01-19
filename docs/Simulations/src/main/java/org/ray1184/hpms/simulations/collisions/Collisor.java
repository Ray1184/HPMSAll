package org.ray1184.hpms.simulations.collisions;

import processing.core.PApplet;
import processing.core.PVector;

import java.util.List;

public class Collisor {
        Actor actor;
        Polygon perimeter;
        List<Polygon> obstacles;
        BoundingCircle bc;
        PApplet applet;

        Collisor(Actor actor, Polygon perimeter, List<Polygon> obstacles, BoundingCircle bc, PApplet applet) {
            this.applet = applet;
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
            }
            else {
                PVector correctPosition = CollisionMath.correctPosition(actor.getPosition(), nextPos, cResp);
                bc.set(new PVector(correctPosition.x - actor.getSize().x / 2, correctPosition.y - actor.getSize().x / 2), bc.radius);
                // SAFE CHECK FOR CORNERS - se dopo la correzione si finisce nuovamente fuori perimetro o contro un ostacolo interno, si ripristina la posizione originale senza correzione
                CollisionResponse cResp2 = calcAnyCollision();
                if (cResp2.collided) {
                    bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), bc.radius);
                    System.out.println("Last was WRONG");
                } else {
                    System.out.println("Last was good");
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