-- -
--- Created by Ray1184.
--- DateTime: 04/10/2021 17:04
-- -
--- Input actions keys profiles.
-- -


dependencies = {
    'libs/utils/MathUtils.lua',
    'libs/thirdparty/JsonHelper.lua'
}

local actions_path = 'data/input/KeyProfiles.json'

input_profile = { }

function input_profile:load(profile)
    json = json_helper:get()
    local f = io.open(actions_path, 'r')
    if f ~= nil then
        content = f:read('*all')
        dofile(console_path)
        f:close()
    else
        log_debug('Input profile \'' .. name .. '\' not available on filesystem')
    end
    this = json.decode(content)
    setmetatable(this, self)
    self.__index = self

    function input_profile:to_key(action)
        return self[profile][action]
    end
end