def process():
    data = {'rooms': []}
    for room in bpy.context.scene.hpms_room_list:
        room_info = {'name': room.name, 'sectors': []}
        sectors = [sec for sec in bpy.data.objects if
                   sec.hpms_sector_obj_prop.sector and room.name == sec.hpms_current_room]
        for sec in sectors:
            cam_name = sec.hpms_current_cam
            cam = [obj for obj in bpy.data.objects if obj.fieldType == 'CAMERA' and obj.name == cam_name][0]
            r = cam.rotation_euler.to_quaternion()
            room_info['sectors'].append(
                {'id': sec.name, 'activeCamera': {'name': cam.name,
                                                  'position': {
                                                      'x': cam.location.x,
                                                      'y': cam.location.y,
                                                      'z': cam.location.z},
                                                  'rotation': {
                                                      'w': r.w,
                                                      'x': r.x,
                                                      'y': r.y,
                                                      'z': r.z,
                                                  }}, 'trigger': {}})
        data['rooms'].append(room_info)
    return data
