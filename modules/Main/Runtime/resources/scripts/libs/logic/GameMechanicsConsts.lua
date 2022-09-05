--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- All game consts.
--

game_mechanics_consts = { }

function game_mechanics_consts:get()

    return {

        HPMS_VERSION = 1.0,
        -- 100 hours
        DEFAULT_GLOBAL_TIMER_LIMIT = 320000,

        -- 1 hour
        DEFAULT_WORKFLOW_TIMER_LIMIT = 3200,

        -- 1 minute
        DEFAULT_ANIM_TIMER_LIMIT = 60,

        DEFAULT_MIN_PUSH_DISTANCE = 0.1,

        DEFAULT_MIN_PICK_DISTANCE = 0.3,

        DEFAULT_ANIM_TRANSITION_TIME = 4,

        DEFAULT_GAVITY = 0.98,

        DEFAULT_MAX_STEP_HEIGHT = 0.1,

        INVENTORY_DISPLAY_LIST_SIZE = 5,

        ACTIONS_DISPLAY_LIST_SIZE = 3,

        input_actions =
        {
            INVENTORY = 'INVENTORY',
            UP = 'UP',
            DOWN = 'DOWN',
            LEFT = 'LEFT',
            RIGHT = 'RIGHT',
            EXIT = 'EXIT',
            ACTION_1 = 'ACTION_1',
            ACTION_2 = 'ACTION_2',
            ACTION_3 = 'ACTION_3',
            PAUSE = 'PAUSE'
        },

        anim_modes =
        {
            ANIM_MODE_LOOP = 0,
            ANIM_MODE_ONCE = 1,
            ANIM_MODE_FRAME = 2
        },

        input_modes =
        {
            PRESSED_FIRST_TIME = 1,
            PRESSED = 2,
            RELEASED = 3,
            NONE = 0

        },

        room_state_items =
        {
            ACTORS = 'actors',
            COLLECTIBLES = 'collectibles',
            VARIABLES = 'variables'

        },
        actor_move_mode =
        {
            IDLE = 0,
            WALK_FORWARD = 1,
            WALK_BACK = 2,
            RUN = 3
        },

        actor_move_ratio =
        {
            FASTEST = 4,
            FASTER = 3,
            FAST = 2,
            NORMAL = 1.5,
            SLOW = 1,
            SLOWER = 0.5,
            SLOWEST = 0.25
        },

        actor_action_mode =
        {
            SEARCH = 0,
            COMBAT = 1,
            EQUIP = 2,
            PUSH = 3,
            STEALTH = 4,
            SWIM = 5,
            JUMP = 6,
            CROWL = 7
        },
        menu_modes =
        {
            STATISTICS = 0,
            INVENTORY = 1,
            SKILLS = 2,
            OPTIONS = 3
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


        item_actions =
        {
            USE = 'actions_use',
            SEARCH = 'actions_search',
            CHECK = 'actions_check',
            DROP = 'actions_drop',
            EQUIP = 'actions_equip',
            EAT_DRINK = 'actions_eat_drink',
            RELOAD = 'actions_reload',
            READ = 'actions_read'
        },

        item_events =
        {
            PICK = 0,
            COLLISION = 1,
            DROP = 2,
            PUSH = 3,
            ACTION = 4
        },
        actor_events =
        {
            COLLISION = 1,
            PUSH = 2,
            HIT = 3
        },
        inst_cat =
        {
            PLAYERS = 'players',
            NPCS = 'npcs',
            ACTORS = 'actors',
            COLLECTIBLES = 'collectibles'
        },
        diplay_msg_styles =
        {
            MSG_BOX = 'msg_box',
            BOOK = 'book'
        },
        overlay_colors =
        {
            BLACK = 'black'
        },
        session_vars =
        {
            LAST_ROOM = 'var_last_room',
            INV_ACTION = 'var_inv_action',
            CURRENT_PLAYER_ID = 'var_current_player_id',
            CURRENT_PLAYER_REF = 'var_current_player_ref',
            PICKED_ITEM_ID = 'var_picked_item_id',
            PICKED_ITEM_AMOUNT = 'var_picked_item_amount'
        },
        queued_events =
        {
            DROP_ITEMS = 'evt_drop_items',
            EQUIP_ITEMS = 'evt_equip_items'
        },
        inventory_scope =
        {
            SCOPE_LIST = 1,
            SCOPE_ACTIONS = 2,
            SCOPE_PICK = 3
        },
        attachable_bones =
        {
            HAND = 'Hand.R'
        },
        default_animations =
        {
            IDLE = 'Idle',
            WALK_FORWARD = 'Walk_Forward',
            WALK_BACK = 'Walk_Back',
            RUN = 'Run',
            PUSH = 'Push',
            DIE = 'Die',
            FIGHT_POSITION = 'Fight_Position',
            FIGHT_KICK = 'Fight_Kick',
            FIGHT_LEFT_PUNCH = 'Fight_Left_Punch',
            FIGHT_RIGHT_PUNCH = 'Fight_Right_Punch',
            EQUIP_KNIFE = 'Equip_Knife',
            HIT_KNIFE = 'Hit_Knife',
            EQUIP_BAT = 'Equip_Bat',
            HIT_BAT = 'Hit_Bat',
            EQUIP_SWORD = 'Equip_Sword',
            HIT_SWORD = 'Hit_Sword',
            EQUIP_HANDGUN_1 = 'Equip_Handgun_1',
            FIRE_HANDGUN_1 = 'Fire_Handgun_1',
            EQUIP_HANDGUN_2 = 'Equip_Handgun_2',
            FIRE_HANDGUN_2 = 'Fire_Handgun_2',
            EQUIP_RIFLE_1 = 'Equip_Rifle_1',
            FIRE_RIFLE_1 = 'Fire_Rifle_1',
            EQUIP_RIFLE_2 = 'Equip_Rifle_2',
            FIRE_RIFLE_2 = 'Fire_Rifle_2',
            EQUIP_RIFLE_3 = 'Equip_Rifle_3',
            FIRE_RIFLE_3 = 'Fire_Rifle_3',
            EQUIP_SINGLE_SHOT_RIFLE = 'Equip_Single_Shot_Rifle',
            FIRE_SINGLE_SHOT_RIFLE = 'Fire_Single_Shot_Rifle',
            EQUIP_SMG = 'Equip_SMG',
            FIRE_SMG = 'Fire_SMG',
            EQUIP_LMG = 'Equip_LMG',
            FIRE_LMG = 'Fire_LMG',
            EQUIP_NO_RECOIL_HANDGUN = 'Equip_No_Recoil_Handgun',
            FIRE_NO_RECOIL_HANDGUN = 'Fire_No_Recoil_Handgun',
            EQUIP_NO_RECOIL_RIFLE = 'Equip_No_Recoil_Rifle',
            FIRE_NO_RECOIL_RIFLE = 'Fire_No_Recoil_Rifle',
            EQUIP_THROWABLE = 'Equip_Throwable',
            THROW = 'Throw'
        }


    }
end