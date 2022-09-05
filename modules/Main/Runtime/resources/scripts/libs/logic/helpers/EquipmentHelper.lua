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
    'libs/logic/models/Collectible.lua',
    'libs/logic/models/Attachable.lua',
    'libs/logic/models/RoomState.lua'
}

function equip(player, weapon)
    player.serializable.equip = weapon.serializable.id
    player.serializable.action_mode = k.actor_action_mode.EQUIP
end

function ammo_load(weapon, ammo)
    local weapProperties = weapon:get_properties().weapon_properties
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
end

function init_shoot(player, weapon)
    local serProps = weapon:get_serializable_properties().weapon_properties
    local props = weapon:get_properties().weapon_properties
    local offset = props.equip_position_offset
    local pos = player:get_position()
    local bulletRef = context_get_full_ref(props.ammo_loaded)
    local bulletProp = bulletRef:get_properties().ammo_properties
    local shot = {
        position = { x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z + offset.z },
        damage = bulletProp.base_damage * serProps.damage_multiplier,
        speed = bulletProp.speed
    }
end

