package org.ray1184.hpms.batch.commands;

import com.google.gson.Gson;
import org.junit.jupiter.api.Test;
import org.ray1184.hpms.batch.commands.impl.res.SceneDataResponse;

import java.util.Collections;

public class BlenderResponseMockTest {

    @Test
    public static void main() {
        SceneDataResponse resp = new SceneDataResponse();
        resp.setReturnCode(0);
        SceneDataResponse.RoomInfo r1 = new SceneDataResponse.RoomInfo();
        SceneDataResponse.RoomInfo.TriggerInfo t1 = new SceneDataResponse.RoomInfo.TriggerInfo();
        t1.setName("T01_TestTrigger");
        SceneDataResponse.RoomInfo.CollisionInfo c1 = new SceneDataResponse.RoomInfo.CollisionInfo();
        c1.setName("C01_TestCollision");
        SceneDataResponse.RoomInfo.DepthInfo d1 = new SceneDataResponse.RoomInfo.DepthInfo();
        d1.setName("D01_TestDepth");
        SceneDataResponse.RoomInfo.EntityInfo e1 = new SceneDataResponse.RoomInfo.EntityInfo();
        e1.setName("E01_TestPlayerEntity");
        e1.setCollisionBased(true);
        e1.setPosition(new SceneDataResponse.PositionInfo(0.5d, 1d, 0d));
        e1.setRotation(new SceneDataResponse.RotationInfo(1.0d, 0.3d, 0.1d, 1.5d));
        e1.setType(SceneDataResponse.RoomInfo.EntityInfo.Type.PLAYER);
        SceneDataResponse.RoomInfo.SectorInfo s1 = new SceneDataResponse.RoomInfo.SectorInfo();
        s1.setId("SG_01");
        SceneDataResponse.RoomInfo.SectorInfo.CameraInfo v1 = new SceneDataResponse.RoomInfo.SectorInfo.CameraInfo();
        v1.setName("CM_01");
        v1.setPosition(new SceneDataResponse.PositionInfo(1.5d, 5d, 1d));
        v1.setRotation(new SceneDataResponse.RotationInfo(0.0d, 0.5d, 0.15d, 1.8d));
        s1.setActiveCamera(v1);
        r1.setCollisionData(c1);
        r1.setDepthData(d1);
        r1.setEntities(Collections.singletonList(e1));
        r1.setTriggers(Collections.singletonList(t1));
        r1.setSectors(Collections.singletonList(s1));
        resp.setRooms(Collections.singletonList(r1));

        System.out.println(new Gson().toJson(resp, SceneDataResponse.class));

    }
}
