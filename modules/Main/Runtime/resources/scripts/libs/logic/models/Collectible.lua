--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Generic collectible and usable object.
--


dependencies = {
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

collectible = { }

function collectible:ret(path, id, amount)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local ret = game_item:ret(path, id)
    local id = 'collectible/' .. id
    local this = context:inst():get_object(id, true,
    function()
        log_debug('New collectible object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                selected = false,
                amount = amount or 1,
                picked = false
            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable = { }
    }

    notSer.not_serializable = merge_tables(notSer.not_serializable, ret.not_serializable)
    this = merge_tables(this, notSer)

    local metainf =
    {
        metainfo =
        {
            object_type = 'collectible',
            parent_type = 'game_object',
            override =
            {
                game_item =
                {
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update,
                    kill_instance = ret.kill_instance
                }
            }
        }
    }

    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret.metainfo.override)

    this = merge_tables(this, metainf)    

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function collectible:set_properties(properties)
        self.not_serializable.properties = properties
    end

    function collectible:get_properties()
        return self.not_serializable.properties
    end

    function collectible:set_position(x, y, z)
        self.metainfo.override.game_item.set_position(self, x, y, z)
    end

    function collectible:get_position()
        return self.metainfo.override.game_item.get_position(self)
    end

    function collectible:move_dir(ratio, dir)
        self.metainfo.override.game_item.move_dir(self, ratio, dir)
    end

    function collectible:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function collectible:scale(sx, sy, sz)
        self.metainfo.override.game_item.scale(self, sx, sy, sz)
    end

    function collectible:delete_transient_data()
        self.metainfo.override.game_item.delete_transient_data(self)
    end

    function collectible:fill_transient_data()
        self.metainfo.override.game_item.fill_transient_data(self)
        if self.serializable.expired then
            return
        end
    end

    function collectible:update()
        if self.serializable.expired then
            return
        end
        self.serializable.visual_info.visible = not self.serializable.picked
        self.metainfo.override.game_item.update(self)
    end

    function collectible:set_event_callback(evtCallback)
        self.metainfo.evt_callback = evtCallback
    end

    function collectible:event(tpf, evtInfo)
        if self.metainfo.evt_callback ~= nil then
            self.metainfo.evt_callback(tpf, evtInfo)
        end
    end

    function collectible:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end
       
    context:put_full_ref_obj(this)

    return this
end
