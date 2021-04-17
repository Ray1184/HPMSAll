require('data/scripts/libs/Context')
utils = require('data/scripts/libs/Utils')

if context:inst().dummy then
    return {
        -- Asset functions.
        make_entity = function(path)
            return { dummy_id = 'Entity[' .. path .. ']' }
        end,

        delete_entity = function(e)
            utils.debug('Deleting ' .. e.dummy_id)
        end,

        make_node = function(name)
            return { dummy_id = 'Node[' .. name .. ']' }
        end,

        delete_node = function(n)
            utils.debug('Deleting ' .. n.dummy_id)
        end,

        make_animator = function(e)
            return { dummy_id = 'Animator[' .. e.dummy_id .. ']' }
        end,

        delete_animator = function(a)
            utils.debug('Deleting ' .. a.dummy_id)
        end,

        make_collisor = function(n, w, t)
            return { dummy_id = 'Collisor[' .. n.dummy_id .. ']' }
        end,

        delete_collisor = function(c)
            utils.debug('Deleting ' .. c.dummy_id)
        end,

        set_node_entity = function(n, e)
            utils.debug('Attaching entity ' .. e.dummy_id .. ' to node ' .. n.dummy_id)
        end,

        add_node_to_scene = function(n, scene)
            utils.debug('Attaching node ' .. n.dummy_id .. ' to scene')
        end,

        -- Logic.
        move_collisor_dir = function(c, v3, v2)
            return {}
        end,

        rotate = function(a, rx, ry, rz)
            utils.debug('Rotating actor ' .. a.dummy_id)
        end,

        add_anim = function(a, name, from, to)
            utils.debug('Adding anim ' .. name .. ' to '.. a.dummy_id)
        end,

        set_anim = function(a, name)
            utils.debug('Setting anim ' .. name .. ' for '.. a.dummy_id)
        end,

        rewind_anim = function(a)
            utils.debug('Rewinding anim for '.. a.dummy_id)
        end,

        anim_sequence_terminated = function(a)
            return false
        end,

        update_controller = function(ctrl, type)

        end,

        -- Math functions.
        vec3 = function(x, y, z)
            return {}
        end,

        vec2 = function(x, y)
            return {}
        end,

        from_euler = function(a, b, g)
            return {}
        end,

        vec3_add = function(v1, v2)
            return {}
        end,

        quat_mul = function(q1, q2)
            return {}
        end,

        get_direction = function(q, v)
            return {}
        end,

        to_radians = function(a)
            return {}
        end


    }
else

    return {
        -- Asset functions.
        make_entity = hpms.make_entity,
        delete_entity = hpms.delete_entity,
        make_node = hpms.make_node,
        delete_node = hpms.delete_node,
        make_animator = hpms.make_animator,
        delete_animator = hpms.delete_animator,
        make_collisor = hpms.make_node_collisor,
        delete_collisor = hpms.delete_node_collisor,
        set_node_entity = hpms.set_node_entity,
        add_node_to_scene = hpms.add_node_to_scene,

        -- Logic.
        move_collisor_dir = hpms.move_collisor_dir,
        rotate = hpms.rotate,
        add_anim = hpms.add_anim,
        set_anim = hpms.set_anim,
        rewind_anim = hpms.rewind_anim,
        anim_sequence_terminated = hpms.anim_sequence_terminated,
        update_controller = function(ctrl, type)
            if type == 'animator' or type == 'ANIMATOR' then
                update_animator(ctrl)
            elseif type == 'collisor' or type == 'COLLISOR' then
                update_collisor(ctrl)
            end
        end,

        -- Math functions.
        vec3 = hpms.vec3,
        vec2 = hpms.vec2,
        from_euler = hpms.from_euler,
        vec3_add = hpms.vec3_add,
        quat_mul = hpms.quat_mul,
        get_direction = hpms.get_direction,
        to_radians = hpms.to_radians
    }

end
