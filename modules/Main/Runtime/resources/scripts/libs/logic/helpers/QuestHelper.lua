--
-- Created by Ray1184.
-- DateTime: 25/10/2022 17:04
--
-- Helper for generic quests.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua'
}



function init_quests_state()
    local progress = context_get_progress_state()
    if progress.init == nil then        
        init_progress(progress)
    end

end

function init_progress(progress)
    k = game_mechanics_consts:get()    
    progress.init = true
    progress.statistics = {
        play_time = 0,
        game_difficulty = context_get_state(k.session_vars.GAME_DIFFICULTY),
        save_amount = 0,
        kills = 0,
        solved_puzzles = 0,
        hp_recover_items_used = 0,
        sp_recover_items_used = 0,
        vp_recover_items_used = 0,
        achived_phobies = 0,
        earned_money = 0,
        spent_money = 0
    }
    progress.game_state = {
        shared = {},
        rooms = {}
    }

end
