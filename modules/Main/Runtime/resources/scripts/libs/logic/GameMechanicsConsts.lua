-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- All game consts.
-- -

game_mechanics_consts = { }

function game_mechanics_consts:get()

    return {
        player_walk_mode =
        {
            IDLE = 0,
            WALK_FORWARD = 1,
            WALK_BACK = 2,
            RUN = 3
        },

        player_action_mode =
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
        default_animations =
        {
            IDLE = 'Idle',
            WALK_FORWARD = 'Walk_Forward',
            WALK_BACK = 'Walk_Back',
            RUN = 'Run',
            DIE = 'Die'
        },
        stat_types =
        {
            STANDARD_PARAMS = 'standard_params',
            SUPPORT_PARAMS = 'support_params',
            NEGATIVE_STATUS_PARAMS = 'negative_status_params',
            POSITIVE_STATUS_PARAMS = 'positive_status_params',
            PHOBIES = 'phobies'
        },
        stats =
        {
            standard_params =
            {
                HP = 'hp',
                MAX_HP = 'max_hp',
                SP = 'sp',
                MAX_SP = 'max_sp',
                VP = 'vp',
                MAX_VP = 'max_vp',
                LV = 'lv',
                AP = 'ap',
                MONEY = 'money',
                ARMOR = 'armor'
            },
            support_params =
            {
                STRENGTH = 'strength',
                STAMINA = 'stamina',
                INTELLIGENCE = 'intelligence',
                SCIENCE = 'science',
                HANDYMAN = 'handyman',
                DEXTERITY = 'dexterity',
                OCCULT = 'occult',
                CHARISMA = 'charisma',
                FORTUNE = 'fortune'
            },
            negative_status_params =
            {

                SLEEP = 'sleep',
                POISON = 'poison',
                TOXIN = 'toxin',
                BURN = 'burn',
                FREEZE = 'freeze',
                BLIND = 'blind',
                PARALYSIS = 'paralysis',
                SHOCK = 'shock'
            },
            positive_status_params =
            {
                REGEN = 'regen',
                RAD = 'rad',
                INVINCIBLITY = 'invinciblity'
            },
            phobies =
            {

                ARACHNOPHOBIA = 'arachnophobia',
                HEMOPHOBIA = 'hemophobia',
                ANTHROPOPHOBIA = 'anthropophobia',
                AQUAPHOBIA = 'aquaphobia',
                PYROPHOBIA = 'pyrophobia',
                ACROPHOBIA = 'acrophobia',
                NECROPHOBIA = 'necrophobia',
                AEROPHOBIA = 'aerophobia',
                AVIOPHOBIA = 'aviophobia',
                PHOTOPHOBIA = 'photophobia',
                NYCTOPHOBIA = 'nyctophobia',
                CRYOPHOBIA = 'cryophobia',
            }
        },
        coll_actions =
        {
            USE = 0,
            CHECK = 1,
            DROP = 2,
            EQUIP = 3,
            EAT_DRINK = 4,
            RELOAD = 5,
            READ = 6
        },
        coll_events =
        {
            PICK = 0,
            COLLISION = 1,
            DROP = 2
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
        }

    }
end