-- -
--- Created by Ray1184.
--- DateTime: 01/01/2022 17:04
-- -
--- All game instances.
-- -

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua',
    'inst/charas/players/Player_DummyPlayer.lua',
    'inst/actors/scene_objects/SceneObject_DummyChest.lua'
}

function register_all_instances()

    k = game_mechanics_consts:get()
    g = game_consts:get()

    -- Players.
    context:inst():register_instance(k.inst_cat.PLAYERS, g.res_refs.players.DUMMY_PLAYER.ID, function() return dummy_player:ret() end)
    
    -- Actors.
    context:inst():register_instance(k.inst_cat.ACTORS, g.res_refs.actors.DUMMY_CHEST.ID, function(id_suffix) return dummy_chest:ret(id_suffix) end)

end