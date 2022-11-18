--
-- Created by Ray1184.
-- DateTime: 04/11/2021 17:04
--
-- Presets workflow sequences.
--

dependencies = {
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/helpers/Workflow.lua',
    'libs/gui/OutputText2D.lua',
    'libs/backend/HPMSFacade.lua'
}

workflow_sequences = { }

function workflow_sequences:new()
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local fullBox = { lib.vec2(0, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
    local msgBox = { lib.vec2(10, 10), lib.vec2(300, 10), lib.vec2(300, 80), lib.vec2(10, 80) }
    local bookBox = { lib.vec2(40, 10), lib.vec2(220, 10), lib.vec2(220, 160), lib.vec2(40, 160) }



    local this = {
        module_name = 'workflow_sequences',
        text_style = { },
        shade_overlays = { },
        tmp_vars = { }
    }

    this.tmp_vars['CURRENT_ALPHA'] = 0
    this.tmp_vars['MSG_ALPHA'] = 1

    this.text_style[k.diplay_msg_styles.MSG_BOX] = {
        renderer = output_text_2d:new(msgBox,0,0,'default/Console_Empty.png',200,'MessageBoxArea','Alagard',16,lib.vec4(1.0,0.8,0.0,1.0),4),
        renderer_shadow = output_text_2d:new(msgBox,0,0,'default/Console_Empty.png',199,'MessageBoxAreaShadow','Alagard',16,lib.vec4(0.0,0.0,0.0,0.5),4)
    }
    this.text_style[k.diplay_msg_styles.BOOK] = {
        renderer = output_text_2d:new(bookBox,0,0,'default/Console_Empty.png',198,'BookArea','Alagard',16,lib.vec4(0.0,0.0,0.0,1.0),12),
        renderer_shadow = output_text_2d:new(bookBox,0,0,'default/Console_Empty.png',197,'BookAreaShadow','Alagard',16,lib.vec4(1.0,1.0,1.0,0.5),12)
    }
    this.shade_overlays[k.overlay_colors.BLACK] = image_2d:new(POLYGONS, fullBox, 0, 0, 'default/Black.png', 195)
    this.shade_overlays[k.overlay_colors.BLACK]:alpha(this.tmp_vars['CURRENT_ALPHA'])

    this.text_style[k.diplay_msg_styles.MSG_BOX].renderer:set_visible(false)
    this.text_style[k.diplay_msg_styles.MSG_BOX].renderer:set_position(10, 130)
    this.text_style[k.diplay_msg_styles.MSG_BOX].renderer_shadow:set_visible(false)
    this.text_style[k.diplay_msg_styles.MSG_BOX].renderer_shadow:set_position(9, 129)
    this.text_style[k.diplay_msg_styles.BOOK].renderer:set_visible(false)
    this.text_style[k.diplay_msg_styles.BOOK].renderer:set_position(40, 10)
    this.text_style[k.diplay_msg_styles.BOOK].renderer_shadow:set_visible(false)
    this.text_style[k.diplay_msg_styles.BOOK].renderer_shadow:set_position(39, 9)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end


    function workflow_sequences:wait(time)
        return {
            action = function(tpf, timer)
                -- Just wait...
            end,
            complete_on = function(tpf, timer)
                return timer >= time
            end
        }
    end

    function workflow_sequences:fade_in(duration, style)
        return {
            action = function(tpf, timer)
                if duration <= 0 then
                    self.shade_overlays[style or k.overlay_colors.BLACK]:alpha(0)
                    self.tmp_vars['CURRENT_ALPHA'] = 0
                else
                    local currAlpha = self.tmp_vars['CURRENT_ALPHA']
                    local nextAlpha = currAlpha -(tpf / duration)
                    self.shade_overlays[style or k.overlay_colors.BLACK]:alpha(nextAlpha)
                    self.tmp_vars['CURRENT_ALPHA'] = nextAlpha
                end
            end,
            complete_on = function(tpf, timer)
                return self.tmp_vars['CURRENT_ALPHA'] <= 0
            end
        }
    end

    function workflow_sequences:fade_out(duration, style)
        return {
            action = function(tpf, timer)

                if duration <= 0 then
                    self.shade_overlays[style or k.overlay_colors.BLACK]:alpha(1)
                    self.tmp_vars['CURRENT_ALPHA'] = 1
                else
                    local currAlpha = self.tmp_vars['CURRENT_ALPHA']
                    local nextAlpha = currAlpha +(tpf / duration)
                    self.shade_overlays[style or k.overlay_colors.BLACK]:alpha(nextAlpha)
                    self.tmp_vars['CURRENT_ALPHA'] = nextAlpha
                end
            end,
            complete_on = function(tpf, timer)
                return self.tmp_vars['CURRENT_ALPHA'] >= 1
            end
        }
    end

    function workflow_sequences:pipe(what, loop, args)
        return {
            action = function(tpf, timer)
                what(tpf, args)
            end,
            complete_on = function(tpf, timer)
                return not(loop or false)
            end
        }
    end

    function workflow_sequences:message_box(text, proceedCallback, style, drawShadow, fadeOut)
        local fadeOut = fadeOut or true
        local textRend = self.text_style[style or k.diplay_msg_styles.MSG_BOX]
        return {
            action = function(tpf, timer)
                local currentText = self.tmp_vars['MSG_CURRENT_TEXT']
                if currentText == nil then
                    textRend.renderer:set_visible(true)
                    self.tmp_vars['MSG_CURRENT_TEXT'] = textRend.renderer:stream(safe_string(text))
                    if drawShadow then
                        textRend.renderer_shadow:set_visible(true)
                        textRend.renderer_shadow:stream(safe_string(text))
                    end
                elseif proceedCallback(tpf, timer) then
                    if currentText == nil or currentText == '' then
                        self.tmp_vars['MSG_FINISHED'] = true
                    else
                        self.tmp_vars['MSG_CURRENT_TEXT'] = textRend.renderer:stream(currentText)
                        if drawShadow then
                            textRend.renderer_shadow:stream(currentText)
                        end
                    end
                end
            end,
            complete_on = function(tpf, timer)
                local currentText = self.tmp_vars['MSG_CURRENT_TEXT']
                local finished = self.tmp_vars['MSG_FINISHED']
                if finished then
                    if not fadeOut then
                        self.tmp_vars['MSG_CURRENT_TEXT'] = nil
                        self.tmp_vars['MSG_FINISHED'] = nil
                        textRend.renderer:set_visible(false)
                        if drawShadow then
                            textRend.renderer_shadow:set_visible(false)
                        end
                    else
                        self.tmp_vars['MSG_ALPHA'] = self.tmp_vars['MSG_ALPHA'] - tpf
                        local txtAlpha = self.tmp_vars['MSG_ALPHA']
                        if txtAlpha >= 0 then
                            textRend.renderer:alpha(txtAlpha)
                            if drawShadow then
                                textRend.renderer_shadow:alpha(txtAlpha / 2)
                            end
                            return false
                        else
                            self.tmp_vars['MSG_CURRENT_TEXT'] = nil
                            self.tmp_vars['MSG_FINISHED'] = nil
                            textRend.renderer:set_visible(false)
                            if drawShadow then
                                textRend.renderer_shadow:set_visible(false)
                            end
                        end

                    end
                    return true
                else
                    return false
                end
            end
        }
    end

    function workflow_sequences:motion_path_with_look_at(actor, positionCallback, animated, moveSpeed, rotateSpeed, nearTreshold, angleTreshold, animation, animSpeed)
        return {
            action = function(tpf, timer)
                local target = positionCallback(tpf, timer)
                local angle = math.abs(lib.look_collisor_at(actor.transient.collisor, lib.vec3(target.x, target.y, target.z), tpf *(rotateSpeed or 1) / 4))
                if animated then
                    actor:set_anim(animation or 'Walk_Forward')
                    actor:play(k.anim_modes.ANIM_MODE_LOOP, animSpeed or 1)
                end
                if angle <(angleTreshold or lib.to_radians(180)) then
                    actor:move_dir(tpf *(- moveSpeed or -1))
                end
            end,
            complete_on = function(tpf, timer)
                local target = positionCallback()
                local actorPos = lib.vec2(actor:get_position().x, actor:get_position().y)
                local finalPos = lib.vec2(target.x, target.y)
                local reached = lib.vec2_dist(actorPos, finalPos) <(nearTreshold or 0.01)
                if reached then
                    if animated then
                        actor:set_anim('Idle')
                        actor:play(k.anim_modes.ANIM_MODE_LOOP, animSpeed or 1)
                    end
                    return true
                else
                    return false
                end
            end
        }
    end

    function workflow_sequences:delete_all()
        for k, v in pairs(self.text_style) do
            for k1, v1 in pairs(v) do
                v1:delete()
            end
        end
        for k, v in pairs(self.shade_overlays) do
            v:delete()
        end
    end

    return this
end