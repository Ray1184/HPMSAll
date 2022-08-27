--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Object that can be attached to a bone.
--


dependencies = {
    'libs/logic/templates/EntityItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/gameplay/InventoryHelper.lua',
    'libs/logic/gameplay/EquipmentHelper.lua',
    'libs/logic/managers/EventQueueManager.lua'
}

attachable = { }

function attachable:ret(path, id, parentEntity, boneName, posOffset, rotOffset, scale)
    k = game_mechanics_consts:get()
    insp = inspector:get()
    eqm = event_queue_manager:new()

    local ret = entity_item:ret(path, id)
    local id = 'attachable/' .. id
    local this = context_get_object(id, true,
    function()
        log_debug('New attachable object ' .. id)

        local new = {
            serializable =
            {
                id = id,
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
            object_type = 'attachable',
            parent_type = 'game_object',
            override =
            {
                entity_item =
                {
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

    function attachable:delete_transient_data()
        if not self.transientDataInit then
            return
        end
        lib.detach_from_entity_bone(boneName, self.transient.entity, parentEntity)
        self.metainfo.override.entity_item.delete_transient_data(self)
    end

    function attachable:fill_transient_data()
        self.metainfo.override.entity_item.fill_transient_data(self)
        if self.serializable.expired then
            return
        end
        lib.attach_to_entity_bone(boneName, self.transient.entity, parentEntity, lib.vec3(posOffset.x, posOffset.y, posOffset.z), lib.from_euler(lib.to_radians(rotOffset.x), lib.to_radians(rotOffset.y), lib.to_radians(rotOffset.z)), lib.vec3(scale.x, scale.y, scale.z))
    end

    function attachable:update()
        if self.serializable.expired then
            return
        end
        self.serializable.visual_info.visible = not self.serializable.picked
        self.metainfo.override.entity_item.update(self)
    end


    function attachable:kill_instance()
        self.metainfo.override.entity_item.kill_instance(self)
    end

    context_put_full_ref_obj(this)

    return this
end
