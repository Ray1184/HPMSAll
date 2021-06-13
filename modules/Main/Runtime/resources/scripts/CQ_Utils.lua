--
-- UTILITY FUNCTIONS!!!!!
--

-- STATE VARS
if st_player_pos == nil then
    st_player_pos = hpms.vec3(1, -0.7, 0.0)
end
if st_quit_qt1 == nil then
    st_quit_qt1 = false
end
if st_look_qt1 == nil then
    st_look_qt1 = false
end
if st_quit_qt2 == nil then
st_quit_qt2 = false
end
if st_look_qt2 == nil then
st_look_qt2 = false
end
if st_player_rot == nil then
    st_player_rot = hpms.from_euler(0, 0, 180)
end
if st_esci_casa == nil then
    st_esci_casa = 0
end
if st_vicino_eliminato == nil then
    st_vicino_eliminato = 0
end
if st_go_to_basement == nil then
    st_go_to_basement = false
end

if st_quest_1_done == nil then
    st_quest_1_done = false
end

if st_quest_2_done == nil then
    st_quest_2_done = false
end

if st_key1 == nil then
    st_key1 = false
end

if st_key2 == nil then
    st_key2 = false
end

if st_acid == nil then
    st_acid = false
end

if st_sdriver == nil then
    st_sdriver = false
end

if st_neib_killed == nil then
    st_neib_killed = false
end

--st_esci_casa = 0
--st_vicino_eliminato = 0
--st_go_to_basement = false

function init_all()

    fading = false
    mx = 0
    my = 0
    speed = 0
    rotate = 0
    action = false
    block_time = false
    textbuffer = ''
    alpha = 1
    blackscreen = hpms.make_overlay("Black.png", 0, 0, 5)
    fadein_done = false
    fadeout_done = false
    textarea = hpms.make_textarea("Footer", "Alagard", 16, 10, 150, 300, 40, 10, hpms.vec4(1, 1, 0.8, 1.0))

    hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
    cam = hpms.get_camera()
    cam.near = 0.05
    cam.far = 50
    cam.fovy = hpms.to_radians(45)


end

function fade_in(tpf, callback)
    if fadein_done then
        return
    end
    if alpha >= 0 then
        fading = true
        alpha = alpha - tpf
        hpms.overlay_alpha(blackscreen, alpha)
    else
        alpha = 0
        fadein_done = true
        fadeout_done = false
        fading = false
        callback()
    end

end

function fade_out(tpf, callback)
    if fadeout_done then
        return
    end
    if alpha <= 1 then
        fading = true
        alpha = alpha + tpf
        hpms.overlay_alpha(blackscreen, alpha)
    else
        alpha = 1
        fadeout_done = true
        fadein_done = false
        fading = false
        callback()
    end
end

function trigger_dist(position, distance, node, callback)
    local calc_dist = hpms.vec3_dist(position, node.position)
    if calc_dist <= distance and action then
        callback()
        action = false
    end
end

function msg_box(message)
    msg_box(message, nil)
end

function msg_box(message, do_after_message)
    flush_message_box(message)
    postmsg_callback = do_after_message


end

function flush_message_box(message)
    textbuffer = hpms.stream_text(textarea, message, 3)
    action = false
    if textbuffer == '' and message == '' then
        block_time = false
    else
        block_time = true
    end
    if not block_time and postmsg_callback ~= nil and not fading then

        postmsg_callback()
    end
end



--
-- MOVE FUNCTIONS
--
function f_move_collisor_towards_direction(coll, ratio)
    local dir = hpms.get_direction(coll.rotation, hpms.vec3(0, -1, 0))
    local nextPos = hpms.vec3_add(coll.position, hpms.vec3(ratio * dir.x, ratio * dir.y, 0))
    hpms.move_collisor_dir(coll, nextPos, hpms.vec2(dir.x, dir.y))
end

function f_rotate(actor, rx, ry, rz)
    actor.rotation = hpms.quat_mul(actor.rotation, hpms.from_euler(hpms.to_radians(rx), hpms.to_radians(ry), hpms.to_radians(rz)))
end

function limitx(val)
    return limit(val, 320, 0)
end

function limity(val)
    return limit(val, 200, 0)
end

function limit(val, max, min)
    if val > max then
        return max
    end
    if val < min then
        return min
    end
    return val
end

function mouse_in_area(x, y, tolerance)
    inx = mx >= x and mx < (x + tolerance)
    iny = my > y and my < (y + tolerance)
    return (inx and iny)
end

