--
-- Created by Ray1184.
-- DateTime: 25/10/2022 17:04
--
-- Helper for puzzle based quests.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/utils/MathUtils.lua'
}


dragging = false
last = nil

function inside_coords(cx, cy, x, y, thresholdm)
    threshold = threshold or 2
    return abs(cx - x) <= threshold and abs(cy - y) <= threshold

end

function drag_and_drop(workArea, x, y, inputPrf, size)
    local images = workArea.transient.images
    for k, image in pairs(images) do
        if not inputPrf.mouse_pressed then
            image.attached = false
            dragging = false

        elseif inputPrf.mouse_pressed and image:point_inside(x, y) and not image.attached and not image.locked and not dragging then
            dragging = true
            image.last_coords = { x = x, y = y }

            if last == nil or last.id ~= image.id then
                for k2, image2 in pairs(images) do
                    if image2.order > image.order then
                        image2:set_order(image2.order - 1)
                    end
                end
                image:set_order(size)
            end
            last = image
            image.attached = true


        end

        if image.attached then
            local diffX = x - image.last_coords.x
            local diffY = y - image.last_coords.y
            local oldPos = image:get_position()
            image:set_position(oldPos.x + diffX, oldPos.y + diffY)
            image.last_coords = { x = x, y = y }
        end
    end
    return dragging
end

