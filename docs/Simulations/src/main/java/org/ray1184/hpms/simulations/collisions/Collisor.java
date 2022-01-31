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
            List<CollisionResponse> cResp = calcAnyCollision();
            boolean inside = !anyCollision(cResp);
            if (inside) {
                actor.setPosition(nextPos);
            }
            else {
                if (!correctAndRetest(cResp.get(0), nextPos) && cResp.size() >= 2) {
                    System.out.println("----> SECOND HIT");
                    if (!correctAndRetest(cResp.get(1), nextPos)) {
                        System.out.println("------------------> STROKEEEE!");
                    }
                }
            }
        }

        public boolean correctAndRetest(CollisionResponse cResp0, PVector nextPos) {
            PVector correctPosition = CollisionMath.correctPosition(actor.getPosition(), nextPos, cResp0);
            bc.set(new PVector(correctPosition.x - actor.getSize().x / 2, correctPosition.y - actor.getSize().x / 2), bc.radius);
            // SAFE CHECK FOR CORNERS - se dopo la correzione si finisce nuovamente fuori perimetro o contro un ostacolo interno, si ripristina la posizione originale senza correzione
            List<CollisionResponse> cResp2 = calcAnyCollision();
            if (!cResp2.isEmpty()) {
                bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), bc.radius);
                return false;
            } else {
                actor.setPosition(correctPosition);
                return true;
            }
        }

        public List<CollisionResponse> calcAnyCollision() {
            List<CollisionResponse> cResp = perimeter.bcInside(bc);
            if (!anyCollision(cResp)) {
                for (Polygon obstacle : obstacles) {
                    cResp = obstacle.bcOutside(bc);
                    if (anyCollision(cResp)) {
                        return cResp;
                    }
                }
            }
            return cResp;
        }

        public boolean anyCollision(List<CollisionResponse> cResp) {
            for (CollisionResponse col : cResp) {
                if (col.collided) {
                    return true;
                }
            }
            return false;
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