--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Actors management for events processing.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

function actor_event(tpf, actor, event, lib)
    local k = game_mechanics_consts:get()
    if event.name == k.actor_events.COLLISION then
        actor_default_collision_event(tpf, actor, event, lib)
    elseif event.name == k.actor_events.PUSH then
        actor_default_push_event(tpf, actor, event, lib)
    end
    actor:event(tpf, event)
end

function actor_default_push_event(tpf, actor, event, lib)
    local k = game_mechanics_consts:get()
    if event.pusher then
        local pusherDir = lib.get_direction(actor.transient.node.rotation, lib.vec3(0, -1, 0))        
        event.actor:move_dir(tpf * k.actor_move_ratio.SLOW, pusherDir)
    end
end

function actor_default_collision_event(tpf, actor, event, lib)
    if not actor.serializable.movable then
        return
    end
    -- TODO Backend management.
    --local ghost = actor:ghost() or event.actor:ghost()
    --if not ghost then
    --    local lastPos = actor.serializable.visual_info.last_position
    --    actor:set_position(lastPos.x, lastPos.y, lastPos.z)
    --end
end