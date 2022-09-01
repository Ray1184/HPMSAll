--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Actors management functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/helpers/ActorsHelper.lua',
    'libs/logic/helpers/ActorsEventsHelper.lua',
    'libs/logic/models/RoomState.lua'
}

actors_manager = { }

function actors_manager:new(sceneManager)
    lib = backend:get()
    insp = inspector:get()
    k = game_mechanics_consts:get()
    local this = {
        module_name = 'actors_manager',

        -- Room info
        scene_manager = sceneManager,

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
    log_debug('Creating actors module for room ' .. sceneManager:get_scene_name())
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function actors_manager:delete_all()
        for ka, actor in pairs(self.loaded_actors) do
            actor:delete_transient_data()

        end
        for kn, npc in pairs(self.loaded_npcs) do
            npc:delete_transient_data()

        end
        for kc, collectible in pairs(self.loaded_collectibles) do
            collectible:delete_transient_data()

        end
        if self.loaded_player ~= nil then
            self.loaded_player:delete_transient_data()
        end

        self.loaded_actors = { }
        self.loaded_npcs = { }
        self.loaded_collectibles = { }
        self.loaded_player = nil
    end

    function actors_manager:create_player(playerId)
        if self.loaded_player == nil then
            self.loaded_player = context_get_instance(k.inst_cat.ACTORS, playerId)
            self.loaded_player:fill_transient_data(self.scene_manager:get_walkmap())
            if not self.loaded_player.serializable.expired then
                lib.add_collisor_to_env(self.scene_manager:get_collision_env(), playerId, self.loaded_player.transient.collisor)
            end
        end
        return self.loaded_player
    end

    function actors_manager:create_actor(actorId)
        local idSuffix = self.scene_manager:get_scene_name() .. '/' .. tostring(self.actors)
        local actor = context_get_instance(k.inst_cat.ACTORS, actorId, idSuffix)
        self.loaded_actors[actor.serializable.id] = actor
        self.loaded_actors[actor.serializable.id]:fill_transient_data(self.scene_manager:get_walkmap())
        if not self.loaded_actors[actor.serializable.id].serializable.expired then
            lib.add_collisor_to_env(self.scene_manager:get_collision_env(), actor.serializable.id, self.loaded_actors[actor.serializable.id].transient.collisor)
        end
        self.actors = self.actors + 1
        return self.loaded_actors[actor.serializable.id]
    end

    function actors_manager:create_item_sfx(itemId, amount, idSuffix)
        local item = context_get_instance(k.inst_cat.COLLECTIBLES, itemId, idSuffix, amount)
        local roomState = room_state:ret(self.scene_manager:get_scene_name())
        if not roomState:has_item(item.serializable.id) then
            log_debug('Item with id ' .. item.serializable.id .. ' not present in room state for ' .. self.scene_manager:get_scene_name())
            item:fill_transient_data()
        else
            log_debug('Item with id ' .. item.serializable.id .. ' already stored in room state for ' .. self.scene_manager:get_scene_name())
            item.serializable = roomState:get_item(item.serializable.id)
            context_update_serializable_data_obj(item.serializable)
        end
        self.loaded_collectibles[item.serializable.id] = item
        self.collectibles = self.collectibles + 1
        return self.loaded_collectibles[item.serializable.id]
    end

    function actors_manager:create_item(itemId, amount)
        local idSuffix = self.scene_manager:get_scene_name() .. '/' .. tostring(self.collectibles)
        return self:create_item_sfx(itemId, amount, idSuffix)
    end

    function actors_manager:init_events()
        lib.update_collision_env_no_collisions(self.scene_manager:get_collision_env(), 0)
    end

    function actors_manager:poll_events(tpf)
        if self.scene_manager:is_paused() then
            return
        end
        -- Note: update_collision_env must be done for first, as the collision engine updates all collisors new positions.
        -- After that we can manage the behavior based on new positions.
        self:update_actors(tpf)
        if self.loaded_player ~= nil then
            self:manage_pushes(tpf)
            self:manage_collisions(tpf)
        end
        lib.update_collision_env(self.scene_manager:get_collision_env(), tpf)
    end

    function actors_manager:manage_pushes(tpf)
        -- Push between player and pushables.
        for ka, actor in pairs(self.loaded_actors) do
            local pushing = actor.serializable.pushable
            pushing = pushing and self.loaded_player.serializable.action_mode == k.actor_action_mode.PUSH
            pushing = pushing and self.loaded_player.serializable.performing_action
            if pushing and collision_actor_actor_custom(self.loaded_player, actor, lib, k.DEFAULT_MIN_PUSH_DISTANCE, true) then
                local evts_info = get_push_events(self.loaded_player, actor)
                actor_event(tpf, self.loaded_player, evts_info.evt_info_2, lib)
            end
        end
    end

    function actors_manager:manage_collisions(tpf)
        -- Collision between player and actors.
        for ka, actor in pairs(self.loaded_actors) do
            if collision_actor_actor(self.loaded_player, actor, lib) then
                local evts_info = get_collision_events(self.collisions_states, ka, self.loaded_player, actor)
                actor_event(tpf, self.loaded_player, evts_info.evt_info_2, lib)
                actor_event(tpf, actor, evts_info.evt_info_1, lib)
            else
                reset_collision_counter(self.collisions_states, ka)
            end
        end

        -- Collision between actors and actors.
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

