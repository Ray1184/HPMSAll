---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Utils functions.
---
local debug_flag = false
return {
    enable_debug = function()
        debug_flag = true
    end,
    disable_debug = function()
        debug_flag = false
    end,
    merge = function(orig, new)
        local merge_task = {}
        merge_task[orig] = new

        local left = orig
        while left ~= nil do
            local right = merge_task[left]
            for new_key, new_val in pairs(right) do
                local old_val = left[new_key]
                if old_val == nil then
                    left[new_key] = new_val
                else
                    local old_type = type(old_val)
                    local new_type = type(new_val)
                    if (old_type == "table" and new_type == "table") then
                        merge_task[old_val] = new_val
                    else
                        left[new_key] = new_val
                    end
                end
            end
            merge_task[left] = nil
            left = next(merge_task)
        end
        return orig
    end,
    debug = function(msg)
        if debug_flag then
            print('[LUA-DEBUG]  ' .. msg)
        end
    end,
    warn = function(msg)
        print('[LUA-WARN ]  ' .. msg)
    end,
    error = function(msg)
        print('[LUA-ERROR]  ' .. msg)
        print('Exit: -2')
        os.exit(-2, true)

    end

}