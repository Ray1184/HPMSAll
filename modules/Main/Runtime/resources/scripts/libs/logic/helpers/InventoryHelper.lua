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
    'libs/logic/models/RoomState.lua',
    'libs/logic/helpers/CollectibleHelper.lua'
}

function add_to_inventory(player, item, roomId)    
    if item.serializable.picked then
        log_warn('Item ' .. item.serializable.id .. ' already present in inventory')
        return
    end
    local invSlots = player:get_inventory().objects
    item.serializable.picked = true
    -- If item is expired mark in any case as picked, to make not visible
    if item.serializable.expired then
        return
    end
    table.insert(invSlots, item.serializable)
    if roomId ~= nil then
        local roomState = room_state:ret(roomId)
        roomState:remove_collectible(item.serializable)
    end
end

function remove_if_equipped(player, itemId)
    if player.serializable.equip == itemId then
        player.serializable.equip = nil
    end
end

function remove_from_inventory(player, itemId, drop, roomId)
    local item = context_get_full_ref(itemId)
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
        local rot = item.not_serializable.properties.scene_drop_rotation_offset
        local scale = item.not_serializable.properties.scene_drop_scale_offset
        local playerPos = player:get_position()
        item:set_position(playerPos.x + offset.x, playerPos.y + offset.y, playerPos.z + offset.z)
        item:rotate(rot.x, rot.y, rot.z)
        item:scale(scale.x, scale.y, scale.z)
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


-- After load game I need to recover transient data for all items picked before.
function recover_inventory_items(player, actorsMgr)
    local inventory = player:get_inventory()
    for i = 1, #inventory.objects do
        local objFullId = inventory.objects[i].id
        local amount = inventory.objects[i].amount
        recover_item(objFullId, amount, actorsMgr)
    end
end
