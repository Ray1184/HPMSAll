--
-- Created by Ray1184.
-- DateTime: 04/03/2022 17:04
--
-- Helper for equipment management.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/templates/VolatileGameItem.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/models/Attachable.lua',
    'libs/logic/models/RoomState.lua'
}

function equip(player, weapon)
    player.serializable.equip = weapon.serializable.id
    player.serializable.action_mode = k.actor_action_mode.EQUIP
end

function create_ammo_properties(ammo, weapon)
    local ammoProp = ammo:get_properties().ammo_properties
    local weaponProp = weapon:get_serializable_properties().weapon_properties
    return {
        id = ammo.serializable.id,
        fire_fx_name = ammoProp.fire_fx_name,
        damage = ammoProp.base_damage * weaponProp.damage_multiplier,
        speed = ammoProp.speed,
        stopping = ammoProp.stopping,
        spread = ammoProp.spread,
        poison = ammoProp.poison,
        sleep = ammoProp.sleep,
        paralysis = ammoProp.paralysis,
        fire = ammoProp.fire,
        explosive = ammoProp.explosive,
        radiation = ammoProp.radiation,
        piercing = ammoProp.piercing
    }
end

function ammo_load(weapon, ammo)
    local weapProperties = weapon:get_properties().weapon_properties
    local weapSerProperties = weapon:get_serializable_properties().weapon_properties
    -- TODO load only allowed ammo.
    local currentLoad = weapon.serializable.amount
    local newLoad = ammo.serializable.amount
    local maxAmount = weapProperties.ammo_max_amount
    if currentLoad < maxAmount then
        local maxLoadable = maxAmount - currentLoad
        if newLoad <= maxLoadable then
            weapon.serializable.amount = currentLoad + newLoad
            ammo.serializable.amount = 0
        else
            weapon.serializable.amount = maxLoadable
            ammo.serializable.amount = newLoad - maxLoadable
        end
    end
    ammo.serializable.amount_in_weapon = weapon.serializable.amount
    weapSerProperties.ammo_loaded = create_ammo_properties(ammo, weapon)
end



function init_round(player, weapon, actorsMgr, lib)
    k = game_mechanics_consts:get()
    local serProps = weapon:get_serializable_properties().weapon_properties
    local props = weapon:get_properties().weapon_properties
    local offset = props.equip_position_offset
    local fxOffset = props.fx_position_offset
    local pos = player:get_position()

    local shot = volatile_game_item:ret()

    local properties = {
        vtype = k.volatile_types.BULLET,
        position = { x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z + offset.z },
        direction = lib.get_direction(player.transient.node.rotation,lib.vec3(0,- 1,0)),
        ttl = k.BULLET_TTL,
        life = 0
    }
    shot.not_serializable.properties = merge_tables(properties, serProps.ammo_loaded)
    context_put_and_init_volatile(shot)
    shot:set_position(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z)
    if shot.not_serializable.properties.fire_fx_name ~= nil then
        local fxTemplate = shot.not_serializable.properties.fire_fx_name
        local id = shot.not_serializable.id
        local attachTo = props.attach_to
        local parentEntity = player.transient.entity
        local dummyRot = lib.from_euler(0, 0, 0)
        local dummyScale = lib.vec3(1, 1, 1)
        shot:add_secondary_transient_data(
        function()
            shot.transient.additional_data.fx = lib.make_particle_system('fx/' .. fxTemplate .. '/' .. id, fxTemplate, false)
            lib.attach_particle_to_entity_bone(attachTo, shot.transient.additional_data.fx, parentEntity, lib.vec3(fxOffset.x, fxOffset.y, fxOffset.z), dummyRot, dummyScale)
        end ,
        function(tpf) end,
        function()
            lib.detach_particle_from_entity_bone(attachTo, shot.transient.additional_data.fx, parentEntity)
            lib.delete_particle_system(shot.transient.additional_data.fx)
        end
        )

    end
end

function update_rounds(sceneMgr, tpf, lib)
    context_foreach_alive_volatile(
    function(v) return v.not_serializable.properties.vtype == k.volatile_types.BULLET end,
    function(round)
        local props = round.not_serializable.properties
        round:move_dir(tpf * props.speed, props.direction)
        -- TODO collisions.
        if props.life > props.ttl then
            context_remove_and_delete_volatile(round)
        end
        props.life = props.life + tpf
    end
    )
end

