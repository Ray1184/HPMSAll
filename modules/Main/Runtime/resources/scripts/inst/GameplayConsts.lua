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
                DUMMY_ITEM_1 = { ID = 'dummy_item_1', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_2 = { ID = 'dummy_item_2', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_3 = { ID = 'dummy_item_3', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_4 = { ID = 'dummy_item_4', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_5 = { ID = 'dummy_item_5', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_6 = { ID = 'dummy_item_6', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_7 = { ID = 'dummy_item_7', PATH = 'DummyChest.mesh' },
                DUMMY_ITEM_8 = { ID = 'dummy_item_8', PATH = 'DummyChest.mesh' },
                REVOLVER_38 = { ID = 'revolver_38', PATH = 'Revolver.mesh' },
                AMMO_38_EXPLOSIVE = { ID = 'ammo_38_explosive', PATH = 'MAG_AP.mesh' }
            }
        },
        ammo_names =
        {
            DUMMY_NORMAL = 0,
            DUMMY_SUPER = 1
        }
    }
end