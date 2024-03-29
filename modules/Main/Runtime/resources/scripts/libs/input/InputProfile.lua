--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Input actions keys profiles.
--


dependencies = {
    'libs/utils/MathUtils.lua',
    'libs/thirdparty/JsonHelper.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

local actions_path = 'data/input/KeyProfiles.json'

input_profile = { }

function input_profile:new(profile)
    json = json_helper:get()
    lib = backend:get()
    insp = inspector:get()
    k = game_mechanics_consts:get()
    local this = {
        module_name = 'input_profile',
        keys_map = { },
        profile = profile,
        state = { },
        mouse_pressed_once = false,
        mouse_pressed = false

    }
    log_debug('Creating input mapping from ' .. actions_path .. ' with profile \'' .. profile .. '\'')
    local content = lib.load_file(actions_path)
    this.keys_map = json.decode(content)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function input_profile:to_key(action, customProf)
        return self.keys_map[customProf or self.profile][action]
    end

    function input_profile:action_done_once(action)
        if self.state[action] == k.input_modes.PRESSED_FIRST_TIME then
            self.state[action] = k.input_modes.NONE
            return true
        end
        return false
    end

    function input_profile:action_doing(action)
        return self.state[action] == k.input_modes.PRESSED
    end

    function input_profile:action_terminated(action)
        if self.state[action] == k.input_modes.RELEASED then
            self.state[action] = k.input_modes.NONE
            return true
        end
        return false
    end

    function input_profile:poll_inputs(keys, mouseButtons)
        self.state = { }
        if keys ~= nil then
            for kc, v in pairs(self.keys_map[self.profile]) do
                local mapped = kc
                local keycode = v
                if lib.key_action_performed(keys, keycode, k.input_modes.PRESSED_FIRST_TIME) then
                    self.state[kc] = k.input_modes.PRESSED_FIRST_TIME
                elseif lib.key_action_performed(keys, keycode, k.input_modes.PRESSED) then
                    self.state[kc] = k.input_modes.PRESSED
                elseif lib.key_action_performed(keys, keycode, k.input_modes.RELEASED) then
                    self.state[kc] = k.input_modes.RELEASED
                else
                    self.state[kc] = k.input_modes.NONE
                end
            end
        end
        --mbutton_action_performed
        self.mouse_pressed_once = lib.mbutton_action_performed(mouseButtons, 'LEFT', 1)
        self.mouse_pressed = lib.mbutton_action_performed(mouseButtons, 'LEFT', 2)
    end

    return this
end