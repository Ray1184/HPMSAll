--
-- Created by Ray1184.
-- DateTime: 04/11/2021 17:04
--
-- Presets cinematics flow patterns.
--

dependencies = {
    'libs/utils/Utils.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/strats/Cinematics.lua',
    'libs/backend/HPMSFacade.lua'
}

presets_cinematics = { }

function presets_cinematics:new()
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local this = {
        module_name = 'presets_cinematics'
    }

    function presets_cinematics:motion_paths(actor, paths, condition, finished, animation, speed, threshold)
        local cin = cinematics:new()
        for i = 1, #self.paths do
            cin:add_workflow( {
                {
                    action = function(tpf, timer)
                        local path = #self.paths[i]
                        lib.look_collisor_at(actor.transient.collisor, lib.vec3(path.x, path.y, path.z), tpf)
                        if animation ~= nil then
                            actor:set_anim(animation)
                            actor:play(ANIM_MODE_LOOP, speed)
                        end
                    end,
                    complete_on = function(tpf, timer)
                        local actorPos = lib.vec2(actor:get_position().x, actor:get_position().y)
                        local finalPos = lib.vec2(path.x, path.y)
                        return lib.vec2_dist(actorPos, finalPos) < threshold or 0.01
                    end
                }
            } , condition, finished)

        end
    end

    return this
end