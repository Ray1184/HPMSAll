package org.ray1184.hpms.pngmapper.mapper;

import java.util.LinkedList;
import java.util.List;

public class LinkedChain<T extends LinkedChain.Linkable> {

    public interface Linkable {
        boolean isLinked();
        void setLinked(boolean linked);
    }

    public LinkedChain(List<T> unorderedData, ElementLinker<T> linker) {
        this.unorderedData = unorderedData;
        this.linker = linker;
        sortedData = new LinkedList<>();
    }

    @FunctionalInterface
    public interface ElementLinker<T> {
        boolean areLinked(T first, T second);
    }


    private ElementLinker<T> linker;
    private List<T> unorderedData;
    private List<T> sortedData;

    public List<T> build() {
        T first = unorderedData.get(0);
        sortedData.add(first);
        processRecursive(first);
        return sortedData;
    }

    private void processRecursive(T current) {
        unorderedData.stream()//
                .filter(d -> !sortedData.contains(d))//
                .forEach(d -> {
                    if (!current.isLinked() && linker.areLinked(current, d)) {
                        sortedData.add(d);
                        current.setLinked(true);
                        processRecursive(d);
                    }
                });
    }

}
