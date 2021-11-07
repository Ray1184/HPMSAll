---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Utils functions.
---

local debug_flag = false

function enable_debug()
    debug_flag = true
end
function disable_debug()
    debug_flag = false
end
function merge_tabs(orig, new)
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
                if (old_type == 'table' and new_type == 'table') then
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
end
function log_debug(msg)
    if debug_flag then
        print('[LUA-DEBUG]  ' .. msg)
    end
end
function log_info(msg)
    print('[LUA-INFO ]  ' .. msg)
end
function log_warn(msg)
    print('[LUA-WARN ]  ' .. msg)
end
function log_error(msg)
    print('[LUA-ERROR]  ' .. msg)
    print('Exit: -2')
    os.exit(-2, true)

end
