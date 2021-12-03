---
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
---
--- Generic collectible and usable object.
---


dependencies = { 
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}
lib = backend:get()

collectible_item = {}

function collectible_item:ret(path)
    local id = 'collectible_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                log_debug('New collectible_item object ' .. id)
                local ret = game_item:ret(path)
                local new = {
                    serializable = {
                        gui = {
                            visual_info = {
                                position = lib.vec3(0, 0, 0),
                                rotation = lib.from_euler(0, 0, 0),
                                selected = false
                            }
                        },
                        override_game_item = {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update
                        }
                    }
                }

                ret = utils.merge(ret, new)

                return ret
            end)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function collectible_item:move_dir(ratio)
        self.metainfo.override_game_item.move_dir(ratio)
    end

    function collectible_item:rotate(rx, ry, rz)
        self.metainfo.override_game_item.rotate(rx, ry, rz)
    end

    function collectible_item:delete_transient_data()
        self.metainfo.override_game_item.delete_transient_data(self)
    end

    function collectible_item:fill_transient_data()
        self.metainfo.override_game_item.fill_transient_data(self)
    end

    function collectible_item:update()
        self.metainfo.override_game_item.update(self)
        if context:inst():is_mode_r25d() or context:inst():is_mode_3d() then
            self.transient.node.position = self.serializable.visual_info.position
        else
            self.transient.entity.visible = self.serializable.gui.visual_info.selected
            self.transient.node.position = self.serializable.gui.visual_info.position
            self:rotate(0, 1, 0)
        end
    end


    return this
end
