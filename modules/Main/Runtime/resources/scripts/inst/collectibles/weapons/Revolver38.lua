dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

revolver_38 = { }


function revolver_38:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.REVOLVER_38.PATH
    local id = g.res_refs.collectibles.REVOLVER_38.ID .. '/' .. idSuffix

    local amount = amount or 1  

    local properties = {
        keep_if_empty = true,
        inventory_position_offset = { x = - 0.1, y = 0, z = 0.625 },
        inventory_rotation_offset = { x = 90, y = 0, z = 0 },
        inventory_scale_offset = { x = 0.05, y = 0.05, z = 0.05 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_rotation_offset = { x = 90, y = 0, z = - 90 },
        scene_drop_scale_offset = { x = 0.035, y = 0.035, z = 0.035 },        
        name = 'items_misc_revolver_38_name',
        description = 'items_misc_revolver_38_description',
        item_type = k.item_types.WEAPON,
        item_license = k.item_license.NONE,
        space_used = 1,
        show_amount = true,
        price = 24,
        allowed_actions =
        {
            k.item_actions.EQUIP,
            k.item_actions.CHECK,
            k.item_actions.RELOAD,
            k.item_actions.DROP
        },
        weapon_properties =
        {
            equip_anim = k.default_animations.EQUIP_HANDGUN_1,
            fire_anim = k.default_animations.FIRE_HANDGUN_1,
            attach_to = k.attachable_bones.HAND,
            ammo_allowed = { g.res_refs.collectibles.REVOLVER_38.ID },
            ammo_max_amount = 6,
            equip_position_offset = { x = 0, y = 0.2, z = 0.07 },
            equip_rotation_offset = { x = 90, y = 0, z = - 90 },
            equip_scale = { x = 0.035, y = 0.035, z = 0.035 },
            fx_position_offset = { x = 0, y = 0.2, z = 0.07 },
            fire_fx_position_offset = { x = 0, y = 0, z = 0 }
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

