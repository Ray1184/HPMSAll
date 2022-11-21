--
-- Created by Ray1184.
-- DateTime: 04/10/2022 17:04
--
-- Generic based quest functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua'
}

quest_manager = { }


function quest_manager:new(sceneName)
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'quest_manager',
        events = { }
    }
    log_debug('Creating quest module for room ' .. sceneName)
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function quest_manager:trigger_event(condition, action, ...)
        table.insert(events, { condition = condition, action = action, args = ...})
        local progress = context_get_progress_state()
        if progress.game_state.rooms[sceneName] == nil then
            progress.game_state.rooms[sceneName] = {}
        end
    end

    function quest_manager:poll_events(tpf)
        local progress = context_get_progress_state()
        local sharedState = progress.game_state.shared
        local roomState = progress.game_state.rooms[sceneName]
        for i = 1, #self.events do
            local evt = events[i]
            if evt.condition(sharedState, roomState, tpf, evt.args) then
                evt.action(sharedState, roomState, tpf, evt.args)
            end
        end
    end


    function quest_manager:delete_all()
        -- Nothing to delete.
    end

    return this
end