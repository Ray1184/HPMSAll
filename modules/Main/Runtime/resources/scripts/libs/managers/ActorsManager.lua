-- -
--- Created by Ray1184.
--- DateTime: 04/10/2021 17:04
-- -
--- Actors management functions.
-- -

dependencies = {
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua'
}

actor_manager = { }

function actor_manager:new(scene_manager)
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'actor_manager',

        -- Room info
        scene_manager = scene_manager,

        -- Backend data ref
        loaded_actors = { },
        walkmaps = { }
    }
    log_debug('Creating actor module for room')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    return this
end