--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- All game consts.
--

game_consts = { }

function game_consts:get()

    return {
        res_refs =
        {
            -- Entities paths.

            actors =
            {
                DUMMY_PLAYER = { ID = 'dummy_player', PATH = 'DummyAnim.mesh', B_RAD = 0.3098, B_RECT = { x = 0.439, y = 0.439 }, GHOST = false },
                DUMMY_CHEST = { ID = 'dummy_chest', PATH = 'DummyChest.mesh', B_RAD = 0.6410, B_RECT = { x = 0.909, y = 0.909 }, GHOST = false }
            },
            collectibles =
            {
                DUMMY_ITEM = { ID = 'dummy_item', PATH = 'DummyChest.mesh' }
            }




        },
        ammo_names =
        {
            DUMMY_NORMAL = 0,
            DUMMY_SUPER = 1
        }
    }
end