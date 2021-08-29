# Retrieve blender runtime info

def process():
    data = {}
    version = bpy.app.version_string
    data['version'] = version
    log(INFO, 'Blender version: ' + version)
    return data
