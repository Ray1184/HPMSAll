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

function player_actions_manager:new(player, roomState, actorsMgr)
    lib = backend:get()
    insp = inspector:get()
    k = game_mechanics_consts:get()
    local this = {
        module_name = 'player_actions_manager',
        interactive = true,
        input_prf = input_profile:new(context_get_input_profile()),
        anim_timer = 0,
        actors_manager = actorsMgr,
        init_timer = false,
        recoil_anim = false,
        shot_ready = true,
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
            action_3_doing = false,
            double_action_up_once = false,
            double_action_up_doing = false,
            double_action_down_once = false,
            double_action_down_doing = false,
            double_action_left_once = false,
            double_action_left_doing = false,
            double_action_right_once = false,
            double_action_right_doing = false
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

            if self.actions.action_2_doing and self.input_prf:action_done_once(k.input_actions.UP) then
                self.actions.double_action_up_once = true
            else
                self.actions.double_action_up_once = false
            end

            if self.actions.action_2_doing and self.input_prf:action_doing(k.input_actions.UP) then
                self.actions.double_action_up_doing = true
            else
                self.actions.double_action_up_doing = false
            end

            if self.actions.action_2_doing and self.input_prf:action_done_once(k.input_actions.DOWN) then
                self.actions.double_action_down_once = true
            else
                self.actions.double_action_down_once = false
            end

            if self.actions.action_2_doing and self.input_prf:action_doing(k.input_actions.DOWN) then
                self.actions.double_action_down_doing = true
            else
                self.actions.double_action_down_doing = false
            end

            if self.actions.action_2_doing and self.input_prf:action_done_once(k.input_actions.LEFT) then
                self.actions.double_action_left_once = true
            else
                self.actions.double_action_left_once = false
            end

            if self.actions.action_2_doing and self.input_prf:action_doing(k.input_actions.LEFT) then
                self.actions.double_action_left_doing = true
            else
                self.actions.double_action_left_doing = false
            end

            if self.actions.action_2_doing and self.input_prf:action_done_once(k.input_actions.RIGHT) then
                self.actions.double_action_right_once = true
            else
                self.actions.double_action_right_once = false
            end

            if self.actions.action_2_doing and self.input_prf:action_doing(k.input_actions.RIGHT) then
                self.actions.double_action_right_doing = true
            else
                self.actions.double_action_right_doing = false
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
        local canTurnWhileAction = false
        if self.interactive then
            if self.actions.action_2_doing then
                player.serializable.performing_action = true

                local cbks = { }

                cbks[k.actor_action_mode.SEARCH] = function()

                end

                cbks[k.actor_action_mode.COMBAT] = function()
                    player:set_anim(k.default_animations.FIGHT_POSITION)
                    player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                    canTurnWhileAction = true
                end

                cbks[k.actor_action_mode.EQUIP] = function()
                    if player.serializable.equip == nil then
                        log_debug('Cannot enable equip mode without any equipped weapon')
                        player.serializable.action_mode = k.actor_action_mode.COMBAT
                        return
                    end
                    local equippedWeapon = context_get_full_ref(player.serializable.equip)
                    local ratio = equippedWeapon:get_serializable_properties().weapon_properties.ratio
                    if (equippedWeapon.serializable.amount > 0 and self.actions.double_action_up_doing and(self.anim_timer > ratio / 2 or not self.init_timer)) or self.recoil_anim then
                        local fireAnim = equippedWeapon:get_properties().weapon_properties.fire_anim
                        self.recoil_anim = not lib.anim_finished(player.transient.entity, fireAnim)
                        if self.shot_ready then
                            equippedWeapon.serializable.amount = equippedWeapon.serializable.amount - 1
                            init_round(player, equippedWeapon, self.actors_manager)
                            self.shot_ready = false
                        end
                        self.init_timer = true
                        player:set_anim(fireAnim)
                        player:play(k.anim_modes.ANIM_MODE_LOOP, 0.15)
                        self.anim_timer = 0
                    else
                        self.shot_ready = equippedWeapon.serializable.amount > 0
                        local equipAnim = equippedWeapon:get_properties().weapon_properties.equip_anim
                        player:set_anim(equipAnim)
                        player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                    end
                    canTurnWhileAction = true

                end

                cbks[k.actor_action_mode.PUSH] = function()
                    player:set_anim(k.default_animations.PUSH)
                    player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                    canTurnWhileAction = false
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
        if not player.serializable.performing_action or canTurnWhileAction then
            player:rotate(0, 0, 150 * tpf * self.actions.rotate)
        end
        player:move_dir(tpf * self.actions.walkRatio)

        if self.anim_timer < k.DEFAULT_ANIM_TIMER_LIMIT then
            self.anim_timer = self.anim_timer + tpf
        else
            self.anim_timer = 0
        end

        update_rounds(self.actors_manager.scene_manager, tpf)

    end

    function player_actions_manager:set_interactive(flag)
        self.interactive = flag
    end


    return this
end

