dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

mag_44_ap = { }


function mag_44_ap:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.MAG_44_AP.PATH
    local id = g.res_refs.collectibles.MAG_44_AP.ID .. '/' .. idSuffix

    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = - 0.1, y = 0, z = 0.5 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 0.12, y = 0.12, z = 0.12 },
        name = 'items_misc_mag_44_ap_name',
        description = 'items_misc_mag_44_ap_description',
        item_type = k.item_types.MISC,
        item_license = k.item_license.NONE,
        space_used = 1,
        show_amount = true,
        price = 200,
        allowed_actions =
        {
            k.item_actions.USE,
            k.item_actions.CHECK,
            k.item_actions.DROP
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

