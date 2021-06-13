from . import hpms_sector_data
from . import hpms_entity_data
from . import hpms_trigger_data

bl_info = {
    "name": "HPMS Tools",
    "description": "Tools collection for HPMS scenes.",
    "author": "Ray1184",
    "version": (1, 0),
    "location": "Object Properties",
    "blender": (2, 90, 2),
    "category": "Object",
    "wiki_url": "https://github.com/Ray1184/HPMSAll",
    "tracker_url": "https://github.com/Ray1184/PMSAll",
}


def register():
    hpms_sector_data.register()
    hpms_entity_data.register()
    hpms_trigger_data.register()


def unregister():
    hpms_entity_data.unregister()
    hpms_sector_data.unregister()


if __name__ == "__main__":
    register()
