--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Language manager.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/JsonHelper.lua'
}

bundle_manager = { }

function bundle_manager:new()
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()
    json = json_helper:get()
    local this = {
        module_name = 'bundle_manager'
    }
    log_debug('Creating scene module for room')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function bundle_manager:register_dictionary(dict)
        context_set_bundles(merge_tables(context_get_bundles(), dict))
    end

    function bundle_manager:msg(key)
        local lang = context_get_lang()
        local message = context_get_bundles()[lang][key]
        if message == nil then
            log_warn('No message bundle found for key ' .. tostring(key))
            return key
        end
        return message
    end
    
    return this
end