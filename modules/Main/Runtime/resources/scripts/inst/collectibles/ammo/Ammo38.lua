dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

ammo_38 = { }


function ammo_38:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.AMMO_38.PATH
    local id = g.res_refs.collectibles.AMMO_38.ID .. '/' .. idSuffix

    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = - 0.1, y = 0, z = 0.5 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 0.12, y = 0.12, z = 0.12 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_rotation_offset = { x = 90, y = 0, z = - 90 },
        scene_drop_scale_offset = { x = 0.035, y = 0.035, z = 0.035 },
        name = 'items_misc_ammo_38_name',
        description = 'items_misc_ammo_38_description',
        item_type = k.item_types.AMMO,
        item_license = k.item_license.NONE,
        space_used = 1,
        show_amount = true,
        price = 0.1,
        allowed_actions =
        {
            k.item_actions.USE,
            k.item_actions.CHECK,
            k.item_actions.DROP
        },
        ammo_properties =
        {
            fire_fx_name = 'GunFX/ShotFire1',
            bullet_fx_name = 'GunFX/ShotBullet1',
            collision_fx_name = 'GunFX/ShotExplosion1',
            blast_radius = 0.5,
            max_per_slot = 12,
            base_damage = 2,
            speed = 50,
            stopping = false,
            spread = false,
            poison = false,
            sleep = false,
            paralysis = false,
            fire = false,
            explosive = false,
            radiation = false,
            piercing = false
        }
    }

    local this = collectible:ret(path, id, amount)
    this:set_properties(properties)

    self.__tostring = function(o)
        return insp.inspect(o)
    end

    this:set_event_callback( function(tpf, evtInfo)
        evtInfo.response = {
            quit_inventory = true
        }
    end )

    return this
end

