--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Player actions management dependent by input functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/input/InputProfile.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

player_actions_manager = { }

function player_actions_manager:new(player, roomState, sceneMgr)
    lib = backend:get()
    insp = inspector:get()
    k = game_mechanics_consts:get()
    local this = {
        module_name = 'player_actions_manager',
        player = player,
        room_state = roomState,
        interactive = true,
        input_prf = input_profile:new(context_get_input_profile()),
        scene_mgr = sceneMgr,
        actions =
        {
            walk = 0,
            rotate = 0,
            action_1 = false,
            action_2 = false,
            action_3 = false
        }
    }
    log_debug('Creating player actions manager module')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player_actions_manager:poll_inputs(keys, mouseButtons)
        local scene = self.scene_mgr:get_scene_name()
        if keys ~= nil and self.interactive then

            if lib.key_action_performed(keys, k.input_actions.ESC, 1) then
                scene.quit = true
                return
            end

            if lib.key_action_performed(keys, k.input_actions.UP, 2) then
                self.actions.walk = 1
            elseif lib.key_action_performed(keys, k.input_actions.DOWN, 2) then
                self.actions.walk = -1
            else
                self.actions.walk = 0
            end
            if lib.key_action_performed(keys, k.input_actions.RIGHT, 2) then
                self.actions.rotate = -1
            elseif lib.key_action_performed(keys, k.input_actions.LEFT, 2) then
                self.actions.rotate = 1
            else
                self.actions.rotate = 0
            end

            if lib.key_action_performed(keys, k.input_actions.ACTION_1, 1) then
                self.actions.action_1 = true
            else
                self.actions.action_1 = false
            end

            if lib.key_action_performed(keys, k.input_actions.ACTION_2, 1) then
                self.actions.action_2 = true
            else
                self.actions.action_2 = false
            end

            if lib.key_action_performed(keys, k.input_actions.ACTION_3, 1) then
                self.actions.action_3 = true
            else
                self.actions.action_3 = false
            end

        end
    end

    function player_actions_manager:update(tpf)
        local walkRatio = 0
        if self.actions.walk == 1 then
            walkRatio = walkRatio + tpf * 10
            if walkRatio > 1 then
                walkRatio = 1
            end
        elseif self.actions.walk == -1 then
            walkRatio = walkRatio - tpf * 10
            if walkRatio < -1 then
                walkRatio = -1
            end
        else
            if walkRatio > 0 then
                walkRatio = walkRatio - tpf * 10
                if walkRatio < 0 then
                    walkRatio = 0
                end
            else
                walkRatio = walkRatio + tpf * 10
                if walkRatio > 0 then
                    walkRatio = 0
                end
            end

        end
        local turn = self.actions.rotate ~= 0
        local walkF = walkRatio > 0
        local walkB = walkRatio < 0
        player.serializable.performing_action = false
        if interactive then
            if action then
                player:set_anim(k.default_animations.PUSH)
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                player.serializable.performing_action = true
            elseif walkF or(walkF and turn) then
                player:set_anim(k.default_animations.WALK_FORWARD)
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
            elseif walkB or(walkB and turn) then
                player:set_anim(k.default_animations.WALK_BACK)
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
            elseif turn then
                player:set_anim(k.default_animations.IDLE)
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
            else
                player:set_anim(k.default_animations.IDLE)
                player:play(k.anim_modes.ANIM_MODE_LOOP, 2, 1)
            end
        end
        if not action then
            player:rotate(0, 0, 150 * tpf * self.actions.rotate)
        end
        player:move_dir(tpf * walkRatio * 5)
    end

    function player_actions_manager:set_interactive(flag)
        self.interactive = flag
    end

    function player_actions_manager:is_action_1()
        return self.actions.action_1
    end

    function player_actions_manager:is_action_2()
        return self.actions.action_2
    end

    function player_actions_manager:is_action_3()
        return self.actions.action_3
    end

    return this
end

