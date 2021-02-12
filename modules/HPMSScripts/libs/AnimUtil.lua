---
--- Created by Ray1184.
--- DateTime: 04/11/2020 17:04
---
--- Animation utilities.
---

local lib = require('data/scripts/libs/HPMSFacade')
local anim_by_entity = {}

return {
    play = function(strategy)
        local animator = strategy.animator
        local anim_sets = strategy.anim_sets
        for index = 1, #anim_sets do
            local sequence = anim_sets[index][1]
            local condition = anim_sets[index][2]
            if condition() and anim_by_entity[animator.id] ~= sequence and lib.anim_sequence_terminated(a) then
                anim_by_entity[animator.id] = sequence
                lib.set_anim(animator, sequence)
                lib.rewind_anim(animator)
                return
            end
        end
    end
}