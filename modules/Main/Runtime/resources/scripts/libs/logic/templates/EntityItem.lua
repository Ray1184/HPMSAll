--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Simple game entity, without transformations.
--

dependencies = {
    'libs/utils/TransformsCommon.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua'
}

entity_item = { }

function entity_item:ret(path, id)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()

    local transientDataInit = false
    local id = 'entity_item/' .. id
    local ret = abstract_object:ret(id)

    local this = context_get_object(id, false,
    function()
        log_debug('New entity_item object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                path = path or '',
                expired = false,
                visual_info =
                {
                    visible = true

                }
            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable = { }
    }

    this = merge_tables(this, notSer)

    local metainf =
    {
        metainfo =
        {
            object_type = 'game_object',
            parent_type = 'abstract_object',
            override = { }
        }
    }

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    

    function entity_item:delete_transient_data()
        if not self.transientDataInit then
            return
        end
        self.transientDataInit = false
        lib.delete_entity(self.transient.entity)

    end

    function entity_item:fill_transient_data()
        if self.serializable.expired or self.transientDataInit then
            return
        end        
        local tra = {
            transient =
            {
                entity = lib.make_entity(self.serializable.path)
            }
        }
        self = merge_tables(self, tra)       
        local visualInfo = self.serializable.visual_info       
        self.transientDataInit = true

    end

    function entity_item:update()
        if self.serializable.expired then
            return
        end
        self.transient.entity.visible = self.serializable.visual_info.visible        
    end

    function entity_item:kill_instance()
        -- WARNING, here change state forever after call.
        self:update()
        self.serializable.expired = true
    end

    function entity_item:set_event_callback(evt_callback)
        self.metainfo.evt_callback = evt_callback
    end

    function entity_item:event(evt_info)
        if self.metainfo.instance ~= nil then
            self.metainfo.instance:event(evt_info)
        end
    end

    return this
end
