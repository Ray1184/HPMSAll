--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- All game consts.
--

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
            players =
            {
                DUMMY_PLAYER = { ID = 'dummy_player', PATH = 'DummyAnim.mesh', B_RAD = 0.3098, B_RECT = { x = 0.439, y = 0.439 }, GHOST = false }
            },
            actors =
            {
                DUMMY_CHEST = { ID = 'dummy_chest', PATH = 'DummyChest.mesh', B_RAD = 0.6410, B_RECT = { x = 0.909, y = 0.909 }, GHOST = false }
            }




        },
        ammo_names =
        {
            DUMMY_NORMAL = 0,
            DUMMY_SUPER = 1
        }
    }
end