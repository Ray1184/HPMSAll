--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Common keys functions.
--


input_common = { }

function input_common:get()

    return {

        input_actions =
        {
            UP = 0,
            DOWN = 1,
            LEFT = 2,
            RIGHT = 3,
            INVENTORY = 4,
            EXIT = 5,
            ACTION_1 = 6,
            ACTION_2 = 7,
            ACTION_3 = 8,
            PAUSE = 9
        },
        states =
        {
            PRESSED = 2,
            PRESSED_FIRST_TIME = 1,
            RELEASED = 3,
            NONE = 0

        }
    }
end