-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- All game consts.
-- -

game_consts = { }

function game_consts:get()

    return {
        items_names =
        {
            -- Weapons.
            DUMMY_WEAPON = 'DUMMY WEAPON',

            -- Supplies.
            DUMMY_FOOD = 'DUMMY FOOD',

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
            PLAYER_DUMMY = { PATH = 'DummyAnim.mesh', B_RAD = 0.3098 },



            -- Objects paths.
            DUMMY_WEAPON = 'data/models/DummyWeapon.hmdat',
            DEFAULT_ACTIONS = 'gen/models/Player.hmdat'

        },
        ammo_names =
        {
            DUMMY_NORMAL = 0,
            DUMMY_SUPER = 1
        }
    }
end