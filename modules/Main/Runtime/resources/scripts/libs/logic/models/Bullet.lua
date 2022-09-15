--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Object that can be attached to a bone.
--


dependencies = {
    'libs/logic/templates/VolatileGameItem.lua',
    'libs/backend/HPMSFacade.lua',
}

bullet = { }

function bullet:ret(shooterActor, path)
    k = game_mechanics_consts:get()
    lib = backend:get()
    insp = inspector:get()

    local this = { }
    local ret = volatile_game_item:ret(path)

    this = merge_tables(this, ret)

    local weapon = context_get_full_ref(shooterActor.serializable.equip)
    local props = weapon:get_properties().weapon_properties
    local serProps = weapon:get_serializable_properties().weapon_properties
    local offset = props.equip_position_offset
    local parentEntity = shooterActor:get_attached_weapon().transient.entity
    local pos = parentEntity.world_position

    local notSer = {
        not_serializable =
        {
            properties =
            {
                vtype = k.volatile_types.BULLET,
                current_position = { x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z + offset.z },
                previus_position = { x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z + offset.z },
                direction = lib.get_direction(shooterActor.transient.node.rotation,lib.vec3(0,- 1,0)),
                ttl = k.BULLET_TTL,
                life = 0
            }
        }
    }

    this = merge_tables(this, notSer)
    this.not_serializable.properties = merge_tables(this.not_serializable.properties, serProps.ammo_loaded)

    local metainf =
    {
        metainfo =
        {
            object_type = 'bullet',
            parent_type = 'volatile_game_object',
            override =
            {
                volatile_game_object =
                {
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update
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

    function bullet:delete_transient_data()
        if not self.transientDataInit then
            return
        end
        local attachTo = k.attachable_bones.WEAPON_BARREL_FX
        lib.detach_particle_from_entity_bone(attachTo, self.transient.fx, parentEntity)
        lib.delete_particle_system(self.transient.fx)        
        self.metainfo.override.volatile_game_object.delete_transient_data(self)
        context_remove_volatile(self)
    end

    function bullet:fill_transient_data()
        context_put_volatile(self)
        self.metainfo.override.volatile_game_object.fill_transient_data(self)
        local properties = self.not_serializable.properties
        -- TODO set collisor position
        if self.not_serializable.properties.fire_fx_name ~= nil then
            local fxTemplate = self.not_serializable.properties.fire_fx_name
            local id = self.not_serializable.id
            local attachTo = k.attachable_bones.WEAPON_BARREL_FX
            local dummyRot = lib.from_euler(0, 0, 0)
            local dummyScale = lib.vec3(1, 1, 1)
            self.transient.fx = lib.make_particle_system('fx/' .. fxTemplate .. '/' .. id, fxTemplate, false)
            lib.attach_particle_to_entity_bone(attachTo, self.transient.fx, parentEntity, lib.vec3(props.fx_position_offset.x, props.fx_position_offset.y, props.fx_position_offset.z), dummyRot, dummyScale)
        end
    end

    function bullet:update(tpf, allSceneActors, walkmap)
        self.metainfo.override.volatile_game_object.update(self)      
        local props = self.not_serializable.properties
        props.previus_position = props.current_position
        -- TODO move collisor and update props.current_position
        -- TODO collisions.
        local kill = props.life > props.ttl
        -- or out_of_walkmap(round, walkmap) or collides_actor(round, actorsMgr.loaded_actors)
        if kill then
            self:delete_transient_data()
        end
        props.life = props.life + tpf
    end

    return this
end
