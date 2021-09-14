# Retrieve all scene logical structure

def process():
    data = {'rooms': []}
    for room in bpy.data.collections:
        room_info = {'name': room.name, 'objects': []}
        objects = get_hpms_objects(room.name)
        for obj in objects:
            object = {}
            type = obj['hpms_type']
            events = []
            if 'hpms_events' in obj:
                evt_names = obj['hpms_events'].split(',')
                for evt_name in evt_names:
                    events.append({'name': evt_name, 'params': obj[evt_name]})
            position = {'x': obj.location.x, 'y': obj.location.y, 'z': obj.location.z}
            quat_rot = obj.rotation_euler.to_quaternion()
            rotation = {
                'w': quat_rot.w,
                'x': quat_rot.x,
                'y': quat_rot.y,
                'z': quat_rot.z,
            }
            scale = {'x': obj.scale.x, 'y': obj.scale.y, 'z': obj.scale.z}
            room_info['objects'].append(
                {
                    'name': obj.name,
                    'type': type,
                    'position': position,
                    'rotation': rotation,
                    'scale': scale,
                    'events': events,
                }
            )

        data['rooms'].append(room_info)
        log(DEBUG, str(data))
    return data
