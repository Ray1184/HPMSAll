--
-- Created by Ray1184.
-- DateTime: 04/03/2022 17:04
--
-- Helper for equipment management.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/helpers/ActorsHelper.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/models/Collectible.lua',
    'libs/logic/models/Attachable.lua',
    'libs/logic/models/RoomState.lua'
}

function recover_item(objFullId, amount, actorsMgr)
    local id, suffix = get_full_id_parts(objFullId)
    return actorsMgr:create_item_sfx(id, amount, suffix)
end

function item_can_be_picked(roomColls, player, lib)
    k = game_mechanics_consts:get()
    for i = 1, #roomColls do
        local coll = context_get_full_ref(roomColls[i].id)
        if collision_actor_actor_custom(player, coll, lib, k.DEFAULT_MIN_PICK_DISTANCE, false) then
            return coll;
        end
    end
    return nil
end

function item_set_expired_if_empty(item)
    if not item.serializable.expired and item.serializable.amount <= 0 and not item:get_properties().keep_if_empty then
        if item.serializable.amount_in_weapon ~= nil and item.serializable.amount_in_weapon <= 0 then
            item:kill_instance()
        else
            item.serializable.visual_info.visible = false
            item.transient.entity.visible = item.serializable.visual_info.visible
        end
    end
end

