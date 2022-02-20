--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Common transform functions.
--

dependencies = { 'libs/backend/HPMSFacade.lua' }

transform = {}

function transform:get()
    lib = backend:get()
    return {
        -- Actors transformations.
        loc_rot_scale = function(actor, px, py, pz, rx, ry, rz, sx, sy, sz)
            actor.position = lib.vec3(px, py, pz)
            actor.rotation = lib.from_euler(lib.to_radians(rx), lib.to_radians(ry), lib.to_radians(rz))
            actor.scale = lib.vec3(sx, sy, sz)
        end,
        move = function(actor, x, y, z)
            actor.position = lib.vec3_add(actor.position, lib.vec3(x, y, z))
        end,
        move_collisor_towards_direction = function(coll, ratio)
            local dir = lib.get_direction(coll.rotation, lib.vec3(0, 0, 1))
            local nextPos = lib.vec3_add(coll.position, lib.vec3(ratio * dir.x, 0, ratio * dir.z))
            lib.move_collisor_dir(coll, nextPos, lib.vec2(dir.x, dir.z))
        end,
        move_towards_direction = function(actor, ratio)
            local dir = lib.get_direction(actor.rotation, lib.vec3(0, 0, 1))
            actor.position = lib.vec3_add(actor.position, lib.vec3(ratio * dir.x, 0, ratio * dir.z))
        end,
        rotate = function(actor, rx, ry, rz)
            actor.rotation = lib.quat_mul(actor.rotation, lib.from_euler(lib.to_radians(rx), lib.to_radians(ry), lib.to_radians(rz)))
        end
    }
end