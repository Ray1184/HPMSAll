--
-- Created by Ray1184.
-- DateTime: 01/01/2022 17:04
--
-- All game instances.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/logic/managers/BundleManager.lua',
    'inst/GameplayConsts.lua',
    'inst/actors/players/DummyPlayer.lua',
    'inst/actors/scene/DummyChest.lua',
    'inst/collectibles/misc/DummyItem.lua',
    'inst/collectibles/weapons/DummyRevolver.lua',
    'inst/collectibles/ammo/Mag44AP.lua',
    'bundles/Objects.lua',
    'bundles/Menu.lua'
}

function register_all_instances()

    k = game_mechanics_consts:get()
    g = game_consts:get()
    bm = bundle_manager:new()

    -- Text bundles.
    bm:register_dictionary(get_bundle_set_menu())
    bm:register_dictionary(get_bundle_set_items())

    -- Players.
    context:inst():register_instance(k.inst_cat.ACTORS, g.res_refs.actors.DUMMY_PLAYER.ID, function() return dummy_player:ret() end)
    
    -- Scene.
    context:inst():register_instance(k.inst_cat.ACTORS, g.res_refs.actors.DUMMY_CHEST.ID, function(id_suffix) return dummy_chest:ret(id_suffix) end)

    -- Inventory.
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_1.ID, function(id_suffix, amount) return dummy_item_1:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_2.ID, function(id_suffix, amount) return dummy_item_2:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_3.ID, function(id_suffix, amount) return dummy_item_3:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_4.ID, function(id_suffix, amount) return dummy_item_4:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_5.ID, function(id_suffix, amount) return dummy_item_5:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_6.ID, function(id_suffix, amount) return dummy_item_6:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_7.ID, function(id_suffix, amount) return dummy_item_7:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_8.ID, function(id_suffix, amount) return dummy_item_8:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_REVOLVER.ID, function(id_suffix, amount) return dummy_revolver:ret(id_suffix, amount) end)
    context:inst():register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.MAG_44_AP.ID, function(id_suffix, amount) return mag_44_ap:ret(id_suffix, amount) end)

end