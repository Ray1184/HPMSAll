--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- DO NOT INCLUDE THIS!!!
--

dependencies = {
    'libs/thirdparty/Inspect.lua'
}

local charset = { }  
do
    -- [0-9a-zA-Z]
    for c = 48, 57 do table.insert(charset, string.char(c)) end
    for c = 65, 90 do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local numbers = { }  
do
    -- [0-9a-zA-Z]
    for i = 0, 9 do table.insert(numbers, i) end
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

function array_filter(array, filterCallback)
    local newArray = { }
    for i = 1, #array do
        if filterCallback(array[i]) then
            table.insert(newArray, array[i])
        end
    end
    return newArray;
end

function table_empty(tab)
    for i, v in pairs(tab) do
        if v ~= nil then
            return false
        end
    end
    return true
end

function safe_string(str)
    str = str or ''
    local ret = ''
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '�' or c == '�' then
            ret = ret .. 'e\''
        elseif c == '�' then
            ret = ret .. 'o\''
        elseif c == '�' then
            ret = ret .. 'a\''
        elseif c == '�' then
            ret = ret .. 'i\''
        elseif c == '�' then
            ret = ret .. 'u\''
        else
            ret = ret .. c
        end
    end
    return ret
end

function string_split(str, sep)
    local result = { }
    local regex =("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
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

function random_range(min, max)
    math.randomseed(os.clock() ^ 5)
    return math.random(min, max)
end

local function is_array(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
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

function obj_to_str(o)
    insp = inspector:get()
    if o == nil then
        return 'nil'
    else
        return insp.inspect(o)
    end
end

function get_full_id_parts(fullId)
    local token = string_split(fullId, '/')
    local id = token[2]
    local room = token[3]
    local index = token[4]
    local suffix = room .. '/' .. index
    return id, suffix
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