dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

dummy_item = { }

function dummy_item:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_name',
        description = 'items_misc_dummy_item_description',
        item_type = k.item_types.MISC,
        item_license = k.item_license.NONE,
        space_used = 1,
        price = 5,
        allowed_actions =
        {
            k.item_actions.USE,
            k.item_actions.CHECK,
            k.item_actions.DROP
        }
    }

    local this = collectible:ret(path, id, rad, amount)
    this:set_properties(properties)

    self.__tostring = function(o)
        return insp.inspect(o)
    end

    this:set_event_callback( function(tpf, evtInfo)
        -- if evt_info.first then
        --    log_warn('RICORRENZA-CHEST ' .. this.serializable.id .. ': ' .. tostring(evt_info.first))
        -- end
        -- this:rotate(0, 0, 50 * tpf)
    end )

    return this
end
