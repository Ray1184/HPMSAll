---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Wrapper for cached context.
---
dependencies = { 'libs/utils/Utils.lua' }

context = {}

cats = {
    STATE = 'state',
    OBJECTS = 'objects',
    EVENTS = 'events',
    LANG = 'lang',
    MISC = 'misc'
}

function context:new()
    local ctx = { dummy = false }
    log_debug('Creating context with categories:')
    for k, v in pairs(cats) do
        ctx[v] = {}
        log_debug('- ' .. v)
    end
    setmetatable(ctx, self)
    self.__index = self
    return ctx
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
        log_debug('New context created')
        self.instance = self:new()
    end
    return self.instance
end

function context:put_state(key, obj)
    if key == nil then
        log_warn('Key cannot be nil')
        return
    end
    self.instance[cats.STATE][key] = obj
end

function context:put(cat, key, obj)
    if cat == nil then
        log_warn('Cannot put in context object with nil category')
        return
    elseif self.instance[cat] == nil then
        log_warn('Cannot put in context object: ' .. cat .. ' category unknown')
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
    self.instance[cat][key] = obj.serializable
end

function context:get_state(key)
    if key == nil then
        log_error('State object nil not allowed')
        return nil
    end
    if self.instance[cats.STATE][key] == nil then
        log_error('State object ' .. key .. ' was not initialized in context')
        return nil
    end
    return self.instance[cats.STATE][key]
end

function context:get(cat, key, supplier_callback)
    if self.instance[cat] == nil then
        if cat == nil then
            log_warn('Cannot get object from context with nil category')
        else
            log_warn('Cannot get object from context: ' .. cat .. ' category unknown')
        end
        return nil
    end
    if self.instance[cat][key] == nil then
        if key == nil then
            log_warn('Cannot get object from context with nil key')
            return nil
        else
            self.instance:put(cat, key, supplier_callback())
        end
    end
    log_debug('Object with key ' .. key .. ' and category ' .. cat .. ' found/created in context')
    local obj = {}
    obj.serializable = self.instance[cat][key]
    return obj
end
