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
    'libs/logic/models/Collectible.lua',
    'libs/logic/models/RoomState.lua'
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

function remove_from_inventory(player, itemId, drop, roomId)
    local item = context:get_full_ref(itemId)
    local invSlots = player:get_inventory().objects
    local newInvSlots = { }
    local insp = inspector.get()
    for i = 1, #invSlots do
        if invSlots[i].id == item.serializable.id then
            toRemove = invSlots[i]
        else
            table.insert(newInvSlots, invSlots[i])
        end
    end
    player:get_inventory().objects = newInvSlots

    if drop then
        item.serializable.picked = false
        local offset = item.not_serializable.properties.scene_drop_position_offset
        local playerPos = player:get_position()
        item:set_position(playerPos.x + offset.x, playerPos.y + offset.y, playerPos.z + offset.z)
        local roomState = room_state:ret(roomId)
        roomState:add_collectible(item.serializable)
    end
    return item
end

function calculate_cursor_and_offset(cursorIndex, cursorSize, repositorySize)

    local downShift = math.floor(cursorSize / 2)
    local upShift = math.floor(cursorSize / 2)
    if cursorSize % 2 == 0 then
        upShift = upShift + 1
        log_warn('Even cursor can be unaligned, better use odd')
    end
    if repositorySize == 0 then
        return {
            cursor_slot = 1,
            display_from = 1,
            display_to = 1
        }
    elseif repositorySize <= cursorSize then
        return {
            cursor_slot = cursorIndex,
            display_from = 1,
            display_to = repositorySize
        }
    elseif cursorIndex <= downShift + 1 then
        return {
            cursor_slot = cursorIndex,
            display_from = 1,
            display_to = cursorSize
        }
    elseif cursorIndex >= repositorySize -(downShift - 1) then
        return {
            cursor_slot = cursorSize -(repositorySize - cursorIndex),
            display_from = (repositorySize - cursorSize) + 1,
            display_to = repositorySize
        }
    else
        return {
            cursor_slot = downShift + 1,
            display_from = cursorIndex - downShift,
            display_to = cursorIndex + upShift
        }
    end

end