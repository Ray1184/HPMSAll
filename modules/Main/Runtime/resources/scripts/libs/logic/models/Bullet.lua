--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Object that can be attached to a bone.
--


dependencies = {
    'libs/logic/templates/VolatileGameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/MathUtils.lua'
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
                life = 0,
                collided = false,
                collision_countdown = k.AFTER_COLLISION_TTL
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
        if self.not_serializable.properties.fire_fx_name ~= nil then
            local attachTo = k.attachable_bones.WEAPON_BARREL_FX
            --lib.detach_particle_from_entity_bone(attachTo, self.transient.fire_fx, parentEntity)
            lib.delete_particle_system(self.transient.fire_fx)
        end

        if self.not_serializable.properties.bullet_fx_name ~= nil then
            lib.delete_particle_system(self.transient.bullet_fx)
        end

        -- Collision fx could be not initialized yet
        if self.not_serializable.properties.collision_fx_name ~= nil and self.transient.collision_fx ~= nil then
            lib.delete_particle_system(self.transient.collision_fx)
            self.transient.collision_fx = nil
        end

        self.metainfo.override.volatile_game_object.delete_transient_data(self)
        context_remove_volatile(self)
    end

    function bullet:fill_transient_data(walkmap)
        context_put_volatile(self)
        self.metainfo.override.volatile_game_object.fill_transient_data(self)
        local properties = self.not_serializable.properties
        self.metainfo.override.volatile_game_object.set_position(self, properties.current_position.x, properties.current_position.y, properties.current_position.z)
        if self.not_serializable.properties.fire_fx_name ~= nil then
            local fxTemplate = self.not_serializable.properties.fire_fx_name
            local id = 'fire_' .. self.not_serializable.id
            local attachTo = k.attachable_bones.WEAPON_BARREL_FX
            local dummyRot = lib.from_euler(0, 0, 0)
            local dummyScale = lib.vec3(1, 1, 1)
            self.transient.fire_fx = lib.make_particle_system('fx/' .. fxTemplate .. '/' .. id, fxTemplate)
            lib.set_node_particle(self.transient.node, self.transient.fire_fx)
            lib.particle_go_to_time(self.transient.fire_fx, 1.0)
        end
        if self.not_serializable.properties.bullet_fx_name ~= nil then
            local fxTemplate = self.not_serializable.properties.bullet_fx_name
            local id = 'bullet_' .. self.not_serializable.id
            local dummyRot = lib.from_euler(0, 0, 0)
            local dummyScale = lib.vec3(1, 1, 1)
            self.transient.bullet_fx = lib.make_particle_system('fx/' .. fxTemplate .. '/' .. id, fxTemplate)
            lib.set_node_particle(self.transient.node, self.transient.bullet_fx)
            lib.particle_go_to_time(self.transient.bullet_fx, 1.0)
        end
    end

    function bullet:update(tpf, allSceneActors, walkmap)
        self.metainfo.override.volatile_game_object.update(self)
        local props = self.not_serializable.properties
        if props.collided then
            props.collision_countdown = props.collision_countdown - tpf
            if props.collision_countdown <= 0 then
                self:delete_transient_data()
            end
            return
        end
        props.previus_position = props.current_position
        self.metainfo.override.volatile_game_object.move_dir(self, tpf * props.speed, props.direction)
        props.current_position = self.metainfo.override.volatile_game_object.get_position(self)

        local collisionInfo = bullet_collision(shooterActor, self, allSceneActors, walkmap, tpf)

        props.collided = collisionInfo.collision
        props.collision_point = collisionInfo.collision_point

        if props.collided then
            collision_fx(self)
        end

        props.life = props.life + tpf
    end

    return this
end

function collision_fx(bullet)
    if bullet.not_serializable.properties.collision_fx_name ~= nil then
        if bullet.transient.bullet_fx ~= nil then
            bullet.transient.bullet_fx.visible = false
        end
        local fxTemplate = bullet.not_serializable.properties.collision_fx_name
        local id = 'bullet_collision_' .. bullet.not_serializable.id
        local dummyRot = lib.from_euler(0, 0, 0)
        local dummyScale = lib.vec3(1, 1, 1)
        local bulletProps = bullet.not_serializable.properties
        local pos = bulletProps.collision_point
        local dir = bulletProps.direction
        local blastRadius = bulletProps.blast_radius
        bullet.transient.collision_fx = lib.make_particle_system('fx/' .. fxTemplate .. '/' .. id, fxTemplate)
        bullet.transient.node.position = lib.vec3(pos.x, pos.y, bullet.transient.node.position.z)      
        bullet.metainfo.override.volatile_game_object.move_dir(bullet, -blastRadius, dir)
        lib.set_node_particle(bullet.transient.node, bullet.transient.collision_fx)
        lib.particle_go_to_time(bullet.transient.collision_fx, 1.0)
    end
end

function bullet_collision(shooterActor, bullet, allSceneActors, walkmap, tpf)
    local props = bullet.not_serializable.properties
    local collision = false
    local walkmapCollision = lib.line_intersect_walkmap(walkmap, lib.vec2(props.previus_position.x, props.previus_position.y), lib.vec2(props.current_position.x, props.current_position.y))
    collision = collision or props.life > props.ttl
    collision = walkmapCollision.intersect
    if collision then
        return { collision = true, collision_point = walkmapCollision.intersection_point }
    end
    local collisionPoint = nil
    for i = 1, #allSceneActors do
        collision = collision or bullet_actor_collision(shooterActor, bullet, allSceneActors[i], tpf)
        collisionPoint = allSceneActors[i]:get_position()
    end
    return { collision = collision, collision_point = collisionPoint }
end

function bullet_actor_collision(shooterActor, bullet, actor, tpf)
    local bulletProps = bullet.not_serializable.properties
    local actorStats = actor:get_stats()
    if shooterActor.serializable.id == actor.serializable.id or not actor.serializable.hittable then
        return false
    end
    if circle_intersect_line(bulletProps.previus_position, bulletProps.current_position, actor:get_position(), actor:get_scaled_rad()) then
        local evt =
        {
            name = k.actor_events.HIT,
            bullet = bullet
        }
        actor:event(tpf, evt)
        local amored = actorStats.armor[1] or actorStats.invincibility[1]
        return armored or not bulletProps.piercing

    end
    return false
end