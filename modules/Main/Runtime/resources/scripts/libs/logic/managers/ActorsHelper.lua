-- -
--- Created by Ray1184.
--- DateTime: 04/10/2021 17:04
-- -
--- Actors management useful static functions.
-- -

dependencies = {
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/Context.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

function reset_collision_counter(collisions_states, id)
    collisions_states[id] = 0
end

function get_push_events(actorPusher, actorPushed)
    return {
        evt_info_1 =
        {
            name = k.actor_events.PUSH,
            actor = actorPusher,
            pusher = false,
            pushed = true
        },
        evt_info_2 =
        {
            name = k.actor_events.PUSH,
            actor = actorPushed,
            pusher = true,
            pushed = false
        }
    }
end

function get_collision_events(collisions_states, id, actor1, actor2)
    local first_flag = false
    if collisions_states[id] == 0 or collisions_states[id] == nil then
        collisions_states[id] = 1
        first_flag = true
    end
    return {
        evt_info_1 =
        {
            name = k.actor_events.COLLISION,
            actor = actor1,
            first = first_flag
        },
        evt_info_2 =
        {
            name = k.actor_events.COLLISION,
            actor = actor2,
            first = first_flag
        }
    }
end

function collision_actor_actor(i1, i2, lib, threshold)
    local p1 = i1:get_position()
    local p2 = i2:get_position()
    local minDist = i1:get_scaled_rad() + i2:get_scaled_rad()
    local v1 = lib.vec2(p1.x, p1.y)
    local v2 = lib.vec2(p2.x, p2.y)
    return lib.vec2_dist(v1, v2) <(minDist +(threshold or 0))
end

