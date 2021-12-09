-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- All game consts.
-- -

game_mechanics_consts = { }

function game_mechanics_consts:get()

    return {

        player_modes =
        {
            SEARCH = 0,
            COMBAT = 1,
            EQUIP_HANDGUN = 2,
            EQUIP_SHOTGUN = 3,
            EQUIP_MG = 4,
            EQUIP_RIFLE = 5,
            EQUIP_THROWABLE = 6,
            PUSH = 7,
            STEALTH = 8,
            SWIM = 9,
            JUMP = 10
        },
        item_types =
        {
            WEAPON = 0,
            CONSUMABLE = 1,
            READABLE = 2,
            SUPPORT = 3,
            ACTIONS = 4
        },
        item_license =
        {
            NONE = 0,
            NEEDED = 1,
            FORBIDDEN = 2
        }
    }
end