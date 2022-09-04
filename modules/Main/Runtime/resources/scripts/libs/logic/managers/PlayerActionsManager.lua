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
        interactive = true,
        input_prf = input_profile:new(context_get_input_profile()),
        actions =
        {
            walk = 0,
            walkRatio = 0,
            rotate = 0,
            action_1_once = false,
            action_2_once = false,
            action_3_once = false,
            action_1_doing = false,
            action_2_doing = false,
            action_3_doing = false
        }
    }
    log_debug('Creating player actions manager module')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player_actions_manager:poll_inputs(keys, mouseButtons, scene)
        self.input_prf:poll_inputs(keys, mouseButtons)
        if keys ~= nil and self.interactive then

            if self.input_prf:action_done_once(k.input_actions.EXIT) then
                scene.quit = true
                return
            end

            if self.input_prf:action_doing(k.input_actions.UP) then
                self.actions.walk = 1
            elseif self.input_prf:action_doing(k.input_actions.DOWN) then
                self.actions.walk = -1
            else
                self.actions.walk = 0
            end
            if self.input_prf:action_doing(k.input_actions.RIGHT) then
                self.actions.rotate = -1
            elseif self.input_prf:action_doing(k.input_actions.LEFT) then
                self.actions.rotate = 1
            else
                self.actions.rotate = 0
            end

            if self.input_prf:action_done_once(k.input_actions.ACTION_1) then
                self.actions.action_1_once = true
            else
                self.actions.action_1_once = false
            end

            if self.input_prf:action_doing(k.input_actions.ACTION_1) then
                self.actions.action_1_doing = true
            else
                self.actions.action_1_doing = false
            end

            if self.input_prf:action_done_once(k.input_actions.ACTION_2) then
                self.actions.action_2_once = true
            else
                self.actions.action_2_once = false
            end

            if self.input_prf:action_doing(k.input_actions.ACTION_2) then
                self.actions.action_2_doing = true
            else
                self.actions.action_2_doing = false
            end

            if self.input_prf:action_done_once(k.input_actions.ACTION_3) then
                self.actions.action_3_once = true
            else
                self.actions.action_3_once = false
            end

            if self.input_prf:action_doing(k.input_actions.ACTION_3) then
                self.actions.action_3_doing = true
            else
                self.actions.action_3_doing = false
            end



        end
    end

    function player_actions_manager:update(tpf)
        if self.actions.walk == 1 then
            self.actions.walkRatio = self.actions.walkRatio + tpf * 10
            if self.actions.walkRatio > 1 then
                self.actions.walkRatio = 1
            end
        elseif self.actions.walk == -1 then
            self.actions.walkRatio = self.actions.walkRatio - tpf * 10
            if self.actions.walkRatio < -1 then
                self.actions.walkRatio = -1
            end
        else
            if self.actions.walkRatio > 0 then
                self.actions.walkRatio = self.actions.walkRatio - tpf * 10
                if self.actions.walkRatio < 0 then
                    self.actions.walkRatio = 0
                end
            else
                self.actions.walkRatio = self.actions.walkRatio + tpf * 10
                if self.actions.walkRatio > 0 then
                    self.actions.walkRatio = 0
                end
            end

        end
        local turn = self.actions.rotate ~= 0
        local walkF = self.actions.walk > 0
        local walkB = self.actions.walk < 0
        player.serializable.performing_action = false
        if self.interactive then
            if self.actions.action_2_doing then
                player.serializable.performing_action = true

                local cbks = { }

                cbks[k.actor_action_mode.SEARCH] = function()

                end

                cbks[k.actor_action_mode.COMBAT] = function()

                end

                cbks[k.actor_action_mode.EQUIP] = function()

                end

                cbks[k.actor_action_mode.PUSH] = function()
                    player:set_anim(k.default_animations.PUSH)
                    player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                end

                cbks[k.actor_action_mode.STEALTH] = function()

                end

                cbks[k.actor_action_mode.SWIM] = function()

                end

                cbks[k.actor_action_mode.JUMP] = function()

                end

                cbks[k.actor_action_mode.CROWL] = function()

                end

                cbks[player.serializable.action_mode]()

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
        if not self.actions.action_2_doing then
            player:rotate(0, 0, 150 * tpf * self.actions.rotate)
        end
        player:move_dir(tpf * self.actions.walkRatio)
    end

    function player_actions_manager:set_interactive(flag)
        self.interactive = flag
    end


    return this
end

