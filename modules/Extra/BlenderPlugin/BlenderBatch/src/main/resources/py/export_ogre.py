# Export OGRE composite files on filesystem

# Mandatory params
OUTPUT_PATH = $OUTPUT_PATH
OBJECTS = $OBJECTS

# Export properties
COLLECTION_NAME = $COLLECTION_NAME or None
FORWARD = $FORWARD or 'Y'
UP = $UP or 'Z'
EXPORT_ANIMATIONS = $EXPORT_ANIMATIONS or False
EXPORT_MATERIALS = $EXPORT_MATERIALS or False


def export(path, file_name):
    target_file = path + '/' + file_name
    axis = 'x' + FORWARD.lower() + UP.lower()
    bpy.ops.ogre.export(filepath=target_file, EX_SWAP_AXIS=axis, EX_XML_DELETE=False, EX_SCENE=False,
                        EX_SELECTED_ONLY=True, EX_EXPORT_HIDDEN=True, EX_FORCE_CAMERA=True,
                        EX_FORCE_LAMPS=True, EX_MATERIALS=EXPORT_MATERIALS, EX_SEPARATE_MATERIALS=True,
                        EX_COPY_SHADER_PROGRAMS=True, EX_ARMATURE_ANIMATION=EXPORT_ANIMATIONS,
                        EX_SHAPE_ANIMATIONS=EXPORT_ANIMATIONS)

    return target_file


def process():
    data = {'outputs': [], 'returnCode': 0}
    if not pack_exists('ogre', bpy.ops):
        log(ERROR, 'OGRE Export plugin is not installed, download and install it from OGRE repository')
        return
    obj_names = OBJECTS.split(',')
    objects = [obj for obj in get_objects(COLLECTION_NAME) if obj.name in obj_names]
    if not objects:
        log(WARN, 'No objects match the export criteria')
        return data
    for object in objects:
        log(INFO, 'Exporting OGRE ' + object.name)
        unselect_all()
        object.select_set(True)
        target = export(OUTPUT_PATH, object.name)
        data['outputs'].append(target + '.mesh.xml')
        if EXPORT_ANIMATIONS:
            data['outputs'].append(target + '.skeleton.xml')
        log(INFO, 'Exporting OGRE done')
    return data
