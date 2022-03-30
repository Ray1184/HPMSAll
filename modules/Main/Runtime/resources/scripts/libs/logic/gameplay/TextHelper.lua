--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Text labels useful static functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/gui/OutputText2D.lua'
}

function create_text_label(id, text, lib, x, y, lines, order, font, size, color, shadowColor)
    text = safe_string(text)
    font = font or 'Alagard'
    size = size or 16
    color = color or lib.vec4(0.9, 0.9, 1.0, 1)
    lines = lines or 1
    order = order or 105
    shadowColor1 = shadowColor or lib.vec4(0, 0, 0, 0.0)
    shadowColor2 = shadowColor or lib.vec4(0, 0, 0, 0.0)
    shadowColor3 = shadowColor or lib.vec4(0, 0, 0, 0.0)
    shadowColor1.w = 0.75
    shadowColor2.w = 0.75
    shadowColor3.w = 0.33   
    local nameBox = { lib.vec2(0, 0), lib.vec2(300, 0), lib.vec2(300, 200), lib.vec2(0, 200) }
    renderer = output_text_2d:new(nameBox, 0, 0, 'default/Console_Empty.png', order, 'TextBoxArea_' .. id, font, size, color, lines)
    rendererShadow = output_text_2d:new(nameBox, 0, 0, 'default/Console_Empty.png', order - 1, 'TextBoxAreaShadow_' .. id, font, size, shadowColor1, lines)
    rendererShadow2 = output_text_2d:new(nameBox, 0, 0, 'default/Console_Empty.png', order - 2, 'TextBoxAreaShadow2_' .. id, font, size, shadowColor2, lines)
    rendererShadow3 = output_text_2d:new(nameBox, 0, 0, 'default/Console_Empty.png', order - 3, 'TextBoxAreaShadow3_' .. id, font, size, shadowColor3, lines)
    renderer:set_position(x, y)
    rendererShadow:set_position(x + 1, y)
    rendererShadow2:set_position(x, y + 1)
    rendererShadow3:set_position(x + 1, y + 1)
    local safeText = tostring(text)
    renderer:stream(safeText)
    rendererShadow:stream(safeText)
    rendererShadow2:stream(safeText)
    rendererShadow3:stream(safeText)
    return {
        renderer = renderer,
        renderer_shadow = rendererShadow,
        renderer_shadow_2 = rendererShadow2,
        renderer_shadow_3 = rendererShadow3
    }
end

function delete_text_label(textLabel, lib)
    textLabel.renderer:delete()
    textLabel.renderer_shadow:delete()
    textLabel.renderer_shadow_2:delete()
    textLabel.renderer_shadow_3:delete()
end


