---
--- Created by Ray1184.
--- DateTime: 04/07/2021 17:04
---
--- Debug shell.
---

dependencies = { 'libs/utils/Utils.lua' }

local console_path = 'Console.lua'

function debug_console_exec()
    local f = io.open(console_path, 'r')
    if f ~= nil then
        local content = f:read('*all')
        log_debug('Executing LUA code: ' .. content)
        dofile(console_path)
        f:close()
    else
        log_debug('Console disabled, create Console.lua to enabled it')
    end
end



