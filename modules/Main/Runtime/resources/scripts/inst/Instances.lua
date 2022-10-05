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
    'inst/collectibles/weapons/Revolver38.lua',
    'inst/collectibles/ammo/Ammo38Explosive.lua',
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
    context_register_instance(k.inst_cat.ACTORS, g.res_refs.actors.DUMMY_PLAYER.ID, function() return dummy_player:ret() end)
    
    -- Scene.
    context_register_instance(k.inst_cat.ACTORS, g.res_refs.actors.DUMMY_CHEST.ID, function(idSuffix) return dummy_chest:ret(idSuffix) end)

    -- Inventory.
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_1.ID, function(idSuffix, amount) return dummy_item_1:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_2.ID, function(idSuffix, amount) return dummy_item_2:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_3.ID, function(idSuffix, amount) return dummy_item_3:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_4.ID, function(idSuffix, amount) return dummy_item_4:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_5.ID, function(idSuffix, amount) return dummy_item_5:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_6.ID, function(idSuffix, amount) return dummy_item_6:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_7.ID, function(idSuffix, amount) return dummy_item_7:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.DUMMY_ITEM_8.ID, function(idSuffix, amount) return dummy_item_8:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.REVOLVER_38.ID, function(idSuffix, amount) return revolver_38:ret(idSuffix, amount) end)
    context_register_instance(k.inst_cat.COLLECTIBLES, g.res_refs.collectibles.AMMO_38_EXPLOSIVE.ID, function(idSuffix, amount) return ammo_38_explosive:ret(idSuffix, amount) end)

end