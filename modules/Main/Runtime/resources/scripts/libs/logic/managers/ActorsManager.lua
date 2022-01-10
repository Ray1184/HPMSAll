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
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/managers/ActorsHelper.lua',
    'libs/logic/managers/ActorsEventsHelper.lua'
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
        self:update_actors(tpf)
        if self.loaded_player ~= nil then
            self:manage_pushes(tpf)
            self:manage_collisions(tpf)
        end
        
        
    end

    function actors_manager:manage_pushes(tpf)
        -- Push between player and pushables
        for ka, actor in pairs(self.loaded_actors) do
            local pushing = actor.serializable.pushable
            pushing = pushing and self.loaded_player.serializable.action_mode == k.actor_action_mode.PUSH
            pushing = pushing and self.loaded_player.serializable.performing_action
            local pushThreshold = self.loaded_player:get_scaled_rad() / 10
            if pushing and collision_actor_actor(actor, self.loaded_player, lib, pushThreshold) then
                local evts_info = get_push_events(self.loaded_player, actor)
                actor_event(tpf, self.loaded_player, evts_info.evt_info_2, lib)
                actor_event(tpf, actor, evts_info.evt_info_1, lib)
            end
        end
    end

    function actors_manager:manage_collisions(tpf)
        -- Collision between player and actors
        for ka, actor in pairs(self.loaded_actors) do
            if collision_actor_actor(actor, self.loaded_player, lib) then
                local evts_info = get_collision_events(self.collisions_states, ka, self.loaded_player, actor)
                actor_event(tpf, self.loaded_player, evts_info.evt_info_2, lib)
                actor_event(tpf, actor, evts_info.evt_info_1, lib)
            else
                reset_collision_counter(self.collisions_states, ka)
            end
        end
    end

    function actors_manager:update_actors(tpf)
        for ka, actor in pairs(self.loaded_actors) do
            actor:update(tpf)

        end
        for kn, npc in pairs(self.loaded_npcs) do
            npc:update(tpf)

        end
        for kc, collectible in pairs(self.loaded_collectibles) do
            collectible:update(tpf)

        end
        if self.loaded_player ~= nil then
            self.loaded_player:update(tpf)
        end
    end

    return this
end

