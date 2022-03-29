--
-- Created by Ray1184.
-- DateTime: 04/03/2022 17:04
--
-- Helper for inventory management.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/models/Collectible.lua'
}

function add_to_inventory(player, item)
    if item.serializable.picked then
        log_warn('Item ' .. item.serializable.id .. ' already present in inventory')
        return
    end
    local invSlots = player:get_inventory().objects
    item.serializable.picked = true
    table.insert(invSlots, item.serializable)
end

function drop_from_inventory(player, itemId)
    local invSlots = player:get_inventory().objects
    local newInvSlots = { }
    local item = nil
    for i = 1, #invSlots do
        if invSlots[i].serializable.id == itemId then
            toRemove = invSlots[i]
        else
            table.insert(newInvSlots, invSlots[i])
        end
    end
    player:get_inventory().objects = newInvSlots
    item.serializable.picked = false
    local offset = item.not_serializable.properties.scene_drop_position_offset
    local playerPos = player:get_position()
    item:set_position(playerPos.x + offset.x, playerPos.y + offset.y, playerPos.z + offset.z)

end

function calculate_cursor_and_offset(cursorIndex, cursorSize, inventorySize)

    local downShift = math.floor(cursorSize / 2)
    local upShift = math.floor(cursorSize / 2)
    if cursorSize % 2 == 0 then
        upShift = upShift + 1
    end
    if cursorIndex <= downShift + 1 then
        return {
            cursor_slot = cursorIndex,
            display_from = 1,
            display_to = cursorSize
        }
    elseif cursorIndex >= inventorySize -(downShift - 1) then
        return {
            cursor_slot = cursorSize -(inventorySize - cursorIndex),
            display_from = inventorySize -(cursorSize -(downShift - 1)),
            display_to = inventorySize
        }
    else
        return {
            cursor_slot = downShift + 1,
            display_from = cursorIndex - downShift,
            display_to = cursorIndex + upShift
        }
    end

end