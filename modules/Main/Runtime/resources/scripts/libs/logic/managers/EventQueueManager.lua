--
-- Created by Ray1184.
-- DateTime: 04/03/2022 17:04
--
-- Queue for push and consume event between rooms.
--

dependencies = {
    'libs/backend/HPMSFacade.lua'
}

event_queue_manager = { }

function event_queue_manager:new()
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'event_queue_manager'
    }
    log_debug('Creating event queue module')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function event_queue_manager:push(event)
        context_put_event(event.id, event)
        log_debug('Event ' .. event.id .. ' pushed in events queue')
    end

    function event_queue_manager:consume(id)
        local event = context_get_event(id)
        if event ~= nil and(event.condition == nil or event.condition()) then
            event.action()
            context_remove_event(id)
            log_debug('Event ' .. event.id .. ' consumed from events queue')
        end
    end

    function event_queue_manager:consume_all()
        local allEvents = context_get_all_events()
        for eventId, event in pairs(allEvents) do
            self:consume(eventId)
        end      
    end


    return this
end