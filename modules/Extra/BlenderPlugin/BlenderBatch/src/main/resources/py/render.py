# Mandatory params
CAMS_TO_RENDER = $CAMS_TO_RENDER
BASE_PATH = $BASE_PATH

# Optional params
PREVIEW = $PREVIEW or True
CAM_FOV = $CAM_FOV or 60
Z_NEAR = $Z_NEAR or 0.1
Z_FAR = $Z_FAR or 50
RENDERER = $RENDERER or 'BLENDER_EEVEE'
DEVICE = $DEVICE or 'GPU'
WIDTH = $WIDTH or 320
HEIGHT = $HEIGHT or 200
FILTER_SIZE = $FILTER_SIZE or 0.01

# CYCLES settings
FILTER_WIDTH = $FILTER_WIDTH or 0.01
FILTER_TYPE = $FILTER_TYPE or 'GAUSSIAN'
EXPOSURE = $EXPOSURE or 1.5
PREVIEW_SAMPLES = $PREVIEW_SAMPLES or 16
SAMPLES = $SAMPLES or 256
MAX_BOUNCES = $MAX_BOUNCES or 0
CLAMP_INDIRECT = $CLAMP_INDIRECT or 1
MAP_RESOLUTION = $MAP_RESOLUTION or 1024

from math import radians


def configure_renderer(preview):
    bpy.context.scene.use_nodes = True

    bpy.context.scene.render.engine = RENDERER
    bpy.context.scene.render.resolution_x = WIDTH
    bpy.context.scene.render.resolution_y = HEIGHT
    bpy.context.scene.render.resolution_percentage = 100
    bpy.context.scene.render.filter_size = FILTER_SIZE

    log(INFO, 'Using renderer ' + RENDERER)

    if 'CYCLES' == RENDERER:
        bpy.context.scene.cycles.device = DEVICE
        bpy.context.scene.cycles.filter_type = FILTER_TYPE
        bpy.context.scene.cycles.filter_width = FILTER_WIDTH
        bpy.context.scene.cycles.aa_samples = 1
        bpy.context.scene.cycles.film_exposure = EXPOSURE
        bpy.context.scene.cycles.sample_clamp_indirect = CLAMP_INDIRECT
        bpy.context.scene.cycles.glossy_bounces = MAX_BOUNCES
        bpy.context.scene.world.cycles.sample_as_light = True
        bpy.context.scene.world.cycles.sample_map_resolution = MAP_RESOLUTION

        if preview:
            bpy.context.scene.cycles.samples = PREVIEW_SAMPLES
        else:
            bpy.context.scene.cycles.samples = SAMPLES

    if 'BLENDER_EEVEE' == RENDERER:
        bpy.context.scene.eevee.use_soft_shadows = True
        bpy.context.scene.eevee.use_ssr = True
        bpy.context.scene.eevee.use_ssr_refraction = True
        bpy.context.scene.eevee.use_gtao = True
        bpy.context.scene.eevee.gtao_distance = 1
        bpy.context.scene.eevee.use_volumetric_shadows = True
        bpy.context.scene.eevee.volumetric_tile_size = '2'
        bpy.context.scene.eevee.gi_diffuse_bounces = 1
        bpy.context.scene.eevee.gi_cubemap_resolution = '128'
        bpy.context.scene.eevee.gi_visibility_resolution = '16'
        bpy.context.scene.eevee.gi_irradiance_smoothing = 0


def config_cam(cam):
    cam.lens_unit = "FOV"
    cam.sensor_fit = "VERTICAL"
    cam.angle = radians(CAM_FOV)
    cam.clip_start = Z_NEAR
    cam.clip_end = Z_FAR


def render_image(path, cam_name):
    complete_path = path + '/' + cam_name + '.png'
    bpy.context.scene.render.filepath = complete_path
    bpy.ops.render.render(write_still=True)
    return complete_path


def process():
    data = {'outputs': []}
    log(INFO, 'Rendering started')
    configure_renderer(PREVIEW)
    cam_names = CAMS_TO_RENDER.split(',')
    for cam in bpy.data.cameras:
        if cam.name in cam_names:
            config_cam(cam)
    for cam_name in cam_names:
        cam_obj = [obj for obj in bpy.data.objects if obj.fieldType == 'CAMERA' and obj.name == cam_name][0]
        bpy.context.scene.camera = cam_obj
        log(INFO, 'Rendering cam: ' + cam_name)
        render_image(BASE_PATH, cam_name)
        data['outputs'].append(render_image(BASE_PATH, cam_name))
    log(INFO, 'Rendering done')
    return data
