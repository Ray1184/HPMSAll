dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

dummy_item_1 = { }
dummy_item_2 = { }
dummy_item_3 = { }
dummy_item_4 = { }
dummy_item_5 = { }
dummy_item_6 = { }
dummy_item_7 = { }

function dummy_item_1:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_1.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_1.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_1_name',
        description = 'items_misc_dummy_item_1_description',
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
    end )

    return this
end

function dummy_item_2:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_2.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_2.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_2_name',
        description = 'items_misc_dummy_item_2_description',
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
    end )

    return this
end

function dummy_item_3:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_3.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_3.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_3_name',
        description = 'items_misc_dummy_item_3_description',
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
    end )

    return this
end

function dummy_item_4:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_4.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_4.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_4_name',
        description = 'items_misc_dummy_item_4_description',
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
    end )

    return this
end

function dummy_item_5:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_5.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_5.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_5_name',
        description = 'items_misc_dummy_item_5_description',
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
    end )

    return this
end

function dummy_item_6:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_6.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_6.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_6_name',
        description = 'items_misc_dummy_item_6_description',
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
    end )

    return this
end

function dummy_item_7:ret(idSuffix, amount)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.collectibles.DUMMY_ITEM_7.PATH
    local id = g.res_refs.collectibles.DUMMY_ITEM_7.ID .. '/' .. idSuffix
    
    local amount = amount or 1
    local properties = {
        inventory_position_offset = { x = 0, y = 0, z = 0 },
        scene_drop_position_offset = { x = 0, y = 0, z = 0 },
        inventory_rotation_offset = { x = 0, y = 0, z = 0 },
        inventory_scale_offset = { x = 1, y = 1, z = 1 },
        name = 'items_misc_dummy_item_7_name',
        description = 'items_misc_dummy_item_7_description',
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
    end )

    return this
end