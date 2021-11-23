---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Animated stateful game object.
---


dependencies = { 
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}
lib = backend:get()

anim_game_item = {}

function anim_game_item:ret(path)
    local id = 'anim_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                log_debug('New anim_game_item object ' .. id)
                local ret = game_item:ret(path)
                local new = {
                    serializable = {
                        anim_data = {
                            channel = 0,
                            current_frame = 0,
                            loop = false,
                            slowdown = 1,
                            anim_sets = {}
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

    function anim_game_item:move_dir(ratio)
        self.serializable.override_game_item:move_dir(ratio)
    end

    function anim_game_item:rotate(rx, ry, rz)
        self.serializable.override_game_item:rotate(rx, ry, rz)
    end

    function anim_game_item:delete_transient_data()
        self.serializable.override_game_item.delete_transient_data(self)
        if not self.serializable.expired then
            lib.delete_animator(self.transient.animator)
        end
    end

    function anim_game_item:fill_transient_data()
        self.serializable.override_game_item.fill_transient_data(self)
        if not self.serializable.expired then
            local tra = {
                transient = {
                    animator = lib.make_animator(self.transient.entity)
                }
            }
            self = utils.merge(self, tra)
        end
    end

    function anim_game_item:update()
        self.serializable.override_game_item.update(self)
        if not self.serializable.expired and self.serializable.visual_info.visible then
            lib.update_controller(self.transient.animator, 'ANIMATOR')
        end
    end


    return this
end
