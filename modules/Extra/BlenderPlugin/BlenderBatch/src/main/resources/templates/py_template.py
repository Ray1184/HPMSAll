import bpy
import json
import sys
import datetime
import bmesh
import os

LOG_LEVEL = $LOG_LEVEL
TRACE = {'label': 'TRACE', 'val': 5}
DEBUG = {'label': 'DEBUG', 'val': 4}
INFO = {'label': ' INFO', 'val': 3}
WARN = {'label': ' WARN', 'val': 2}
ERROR = {'label': 'ERROR', 'val': 1}


def main():
    sys.stdout.write('@@begin@@')
    sys.stdout.write(json.dumps(process()))
    sys.stdout.write('@@end@@')


# Utility methods
def pack_exists(fn_name, package):
    return fn_name in dir(package)

def unselect_all():
    for obj in bpy.data.objects:
        obj.select_set(False)


def triangulate_object(me):
    bm = bmesh.new()
    bm.from_mesh(me)
    bmesh.ops.triangulate(bm, faces=bm.faces)
    bm.to_mesh(me)
    bm.free()


def get_objects(collection_name=None):
    if collection_name is None:
        return bpy.data.objects
    else:
        return bpy.data.collections[collection_name].all_objects

def get_hpms_objects(collection_name, type=None):
    coll_objects = get_objects(collection_name)
    if type is None:
        return [obj for obj in coll_objects if 'hpms_type' in obj]
    else:
        return [obj for obj in coll_objects if 'hpms_type' in obj and obj['hpms_type'] == type]


def log(level, msg):
    date = datetime.datetime.now().strftime('%Y-%m-%dT%H:%M:%S')
    if level['val'] <= LOG_LEVEL:
        with open('logs/blender.log', 'a') as logger:
            $LOG_FN

$PY_CODE

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        log(ERROR, str(e))
