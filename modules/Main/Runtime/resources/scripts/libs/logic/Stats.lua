---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Decorators for game actors.
---
ctx = require('Context')
return {

    game_item = function(id, path)
        if ctx.game_data['game_items'] == nil then
            ctx.game_data['game_items'] = {}
        end
        if ctx.game_data['game_items'][id] == nil then
            local this = {
                entity = hpms.make_entity(path),
                anim = hpms.make_animator(entity)
            }
            ctx.game_data['game_items'][id] = this
        end

        return ctx.game_data['game_items'][id]
    end,

    get_player = function(path)
        local this = {
            base_data = this(path),
            std_params = {
                hp = 50,
                max_hp = 50,
                sp = 30,
                max_sp = 30,
                vp = 20,
                max_vp = 20,
                lv = 1,
                ap = 0,
                money = 0
            },
            sup_params = {
                frz = 0,
                res = 0,
                int = 0,
                sci = 0,
                tut = 0,
                dex = 0,
                par = 0,
                car = 0,
                ftn = 0
            },
            inventory = {
                -- Empty inventory.
            }
        }
        return this
    end


}