--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Utils functions.
--

local charset = { }  
do
    -- [0-9a-zA-Z]
    for c = 48, 57 do table.insert(charset, string.char(c)) end
    for c = 65, 90 do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local debug_flag = false

function enable_debug()
    debug_flag = true
end
function disable_debug()
    debug_flag = false
end
function merge_tables(orig, new)
    local mergeTask = { }
    mergeTask[orig] = new

    local left = orig
    while left ~= nil do
        local right = mergeTask[left]
        for newKey, newVal in pairs(right) do
            local oldVal = left[newKey]
            if oldVal == nil then
                left[newKey] = newVal
            else
                local oldType = type(oldVal)
                local newType = type(newVal)
                if (oldType == 'table' and newType == 'table') then
                    mergeTask[oldVal] = newVal
                else
                    left[newKey] = newVal
                end
            end
        end
        mergeTask[left] = nil
        left = next(mergeTask)
    end
    return orig
end

local function remove_by_key(tab, val)
    for i, v in ipairs(tab) do
        if (v.id == val) then
            tab[i] = nil
        end
    end
end

function safe_string(str)
    local ret = ''
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == 'è' or c == 'é' then
            ret = ret .. 'e\''
        elseif c == 'ò' then
            ret = ret .. 'o\''
        elseif c == 'à' then
            ret = ret .. 'a\''
        elseif c == 'ì' then
            ret = ret .. 'i\''
        elseif c == 'ù' then
            ret = ret .. 'u\''
        else
            ret = ret .. c
        end
    end
    return ret
end

function array_contains(array, val)
    for i = 1, #array do
        if array[i] == val then
            return true
        end
    end
    return false
end

function table_contains(table, val)
    for k, v in pairs(table) do
        if table[k] == val then
            return true
        end
    end
    return false
end

function random_string(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock() ^ 5)
    return random_string(length - 1) .. charset[math.random(1, #charset)]
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