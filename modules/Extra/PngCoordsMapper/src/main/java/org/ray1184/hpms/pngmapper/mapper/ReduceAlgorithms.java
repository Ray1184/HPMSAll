package org.ray1184.hpms.pngmapper.mapper;

import java.util.ArrayList;
import java.util.List;

public enum ReduceAlgorithms {

    NONE {
        @Override
        public void simplify(List<Coords> pointList, float epsilon, List<Coords> out) {
            // DO NOTHING
        }
    },
    RDP {
        @Override
        public void simplify(List<Coords> pointList, float epsilon, List<Coords> out) {
            if (pointList.size() < 2) {
                throw new IllegalArgumentException("Not enough points to simplify");
            }

            float dmax = 0.0f;
            int index = 0;
            int end = pointList.size() - 1;
            for (int i = 1; i < end; ++i) {
                float d = perpendicularDistance(pointList.get(i), pointList.get(0), pointList.get(end));
                if (d > dmax) {
                    index = i;
                    dmax = d;
                }
            }

            if (dmax > epsilon) {
                List<Coords> recResults1 = new ArrayList<>();
                List<Coords> recResults2 = new ArrayList<>();
                List<Coords> firstLine = pointList.subList(0, index + 1);
                List<Coords> lastLine = pointList.subList(index, pointList.size());
                simplify(firstLine, epsilon, recResults1);
                simplify(lastLine, epsilon, recResults2);

                out.addAll(recResults1.subList(0, recResults1.size() - 1));
                out.addAll(recResults2);
                if (out.size() < 2) {
                    throw new RuntimeException("Problem assembling output");
                }
            } else {
                out.clear();
                out.add(pointList.get(0));
                out.add(pointList.get(pointList.size() - 1));
            }
        }
    };

    public abstract void simplify(List<Coords> data, float epsilon, List<Coords> out);


    private static float perpendicularDistance(Coords pt, Coords lineStart, Coords lineEnd) {
        float dx = lineEnd.getX() - lineStart.getX();
        float dy = lineEnd.getY() - lineStart.getY();

        float mag = (float) Math.hypot(dx, dy);
        if (mag > 0.0) {
            dx /= mag;
            dy /= mag;
        }
        float pvx = pt.getX() - lineStart.getX();
        float pvy = pt.getY() - lineStart.getY();

        float pvdot = dx * pvx + dy * pvy;

        float ax = pvx - pvdot * dx;
        float ay = pvy - pvdot * dy;

        return (float) Math.hypot(ax, ay);
    }
}
