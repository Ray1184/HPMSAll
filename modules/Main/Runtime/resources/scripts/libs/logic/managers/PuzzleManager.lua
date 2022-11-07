--
-- Created by Ray1184.
-- DateTime: 04/10/2022 17:04
--
-- Puzzle based quest functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua'
}

puzzle_manager = { }


function puzzle_manager:new(sceneName, puzzle)
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'puzzle_manager',

        -- 2D info
        background = puzzle.background,
        data_2d = puzzle.data,
        mechanism = puzzle.mechanism,
        init = puzzle.init,
        behavior = puzzle.behavior,
        work_area =
        {
            transient =
            {
                background = nil,
                images = { }
            }
        }
    }
    log_debug('Creating puzzle module for room ' .. sceneName)
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function puzzle_manager:init_puzzle()
        self.work_area.transient.background = lib.make_background(self.background)
        self.init(self.work_area)
        local zIndex = 1
        for k, v in pairs(self.data_2d) do
            self.work_area.transient.images[k] = image_2d:new(TYPE_POLYGON, v.shape, self.work_area[k].x, self.work_area[k].y, v.path, zIndex)
            zIndex = zIndex + 1
        end

    end

    function puzzle_manager:poll_events(tpf, mx, my)
        self.mechanism(self.work_area, tpf, mx, my)
        local allCompleted = true

        for k, v in pairs(self.behavior.fragments) do
            local pos = self.work_area.transient.images[k]:get_position()
            self.work_area[k].x = pos.x
            self.work_area[k].y = pos.y
            local fragCompleted = self.behavior.fragments[k].check_completed(self.work_area)
            allCompleted = allCompleted and fragCompleted
            if fragCompleted and self.behavior.fragments[k].on_complete ~= nil then
                self.behavior.fragments[k].on_complete(self.work_area)
            end
        end
        if allCompleted then
            self.behavior.on_complete()
        end
    end

    function puzzle_manager:delete_all()
        for k, v in pairs(self.data_2d) do
            self.work_area.transient.images[k]:delete()
        end
        lib.delete_background(self.work_area.transient.background)

    end

    return this
end