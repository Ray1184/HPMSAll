-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- All game consts.
-- -

game_mechanics_consts = { }

function game_mechanics_consts:get()

    return {

        player_walk_mode = 
        {
            IDLE = 0,
            WALK_FORWARD = 1,
            WALK_BACK = 2,
            RUN = 3
        },

        player_action_mode =
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
            SUPPLIES = 1,
            KEYS = 2,
            READABLE = 3,
            MISC = 4,
            ACTIONS = 5
        },
        item_license =
        {
            NONE = 0,
            NEEDED = 1,
            FORBIDDEN = 2
        },
        default_animations =
        {
            IDLE = 'Idle',
            WALK_FORWARD = 'Walk_Forward',
            WALK_BACK = 'Walk_Back',
            RUN = 'Run',
            DIE = 'Die'
        }
    }
end