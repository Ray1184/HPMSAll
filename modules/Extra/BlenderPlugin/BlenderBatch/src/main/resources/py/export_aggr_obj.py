# Export OBJ files on filesystem

# Mandatory params
OUTPUT_PATH = $OUTPUT_PATH
ITEMS_TO_AGGREGATE = $ITEMS_TO_AGGREGATE
FILE_NAME = $FILE_NAME

# Export properties
COLLECTION_NAME = $COLLECTION_NAME or None
FORWARD = $FORWARD or 'Y'
UP = $UP or 'Z'


def export(path, file_name):
    target_file = path + '/' + file_name
    bpy.ops.export_scene.obj(filepath=target_file, use_selection=True, use_normals=False, use_uvs=False,
                             use_materials=False, use_triangles=True, axis_forward=FORWARD, axis_up=UP)
    return target_file


def process():
    data = {'outputs': [], 'returnCode': 0}
    obj_names = ITEMS_TO_AGGREGATE.split(',')
    objects = [obj for obj in get_objects(COLLECTION_NAME) if obj.name in obj_names]
    if not objects:
        log(WARN, 'No objects match the export criteria')
        return data
    for object in objects:
        triangulate_object(object)
        object.select_set(True)
    log(INFO, 'Exporting OBJ ' + FILE_NAME)
    exported = export(OUTPUT_PATH, FILE_NAME)
    data['outputs'].append(exported)
    log(INFO, 'Exporting OBJ done')
    return data
