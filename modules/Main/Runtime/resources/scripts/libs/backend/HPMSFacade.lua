--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- C++ backend facade.
--

backend = { }

function backend:get()
    if context_is_dummy() then
        log_debug('Using DUMMY functions')
        return {

            -- Asset functions.
            make_entity = function(path)
                return { dummy_id = 'StandardEntity[' .. path .. ']' }
            end,

            make_depth_entity = function(path)
                return { dummy_id = 'DepthEntity[' .. path .. ']' }
            end,

            make_collision_entity = function(path)
                return { dummy_id = 'CollisionEntity[' .. path .. ']' }
            end,

            delete_entity = function(e)
                log_debug('Deleting ' .. e.dummy_id)
            end,

            make_node = function(name)
                return { dummy_id = 'Node[' .. name .. ']' }
            end,

            make_child_node = function(name, parent)
                return { dummy_id = 'Node[' .. name .. ']' }
            end,

            delete_node = function(n)
                log_debug('Deleting ' .. n.dummy_id)
            end,

            make_animator = function(e)
                return { dummy_id = 'Animator[' .. e.dummy_id .. ']' }
            end,

            delete_animator = function(a)
                log_debug('Deleting ' .. a.dummy_id)
            end,

            make_collisor = function(n, w, t)
                return { dummy_id = 'Collisor[' .. n.dummy_id .. ']' }
            end,

            make_node_collisor = function(n, w, t)
                return { dummy_id = 'NodeCollisor[' .. n.dummy_id .. ']' }
            end,

            delete_collisor = function(c)
                log_debug('Deleting ' .. c.dummy_id)
            end,

            set_node_entity = function(n, e)
                log_debug('Attaching entity ' .. e.dummy_id .. ' to node ' .. n.dummy_id)
            end,

            detach_node_entity = function(n, e)
                log_debug('Detaching entity ' .. e.dummy_id .. ' from node ' .. n.dummy_id)
            end,

            attach_to_entity_bone = function(b, ea, eo, oPos, oRot, oScale)
                log_debug('Attaching entity ' .. ea.dummy_id .. ' to bone ' .. b .. ' owned by entity ' .. eo.dummy_id)
            end,

            detach_from_entity_bone = function(b, ea, eo)
                log_debug('Detaching entity ' .. ea.dummy_id .. ' from bone ' .. b .. ' owned by entity ' .. eo.dummy_id)
            end,

            attach_particle_to_entity_bone = function(b, ea, eo, oPos, oRot, oScale)
                log_debug('Attaching particle ' .. ea.dummy_id .. ' to bone ' .. b .. ' owned by entity ' .. eo.dummy_id)
            end,

            detach_particle_from_entity_bone = function(b, ea, eo)
                log_debug('Detaching particle ' .. ea.dummy_id .. ' from bone ' .. b .. ' owned by entity ' .. eo.dummy_id)
            end,

            add_node_to_scene = function(n, scene)
                log_debug('Attaching node ' .. n.dummy_id .. ' to scene')
            end,

            make_overlay = function(image, x, y, order)
                return { dummy_id = 'Overlay[' .. image .. ']' }
            end,

            delete_overlay = function(o)
                log_debug('Deleting ' .. o.dummy_id)
            end,

            make_textarea = function(id, fontName, fontSize, x, y, w, h, order, fontColor)
                return { dummy_id = 'TextArea[' .. id .. ']' }
            end,

            delete_textarea = function(t)
                log_debug('Deleting ' .. t.dummy_id)
            end,

            make_light = function(pos)
                return { dummy_id = 'Light[' .. pos.x .. ',' .. pos.y .. ',' .. pos.z .. ']' }
            end,

            delete_light = function(l)
                log_debug('Deleting ' .. l.dummy_id)
            end,

            make_particle_system = function(name, template)
                return { dummy_id = 'ParticleSystem[' .. name .. ',' .. template .. ']' }
            end,

            delete_particle_system = function(p)
                log_debug('Deleting ' .. p.name)
            end,

            make_background = function(path)
                return { dummy_id = 'Background[' .. path .. ']' }
            end,

            delete_background = function(b)
                log_debug('Deleting ' .. b.dummy_id)
            end,

            make_walkmap = function(path)
                return { dummy_id = 'Walkmap[' .. path .. ']' }
            end,

            delete_walkmap = function(w)
                log_debug('Deleting ' .. w.dummy_id)
            end,

            make_collision_env = function()
                log_debug('Creating collision env')
            end,

            delete_collision_env = function()
                log_debug('Deleting collision env')
            end,

            -- Logic.
            get_camera = function()
                return { }
            end,

            set_ambient = function(color)
                return { }
            end,

            move_collisor_dir = function(c, v3, v2)
                return { }
            end,

            look_collisor_at = function(c, v3, f)
                return { }
            end,

            rotate = function(a, rx, ry, rz)
                log_debug('Rotating actor ' .. a.dummy_id)
            end,

            play_anim = function(player, animName)
                log_debug('Playing animation ' .. anim_name .. ' for actor ' .. player)
            end,

            update_anim = function(player, tpf, blend, transitionTime)
                log_debug('Updating active animation for actor ' .. player)
            end,

            add_anim = function(a, name, from, to)
                log_debug('Adding anim ' .. name .. ' to ' .. a.dummy_id)
            end,

            set_anim = function(a, name)
                log_debug('Setting anim ' .. name .. ' for ' .. a.dummy_id)
            end,

            rewind_anim = function(a)
                log_debug('Rewinding anim for ' .. a.dummy_id)
            end,

            anim_sequence_terminated = function(a)
                return false
            end,

            slice_anim = function(e, channel, slice)
                log_debug('Slicing anim for ' .. a.dummy_id .. ' channel ' .. channel .. ' slice factor ' .. slice)
            end,

            anim_finished = function(e, channel)
                log_debug('Check anim finished for ' .. a.dummy_id .. ' channel ' .. channel)
            end,

            stop_rewind_anim = function(e)
                log_debug('Stop anim ' .. a.dummy_id)
            end,

            update_collision_env = function(e, tpf)
                log_debug('Updating collision environment')
            end,

            update_collision_env_no_collisions = function(e, tpf)
                log_debug('Updating collision environment (no collisions)')
            end,

            add_collisor_to_env = function(e, n, c)
                log_debug('Adding collision ' .. c.dummy_id .. ' to environment')
            end,

            set_walkmap_to_env = function(e, w)
                log_debug('Setting walkmap ' .. w.dummy_id .. ' to environment')
            end,

            get_collision_state_by_name = function(e, n)
                return { }
            end,

            get_collision_state_by_collisor = function(e, n)
                return { }
            end,

            get_collisor_config = function(a, g, m, r, re)
                return { }
            end,

            stream_text = function(t)
                return { }
            end,

            overlay_alpha = function(o, a)
                log_debug('Setting alpha ' .. a .. ' for overlay ' .. o.dummy_id)
            end,

            -- Math functions.
            vec3 = function(x, y, z)
                return { }
            end,

            vec4 = function(w, x, y, z)
                return { }
            end,

            vec2 = function(x, y)
                return { }
            end,

            quat = function(w, x, y, z)
                return { }
            end,

            from_euler = function(a, b, g)
                return { }
            end,

            to_euler = function(q)
                return { }
            end,

            vec3_add = function(v1, v2)
                return { }
            end,

            quat_mul = function(q1, q2)
                return { }
            end,

            get_direction = function(q, v)
                return { }
            end,

            vec2_dist = function(v1, v2)
                return { }
            end,

            -- Calcs.
            to_radians = function(a)
                return { }
            end,

            to_degrees = function(a)
                return { }
            end,

            point_inside_circle = function(x, y, cx, cy, radius)
                return true
            end,

            point_inside_polygon = function(x, y, cx, cy, data)
                return true
            end,

            circle_inside_polygon = function(x, y, cx, cy, data, radius)
                return true
            end,

            -- Input.
            current_key_code = function(keys)
                return { }
            end,

            mbutton_action_performed = function(mouse_buttons, code, type)
                return { }
            end,

            key_action_performed = function(keys, code, type)
                return { }
            end,

            -- System.
            load_file = function(file)
                return { }
            end,

            write_file = function(file, data)
                log_debug('Writing data to ' .. file)
            end,

            cleanup_pending = function()
                log_debung('Cleanup pending issues')
            end

        }
    else
        return {
            make_entity = hpms.make_entity,
            make_depth_entity = hpms.make_depth_entity,
            make_collision_entity = hpms.make_collision_entity,
            delete_entity = hpms.delete_entity,
            make_node = hpms.make_node,
            make_child_node = hpms.make_child_node,
            delete_node = hpms.delete_node,
            make_animator = hpms.make_animator,
            delete_animator = hpms.delete_animator,
            make_collisor = hpms.make_collisor,
            make_node_collisor = hpms.make_node_collisor,
            delete_collisor = hpms.delete_collisor,
            set_node_entity = hpms.set_node_entity,
            detach_node_entity = hpms.detach_node_entity,
            attach_to_entity_bone = hpms.attach_to_entity_bone,
            detach_from_entity_bone = hpms.detach_from_entity_bone,
            attach_particle_to_entity_bone = hpms.attach_particle_to_entity_bone,
            detach_particle_from_entity_bone = hpms.detach_particle_from_entity_bone,
            add_node_to_scene = hpms.add_node_to_scene,
            make_overlay = hpms.make_overlay,
            delete_overlay = hpms.delete_overlay,
            make_textarea = hpms.make_textarea,
            delete_textarea = hpms.delete_textarea,
            make_light = hpms.make_light,
            delete_light = hpms.delete_light,
            make_particle_system = hpms.make_particle_system,
            delete_particle_system = hpms.delete_particle_system,
            make_background = hpms.make_background,
            delete_background = hpms.delete_background,
            make_walkmap = hpms.make_walkmap,
            delete_walkmap = hpms.delete_walkmap,
            make_collision_env = hpms.make_collision_env,
            delete_collision_env = hpms.delete_collision_env,
            get_collisor_config = hpms.get_collisor_config,
            stream_text = hpms.stream_text,
            overlay_alpha = hpms.overlay_alpha,

            -- Logic.
            get_camera = hpms.get_camera,
            set_ambient = hpms.set_ambient,
            move_collisor_dir = hpms.move_collisor_dir,
            look_collisor_at = hpms.look_collisor_at,
            rotate = hpms.rotate,
            slice_anim = hpms.slice_anim,
            play_anim = hpms.play_anim,
            update_anim = hpms.update_anim,
            add_anim = hpms.add_anim,
            set_anim = hpms.set_anim,
            rewind_anim = hpms.rewind_anim,
            anim_sequence_terminated = hpms.anim_sequence_terminated,
            anim_finished = hpms.anim_finished,
            stop_rewind_anim = hpms.stop_rewind_anim,
            update_collision_env = hpms.update_collision_env,
            update_collision_env_no_collisions = hpms.update_collision_env_no_collisions,
            add_collisor_to_env = hpms.add_collisor_to_env,
            set_walkmap_to_env = hpms.set_walkmap_to_env,
            get_collision_state_by_name = hpms.get_collision_state_by_name,
            get_collision_state_by_collisor = hpms.get_collision_state_by_collisor,

            -- Math functions.
            vec4 = hpms.vec4,
            vec3 = hpms.vec3,
            vec2 = hpms.vec2,
            quat = hpms.quat,
            from_euler = hpms.from_euler,
            to_euler = hpms.to_euler,
            vec3_add = hpms.vec3_add,
            quat_mul = hpms.quat_mul,
            get_direction = hpms.get_direction,
            vec2_dist = hpms.vec2_dist,

            -- Calc functions.
            to_radians = hpms.to_radians,
            to_degrees = hpms.to_degrees,
            point_inside_circle = hpms.point_inside_circle,
            point_inside_polygon = hpms.point_inside_polygon,
            circle_inside_polygon = hpms.circle_inside_polygon,

            -- Input.
            current_key_code = hpms.current_key_code,
            mbutton_action_performed = hpms.mbutton_action_performed,
            key_action_performed = hpms.key_action_performed,

            -- System.
            load_file = hpms.load_file,
            write_file = hpms.write_file,
            cleanup_pending = hpms.cleanup_pending
        }
    end
end