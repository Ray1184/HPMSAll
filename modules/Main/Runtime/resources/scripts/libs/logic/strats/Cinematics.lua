--
-- Created by Ray1184.
-- DateTime: 04/11/2021 17:04
--
-- Utilities for preset actions flow.
-- Input example:
-- workflow = {
--               {action = function(tpf, timer) walks:walk_to_sector(player, 'SG05'))   end, complete_on = function(tpf, timer) player:get_sector == 'SG05'  end},
--               {action = function(tpf, timer)                                         end, complete_on = function(tpf, timer) timer > 5000                 end},
--               {action = function(tpf, timer) walks:walk_to_sector(player, 'SG05'))   end, complete_on = function(tpf, timer) player:get_sector == 'SG05'  end},
--            }
-- cinematics.execute(workflow}
-- Each flow sequence has two callbacks, one is the action to be executed, other one the condition to be completed.
--

dependencies = {
    -- 'libs/utils/Utils.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/backend/HPMSFacade.lua'
}

cinematics = { }

function cinematics:new(sceneMgr)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local this = {
        module_name = 'cinematics',
        workflows = { },
        scene_manager = sceneMgr
    }
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function cinematics:add_workflow(sequences, condition, loop, name)
        local workflow = {
            sequences = sequences,
            condition = condition or nil,
            loop = loop or false,
            expired = false,
            main_condition_verified = false,
            name = name or 'undef'
        }
        table.insert(self.workflows, workflow)
    end

    function cinematics:poll_events(tpf)
        if self.scene_manager:is_paused() then
            return
        end
        for i = 1, #self.workflows do
            if not self.workflows[i].expired then
                local conditionVer = self.workflows[i].condition == nil or self.workflows[i].condition()
                if conditionVer then
                    self.workflows[i].main_condition_verified = true
                end
                if self.workflows[i].main_condition_verified then
                    self:process_workflow(self.workflows[i], tpf)
                end
            end
        end
    end

    function cinematics:process_workflow(workflow, tpf)
        if workflow.expired then
            return
        end
        local allDone = true
        for i = 1, #workflow.sequences do
            if workflow.sequences[i].completed == nil then
                self:process_sequence(workflow.sequences[i], tpf)
                allDone = false
                return
            end
        end
        if allDone then
            if workflow.loop then
                allDone = false
                self:reset_workflow(workflow)
            else
                workflow.expired = true
            end
        end
    end

    function cinematics:process_sequence(sequence, tpf)
        if sequence.timer == nil then
            sequence.timer = 0
        end
        sequence.action(tpf, sequence.timer)
        sequence.timer = sequence.timer + tpf
        if sequence.timer >= k.DEFAULT_WORKFLOW_TIMER_LIMIT then
            sequence.timer = 0
        end
        if sequence.complete_on(tpf, sequence.timer) then
            sequence.completed = true
        end
    end

    function cinematics:reset_workflow(workflow)
        for i = 1, #workflow.sequences do
            workflow.sequences[i].completed = nil
            workflow.sequences[i].timer = 0
            workflow.main_condition_verified = false
        end
    end

    return this
end

