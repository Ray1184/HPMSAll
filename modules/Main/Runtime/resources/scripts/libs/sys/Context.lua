--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- DO NOT INCLUDE THIS!!!
--

context = { }



function context:new()

    cats = {
        STATE = 'state',
        EVENTS = 'events',
        SERIALIZABLES = 'serializables',
        INSTANCES = 'instances',
        FULL_REFS = 'full_refs',
        BUNDLES = 'bundles',

    }

    local ctx = { dummy = false }
    log_info('Creating context with categories:')
    for kc, v in pairs(cats) do
        ctx[v] = { }
        log_info('- ' .. v)
    end
    setmetatable(ctx, self)
    self.__index = self
    return ctx
end

function context:set_serializable_data(data)
    self.instance[cats.SERIALIZABLES] = data
end

function context:get_serializable_data()
    return self.instance[cats.SERIALIZABLES]
end

function context:set_bundles(data)
    self.instance[cats.BUNDLES] = data
end

function context:get_bundles()
    return self.instance[cats.BUNDLES]
end

function context:set_coord_system_blender()
    self.instance.coord_system = 'blender'
end

function context:set_coord_system_gl()
    self.instance.coord_system = 'gl'
end

function context:is_coord_system_blender()
    return self.instance.mode == 'blender'
end

function context:is_coord_system_gl()
    return self.instance.mode == 'gl'
end

function context:set_mode_r25d()
    self.instance.mode = 'r25d'
end

function context:set_mode_3d()
    self.instance.mode = '3d'
end

function context:set_mode_gui()
    self.instance.mode = 'gui'
end

function context:is_mode_r25d()
    return self.instance.mode == 'r25d'
end

function context:is_mode_3d()
    return self.instance.mode == '3d'
end

function context:is_mode_gui()
    return self.instance.mode == 'gui'
end

function context:set_scene(s)
    self.instance.scene = s
end

function context:get_scene()
    if self.instance.scene == nil then
        log_warn('Scene is nil in context')
    end
    return self.instance.scene
end

function context:set_camera(c)
    self.instance.camera = c
end

function context:get_camera()
    if self.instance.camera == nil then
        log_warn('Camera is nil in context')
    end
    return self.instance.camera
end

function context:set_input_profile(prof)
    self.instance.input_profile = prof
end

function context:get_input_profile()
    if self.instance.input_profile == nil then
        self.instance.input_profile = 'default'
    end
    return self.instance.input_profile
end

function context:set_lang(lang)
    self.instance.lang = lang
end

function context:get_lang()
    if self.instance.lang == nil then
        self.instance.lang = 'it'
    end
    return self.instance.lang
end

function context:enable_dummy()
    log_debug('Dummy mode ENABLED')
    self.instance.dummy = true
end

function context:disable_dummy()
    log_debug('Dummy mode DISABLED')
    self.instance.dummy = false
end

function context:is_dummy()
    return self.instance.dummy == true
end

function context:inst()
    if self.instance == nil then
        log_info('New context created')
        self.instance = self:new()
    end
    return self.instance
end

function context:put_full_ref_obj(obj)
    self.instance:put_full_ref(obj.serializable.id, obj)
end

function context:put_full_ref(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    self.instance[cats.FULL_REFS][key] = obj
end

function context:get_full_ref(key)
    if key == nil then
        log_error('Key cannot be nil')
        return nil
    end
    if self.instance[cats.FULL_REFS][key] == nil then
        log_warn('FullRef object ' .. key .. ' is nil in context')
        return nil
    end
    return self.instance[cats.FULL_REFS][key]
end

function context:put_state(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    self.instance[cats.STATE][key] = obj
end

function context:get_state(key)
    if key == nil then
        log_error('Key cannot be nil')
        return nil
    end
    if self.instance[cats.STATE][key] == nil then
        log_warn('State object ' .. key .. ' is nil in context')
        return nil
    end
    return self.instance[cats.STATE][key]
end


function context:put_event(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    self.instance[cats.EVENTS][key] = obj
    log_warn('instnace: ' .. tostring(self.instance[cats.EVENTS][key].id))
end

function context:get_all_events()
    return self.instance[cats.EVENTS]
end

function context:get_event(key)
    if key == nil then
        log_error('Key cannot be nil')
        return nil
    end
    if self.instance[cats.EVENTS][key] == nil then
        log_warn('Event object ' .. key .. ' is nil in context')
        return nil
    end
    return self.instance[cats.EVENTS][key]
end

function context:remove_event(key)
    if key == nil then
        log_error('Key cannot be nil')
        return nil
    end
    self.instance[cats.EVENTS][key] = nil
end

function context:register_instance(subcat, id, retrieveCallback)
    self.instance[cats.INSTANCES][subcat .. '/' .. id] = retrieveCallback
end

function context:get_instance(subcat, id, ...)
    local inst = self.instance[cats.INSTANCES][subcat .. '/' .. id]
    if inst ~= nil then
        return inst(...)
    end
    log_warn('No instances availables with id ' .. tostring(subcat) .. '/' .. tostring(id))
    return nil
end

function context:put_object(key, obj)
    if self.instance[cats.SERIALIZABLES] == nil then
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
    self.instance[cats.SERIALIZABLES][key] = obj.serializable
end

function context:get_object(key, persist, supplierCallback)
    if not persist then
        return supplierCallback()
    end
    if self.instance[cats.SERIALIZABLES][key] == nil then

        if key == nil then
            log_warn('Cannot get object from context with nil key')
            return nil
        else
            log_debug('Object with key ' .. tostring(key) .. ' NOT found/created in context')
            self.instance:put_object(key, supplierCallback())
        end
    end
    local obj = { }
    obj.serializable = self.instance[cats.SERIALIZABLES][key]
    return obj
end
