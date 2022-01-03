-- -
--- Created by Ray1184.
--- DateTime: 04/10/2021 17:04
-- -
--- Actors management functions.
-- -

dependencies = {
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/Context.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

actors_manager = { }

function actors_manager:new(scene_manager)
    lib = backend:get()
    insp = inspector:get()
    k = game_mechanics_consts:get()
    local this = {
        module_name = 'actors_manager',

        -- Room info
        scene_manager = scene_manager,

        -- Backend data ref
        loaded_actors = { },
        loaded_npcs = { },
        loaded_collectibles = { },
        loaded_player = nil,
        collisions_states = { },
        actors = 0,
        npcs = 0,
        collectibles = 0,
        positions = { }
    }
    log_debug('Creating actors module for room')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function actors_manager:delete_all()
        for ka, actor in pairs(self.loaded_actors) do
            actor:delete_transient_data()
            actor:kill_instance()

        end
        for kn, npc in pairs(self.loaded_npcs) do
            npc:delete_transient_data()
            npc:kill_instance()

        end
        for kc, collectible in pairs(self.loaded_collectibles) do
            collectible:delete_transient_data()
            collectible:kill_instance()

        end
        if self.loaded_player ~= nil then
            self.loaded_player:delete_transient_data()
            self.loaded_player:kill_instance()
        end

        self.loaded_actors = { }
        self.loaded_npcs = { }
        self.loaded_collectibles = { }
        self.loaded_player = nil
    end

    function actors_manager:create_player(player_id)
        if self.loaded_player == nil then
            self.loaded_player = context:get_instance(k.inst_cat.PLAYERS, player_id)
            self.loaded_player:fill_transient_data(self.scene_manager:get_walkmap())
        end
        return self.loaded_player
    end

    function actors_manager:create_actor(actor_id)
        local id_suffix = self.scene_manager:get_scene_name() .. '/' .. tostring(self.actors)
        local actor = context:get_instance(k.inst_cat.ACTORS, actor_id, id_suffix)
        self.loaded_actors[actor.serializable.id] = actor
        self.loaded_actors[actor.serializable.id]:fill_transient_data(self.scene_manager:get_walkmap())
        self.actors = self.actors + 1
        return self.loaded_actors[actor.serializable.id]
    end

    function actors_manager:poll_events(tpf)
        if self.loaded_player ~= nil then
            self:manage_collisions(tpf)
        end
    end

    function actors_manager:manage_collisions(tpf)
        -- Collision between player and actors
        for ka, actor in pairs(self.loaded_actors) do
            if collision_actor_actor(actor, self.loaded_player, lib) then
                first_flag = first_collision(self.collisions_states, ka)
                local evt_info_player = {
                    name = k.actor_events.COLLISION,
                    entity = self.loaded_player,
                    first = first_flag
                }
                local evt_info_actor = {
                    name = k.actor_events.COLLISION,
                    entity = actor,
                    first = first_flag
                }
                self.loaded_player:event(tpf, evt_info_actor)
                actor:event(tpf, evt_info_player)
            else
                reset_collision_counter(self.collisions_states, ka)
            end
        end
    end

    return this
end

function reset_collision_counter(collisions_states, id)
    collisions_states[id] = 0
end

function first_collision(collisions_states, id)
    if collisions_states[id] == 0 or collisions_states[id] == nil then
        collisions_states[id] = 1
        return true
    end
    return false
end

function collision_actor_actor(i1, i2, lib)
    local p1 = i1:get_position()
    local p2 = i2:get_position()
    local minDist = i1:get_scaled_rad() + i2:get_scaled_rad()
    local v1 = lib.vec2(p1[1], p1[2])
    local v2 = lib.vec2(p2[1], p2[2])
    return lib.vec2_dist(v1, v2) < minDist
end