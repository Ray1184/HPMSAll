--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Global state manager include save/load data.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/JsonHelper.lua'
}

global_state_manager = { }

function global_state_manager:new()
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()
    json = json_helper:get()
    local this = {
        module_name = 'global_state_manager'
    }
    log_debug('Creating global state manager')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function global_state_manager:get_session_var(name)
        return context_get_state(name)
    end

    function global_state_manager:put_session_var(name, val)
        context_put_state(name, val)
    end

    function global_state_manager:put_session_var_if_nil(name, val)
        if context_get_state(name) == nil then
            context_put_state(name, val)
        end
    end

    function global_state_manager:save_data(fileName, saveInfo)
        local saveData = {
            version = k.HPMS_VERSION,
            current_room = saveInfo.room_id,
            current_player_id = self:get_session_var(k.session_vars.CURRENT_PLAYER_ID),
            data = context_get_serializable_data(),
            progress = context_get_progress_state()
        }
        local saveDataJson = json.encode(saveData)
        lib.write_file(fileName, saveDataJson)
        log_info('Game saved at ' .. fileName)
    end


    function global_state_manager:load_data(fileName)
        local loadDataJson = lib.load_file(fileName)
        local loadData = json.decode(loadDataJson)
        context_set_serializable_data(loadData.data)
        context_set_progress_state(loadedData.progress)
        self:put_session_var(k.session_vars.CURRENT_PLAYER_ID, loadData.current_player_id)
        log_info('Game loaded from ' .. fileName)
        return loadData
    end

    return this
end