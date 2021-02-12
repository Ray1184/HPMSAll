/*!
 * File HPMSInputUtils.h
 */

#pragma once

#include <vector>
#include <string>

namespace hpms {
    struct MouseEvent : public Object
    {
        enum MouseState
        {
            NONE,
            PRESSED_FIRST_TIME,
            PRESSED
        };

        std::string name;
        MouseState state{NONE};

        inline const std::string Name() const override
        {
            return "MouseEvent";
        }
    };

    struct KeyEvent : public Object
    {
        enum KeyState
        {
            NONE,
            PRESSED_FIRST_TIME,
            PRESSED
        };

        std::string name;
        KeyState state{NONE};


        inline const std::string Name() const override
        {
            return "KeyEvent";
        }

    };
}