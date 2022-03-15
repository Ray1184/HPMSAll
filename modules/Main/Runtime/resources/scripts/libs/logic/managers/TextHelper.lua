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

function create_text_label(id, text, lib, x, y, font, size, color, shadowColor, lines)
    font = font or 'Alagard'
    size = size or 16
    color = color or lib.vec4(1.0, 0.7, 0.0, 1)
    lines = lines or 1
    shadowColor = shadowColor or lib.vec4(color.x / 99, color.y / 99, color.z / 99, 0.5)
    local nameBox = { lib.vec2(x, y), lib.vec2(x + 200, y), lib.vec2(x + 200, y + 50), lib.vec2(x, y + 50) }
    renderer = output_text_2d:new(nameBox, 0, 0, 'Console_Empty.png', 100, 'TextBoxArea_' .. id, font, size, color, lines)
    rendererShadow = output_text_2d:new(nameBox, 0, 0, 'Console_Empty.png', 99, 'TextBoxAreaShadow_' .. id, font, size, shadowColor, lines)
    rendererShadow2 = output_text_2d:new(nameBox, 0, 0, 'Console_Empty.png', 99, 'TextBoxAreaShadow2_' .. id, font, size, shadowColor, lines)
    rendererShadow3 = output_text_2d:new(nameBox, 0, 0, 'Console_Empty.png', 99, 'TextBoxAreaShadow3_' .. id, font, size, shadowColor, lines)
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


