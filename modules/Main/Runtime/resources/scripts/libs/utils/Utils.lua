-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Utils functions.
-- -


local debug_flag = false

function enable_debug()
    debug_flag = true
end
function disable_debug()
    debug_flag = false
end
function merge_tables(orig, new)
    local merge_task = { }
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

function table_contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local function log(msg)
    _hpms.log_msg(msg)
end
function log_debug(msg)
    if debug_flag then
        log('[LLUA-DEBUG] - ' .. tostring(msg))
    end
end
function log_info(msg)
    log('[LLUA-INFO ] - ' .. tostring(msg))
end
function log_warn(msg)
    log('[LLUA-WARN ] - ' .. tostring(msg))
end
function log_error(msg)
    log('[LLUA-ERROR] - ' .. tostring(msg))
    log('Exit: -2')
    os.exit(-2, true)

end

function filename()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end

--
-- Try/catch block simulation.
--
-- try {
--    function()
--       -- Throw some errors...
--       unsafe_function()
--    end,
--
--    catch {
--       function(error)
--          -- Error management
--          print('Got error ' .. error)
--       end
--    }
-- }

function try(what)
    status, result = pcall(what[1])
    if not status then
        what[2](result)
    end
    return result
end
function catch(what)
    return what[1]
end