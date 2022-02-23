--
-- Created by Ray1184.
-- DateTime: 04/11/2021 17:04
--
-- Presets cinematics sequences.
--

dependencies = {
    'libs/utils/Utils.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/strats/Cinematics.lua',
    'libs/backend/HPMSFacade.lua'
}

cinematics_sequences = { }

function cinematics_sequences:new()
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local this = {
        module_name = 'cinematics_sequences'
    }

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function cinematics_sequences:motion_path_with_look_at(actor, target, animated, moveSpeed, rotateSpeed, nearTreshold, angleTreshold, animation, animSpeed)
        return {
            action = function(tpf, timer)
                local angle = math.abs(lib.look_collisor_at(actor.transient.collisor, lib.vec3(target.x, target.y, target.z), tpf *(rotateSpeed or 1) / 4))
                if animated then
                    actor:set_anim(animation or 'Walk_Forward')
                    actor:play(ANIM_MODE_LOOP, animSpeed or 1)
                end
                if angle <(angleTreshold or lib.to_radians(180)) then
                    actor:move_dir(tpf *(-moveSpeed or -1))
                end
            end,
            complete_on = function(tpf, timer)
                local actorPos = lib.vec2(actor:get_position().x, actor:get_position().y)
                local finalPos = lib.vec2(target.x, target.y)
                local reached = lib.vec2_dist(actorPos, finalPos) <(nearTreshold or 0.01)
                if reached then
                    if animated then
                        actor:set_anim('Idle')
                        actor:play(ANIM_MODE_LOOP, animSpeed or 1)
                    end
                    return true
                else
                    return false
                end
            end
        }
    end

    return this
end