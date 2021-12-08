-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- All game consts.
-- -

consts = { }

function consts:get()

    return {
        items_names =
        {
            -- Weapons.
            DUMMY_WEAPON = 'DUMMY WEAPON',

            -- Supplies.
            DUMMY_FOOD = 'DUMMY_FOOD',

            -- Key items.
            DUMMY_KEY = 'DUMMY KEY',

            -- Readings items.
            DUMMY_BOOK = 'DUMMY BOOK',

            -- Misc items.
            DUMMY_TRESAURE = 'DUMMY TRESAURE'
        },
        res_refs =
        {
            -- Entities paths.
            PLAYER_DUMMY = { PATH = 'actors/EY_DummyAnim.mesh', B_RAD = 0.3098 },



            -- Objects paths.
            DUMMY_WEAPON = 'data/models/DummyWeapon.hmdat',
            DEFAULT_ACTIONS = 'gen/models/Player.hmdat'

        },
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
        },
        ammo_types =
        {
            DUMMY_NORMAL = 0,
            DUMMY_SUPER = 1
        }
    }
end