--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- DO NOT INCLUDE THIS!!!
--

local context = { dummy = false }

local cats = {
    STATE = 'state',
    EVENTS = 'events',
    SERIALIZABLES = 'serializables',
    INSTANCES = 'instances',
    FULL_REFS = 'full_refs',
    VOLATILES = 'volatiles',
    BUNDLES = 'bundles',

}
local function init_lua_context()
    log_info('Creating context with categories:')
    for kc, v in pairs(cats) do
        context[v] = { }
        log_info('- ' .. v)
    end
    context.global_counter = 0
end

init_lua_context() 

function context_set_serializable_data(data)
    context[cats.SERIALIZABLES] = data
end

function context_update_serializable_data_obj(data)
    context_update_serializable_data(data.id, data)
end

function context_update_serializable_data(id, data)
    context[cats.SERIALIZABLES][id] = data
end

function context_update_full_ref_data(id, data)
    if context_get_full_ref(id) ~= nil then
        local oldFullRef = context_get_full_ref(id)
        oldFullRef.serializable = data
        context_put_full_ref(oldFullRef)
    end
end

function context_get_serializable_data()
    return context[cats.SERIALIZABLES]
end

function context_set_bundles(data)
    context[cats.BUNDLES] = data
end

function context_get_bundles()
    return context[cats.BUNDLES]
end

function context_set_coord_system_blender()
    context.coord_system = 'blender'
end

function context_set_coord_system_gl()
    context.coord_system = 'gl'
end

function context_is_coord_system_blender()
    return context.mode == 'blender'
end

function context_is_coord_system_gl()
    return context.mode == 'gl'
end

function context_set_mode_r25d()
    context.mode = 'r25d'
end

function context_set_mode_3d()
    context.mode = '3d'
end

function context_set_mode_gui()
    context.mode = 'gui'
end

function context_is_mode_r25d()
    return context.mode == 'r25d'
end

function context_is_mode_3d()
    return context.mode == '3d'
end

function context_is_mode_gui()
    return context.mode == 'gui'
end

function context_set_scene(s)
    context.scene = s
end

function context_get_scene()
    if context.scene == nil then
        log_warn('Scene is nil in context')
    end
    return context.scene
end

function context_set_camera(c)
    context.camera = c
end

function context_get_camera()
    if context.camera == nil then
        log_warn('Camera is nil in context')
    end
    return context.camera
end

function context_set_input_profile(prof)
    context.input_profile = prof
end

function context_get_input_profile()
    if context.input_profile == nil then
        context.input_profile = 'default'
    end
    return context.input_profile
end

function context_set_lang(lang)
    context.lang = lang
end

function context_get_lang()
    if context.lang == nil then
        context.lang = 'it'
    end
    return context.lang
end

function context_enable_dummy()
    log_debug('Dummy mode ENABLED')
    context.dummy = true
end

function context_disable_dummy()
    log_debug('Dummy mode DISABLED')
    context.dummy = false
end

function context_is_dummy()
    return context.dummy == true
end

function context_put_full_ref_obj(obj)
    context_put_full_ref(obj.serializable.id, obj)
end

function context_put_full_ref(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    context[cats.FULL_REFS][key] = obj
end

function context_get_full_ref(key)
    if key == nil then
        log_warn('Key cannot be nil')
        return nil
    end
    if context[cats.FULL_REFS][key] == nil then
        log_info('FullRef object ' .. key .. ' is nil in context')
        return nil
    end
    return context[cats.FULL_REFS][key]
end

function context_put_state(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    context[cats.STATE][key] = obj
end

function context_get_state(key)
    if key == nil then
        log_warn('Key cannot be nil')
        return nil
    end
    if context[cats.STATE][key] == nil then
        log_warn('State object ' .. key .. ' is nil in context')
        return nil
    end
    return context[cats.STATE][key]
end


function context_put_event(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    context[cats.EVENTS][key] = obj
end

function context_get_all_events()
    return context[cats.EVENTS]
end

function context_get_event(key)
    if key == nil then
        log_warn('Key cannot be nil')
        return nil
    end
    if context[cats.EVENTS][key] == nil then
        log_warn('Event object ' .. key .. ' is nil in context')
        return nil
    end
    return context[cats.EVENTS][key]
end

function context_remove_event(key)
    if key == nil then
        log_warn('Key cannot be nil')
        return nil
    end
    context[cats.EVENTS][key] = nil
end

function context_register_instance(subcat, id, retrieveCallback)
    context[cats.INSTANCES][subcat .. '/' .. id] = retrieveCallback
end

function context_get_instance(subcat, id, ...)
    local inst = context[cats.INSTANCES][subcat .. '/' .. id]
    if inst ~= nil then
        return inst(...)
    end
    log_warn('No instances availables with id ' .. tostring(subcat) .. '/' .. tostring(id))
    return nil
end

function context_put_object(key, obj)
    if context[cats.SERIALIZABLES] == nil then
        log_warn('Cannot put in context object: ' .. tostring(cat) .. ' category unknown')
        return
    end

    if key == nil then
        log_warn('Key cannot be nil')
        return
    end

    if obj.serializable == nil then
        log_warn('For put object in context this must have a serializable block')
        return
    end
    context[cats.SERIALIZABLES][key] = obj.serializable
end

function context_get_object(key, persist, supplierCallback)
    if not persist then
        return supplierCallback()
    end
    if context[cats.SERIALIZABLES][key] == nil then

        if key == nil then
            log_warn('Cannot get object from context with nil key')
            return nil
        else
            log_debug('Object with key ' .. tostring(key) .. ' NOT found/created in context')
            context_put_object(key, supplierCallback())
        end
    end
    local obj = { }
    obj.serializable = context[cats.SERIALIZABLES][key]
    return obj
end

function increase_and_get_global_counter()
    context.global_counter = context.global_counter + 1
    return context.global_counter
end

local function context_reset_global_counter_if_empty()
    if table_empty(context[cats.VOLATILES]) then
        context.global_counter = 0
    end
end

function context_put_volatile(vol)
    local id = 'volatile/' .. tostring(increase_and_get_global_counter())
    vol.not_serializable.id = id
    context[cats.VOLATILES][id] = vol
end

function context_foreach_alive_volatile(filter, callback)
    for i, v in pairs(context[cats.VOLATILES]) do
        if v ~= nil and filter(v) then
            callback(v)
        end
    end
end

function context_delete_all_volatile()
    for i, v in pairs(context[cats.VOLATILES]) do
        if v ~= nil then
            v:delete_transient_data()
        end
    end
    context.global_counter = 0
    context[cats.VOLATILES] = { }
end

function context_remove_volatile(vol)
    context[cats.VOLATILES][vol.not_serializable.id] = nil
    context_reset_global_counter_if_empty()
end
