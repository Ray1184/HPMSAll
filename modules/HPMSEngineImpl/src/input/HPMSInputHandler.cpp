/*!
 * File HPMSInputHandler.cpp
 */

#include <input/HPMSInputHandler.h>

hpms::InputHandler::InputHandler()
{
    keyToString[SDL_SCANCODE_UP] = "UP";
    keyToString[SDL_SCANCODE_LEFT] = "LEFT";
    keyToString[SDL_SCANCODE_DOWN] = "DOWN";
    keyToString[SDL_SCANCODE_RIGHT] = "RIGHT";
    keyToString[SDL_SCANCODE_ESCAPE] = "ESC";
    keyToString[SDL_SCANCODE_TAB] = "TAB";
    keyToString[SDL_SCANCODE_RETURN] = "RETURN";
    keyToString[SDL_SCANCODE_LSHIFT] = "LSHIFT";
    keyToString[SDL_SCANCODE_RSHIFT] = "RSHIFT";
    keyToString[SDL_SCANCODE_LCTRL] = "LCTRL";
    keyToString[SDL_SCANCODE_RCTRL] = "RCTRL";
    keyToString[SDL_SCANCODE_LALT] = "LALT";
    keyToString[SDL_SCANCODE_RALT] = "RALT";
    keyToString[SDL_SCANCODE_SPACE] = "SPACE";
    keyToString[SDL_SCANCODE_EXECUTE] = "EXEC";
    keyToString[SDL_SCANCODE_0] = "0";
    keyToString[SDL_SCANCODE_1] = "1";
    keyToString[SDL_SCANCODE_2] = "2";
    keyToString[SDL_SCANCODE_3] = "3";
    keyToString[SDL_SCANCODE_4] = "4";
    keyToString[SDL_SCANCODE_5] = "5";
    keyToString[SDL_SCANCODE_6] = "6";
    keyToString[SDL_SCANCODE_7] = "7";
    keyToString[SDL_SCANCODE_8] = "8";
    keyToString[SDL_SCANCODE_9] = "9";
    keyToString[SDL_SCANCODE_A] = "A";
    keyToString[SDL_SCANCODE_B] = "B";
    keyToString[SDL_SCANCODE_C] = "C";
    keyToString[SDL_SCANCODE_D] = "D";
    keyToString[SDL_SCANCODE_E] = "E";
    keyToString[SDL_SCANCODE_F] = "F";
    keyToString[SDL_SCANCODE_G] = "G";
    keyToString[SDL_SCANCODE_H] = "H";
    keyToString[SDL_SCANCODE_I] = "I";
    keyToString[SDL_SCANCODE_J] = "J";
    keyToString[SDL_SCANCODE_K] = "K";
    keyToString[SDL_SCANCODE_L] = "L";
    keyToString[SDL_SCANCODE_M] = "M";
    keyToString[SDL_SCANCODE_N] = "N";
    keyToString[SDL_SCANCODE_O] = "O";
    keyToString[SDL_SCANCODE_P] = "P";
    keyToString[SDL_SCANCODE_Q] = "Q";
    keyToString[SDL_SCANCODE_R] = "R";
    keyToString[SDL_SCANCODE_S] = "S";
    keyToString[SDL_SCANCODE_T] = "T";
    keyToString[SDL_SCANCODE_U] = "U";
    keyToString[SDL_SCANCODE_V] = "V";
    keyToString[SDL_SCANCODE_W] = "W";
    keyToString[SDL_SCANCODE_X] = "X";
    keyToString[SDL_SCANCODE_Y] = "Y";
    keyToString[SDL_SCANCODE_Z] = "Z";

    keyState[SDL_SCANCODE_UP] = false;
    keyState[SDL_SCANCODE_LEFT] = false;
    keyState[SDL_SCANCODE_DOWN] = false;
    keyState[SDL_SCANCODE_RIGHT] = false;
    keyState[SDL_SCANCODE_ESCAPE] = false;
    keyState[SDL_SCANCODE_TAB] = false;
    keyState[SDL_SCANCODE_RETURN] = false;
    keyState[SDL_SCANCODE_LSHIFT] = false;
    keyState[SDL_SCANCODE_RSHIFT] = false;
    keyState[SDL_SCANCODE_LCTRL] = false;
    keyState[SDL_SCANCODE_RCTRL] = false;
    keyState[SDL_SCANCODE_LALT] = false;
    keyState[SDL_SCANCODE_RALT] = false;
    keyState[SDL_SCANCODE_SPACE] = false;
    keyState[SDL_SCANCODE_EXECUTE] = false;
    keyState[SDL_SCANCODE_0] = false;
    keyState[SDL_SCANCODE_1] = false;
    keyState[SDL_SCANCODE_2] = false;
    keyState[SDL_SCANCODE_3] = false;
    keyState[SDL_SCANCODE_4] = false;
    keyState[SDL_SCANCODE_5] = false;
    keyState[SDL_SCANCODE_6] = false;
    keyState[SDL_SCANCODE_7] = false;
    keyState[SDL_SCANCODE_8] = false;
    keyState[SDL_SCANCODE_9] = false;
    keyState[SDL_SCANCODE_A] = false;
    keyState[SDL_SCANCODE_B] = false;
    keyState[SDL_SCANCODE_C] = false;
    keyState[SDL_SCANCODE_D] = false;
    keyState[SDL_SCANCODE_E] = false;
    keyState[SDL_SCANCODE_F] = false;
    keyState[SDL_SCANCODE_G] = false;
    keyState[SDL_SCANCODE_H] = false;
    keyState[SDL_SCANCODE_I] = false;
    keyState[SDL_SCANCODE_J] = false;
    keyState[SDL_SCANCODE_K] = false;
    keyState[SDL_SCANCODE_L] = false;
    keyState[SDL_SCANCODE_M] = false;
    keyState[SDL_SCANCODE_N] = false;
    keyState[SDL_SCANCODE_O] = false;
    keyState[SDL_SCANCODE_P] = false;
    keyState[SDL_SCANCODE_Q] = false;
    keyState[SDL_SCANCODE_R] = false;
    keyState[SDL_SCANCODE_S] = false;
    keyState[SDL_SCANCODE_T] = false;
    keyState[SDL_SCANCODE_U] = false;
    keyState[SDL_SCANCODE_V] = false;
    keyState[SDL_SCANCODE_W] = false;
    keyState[SDL_SCANCODE_X] = false;
    keyState[SDL_SCANCODE_Y] = false;
    keyState[SDL_SCANCODE_Z] = false;

    mouseButtonToString[tp::MouseButton::LEFT] = "LEFT";
    mouseButtonToString[tp::MouseButton::MIDDLE] = "MIDDLE";
    mouseButtonToString[tp::MouseButton::RIGHT] = "RIGHT";

    mouseButtonState[tp::MouseButton::LEFT] = false;
    mouseButtonState[tp::MouseButton::MIDDLE] = false;
    mouseButtonState[tp::MouseButton::RIGHT] = false;
}


void hpms::InputHandler::HandleKeyboardEvent(std::vector<KeyEvent>& keys)
{
    keys.clear();
    for (auto& entry : keyToString)
    {
        if (tp::InputHelper::Instance().isKeyDown(entry.first))
        {
            KeyEvent evt;
            evt.name = entry.second;
            evt.state = keyState[entry.first] ? KeyEvent::PRESSED : KeyEvent::PRESSED_FIRST_TIME;
            keys.push_back(evt);
            keyState[entry.first] = true;
        } else {
            keyState[entry.first] = false;
        }

    }

}

void hpms::InputHandler::HandleMouseEvent(std::vector<MouseEvent>& mouseButtons, unsigned int* x, unsigned int* y)
{
    mouseButtons.clear();
    for (auto& entry : mouseButtonToString)
    {
        if (tp::InputHelper::Instance().getMouseButtonState(entry.first))
        {
            MouseEvent evt;
            evt.name = entry.second;
            evt.state = mouseButtonState[entry.first] ? MouseEvent::PRESSED : MouseEvent::PRESSED_FIRST_TIME;
            mouseButtons.push_back(evt);
            mouseButtonState[entry.first] = true;
        } else {
            mouseButtonState[entry.first] = false;
        }
    }
    *x = tp::InputHelper::Instance().getMousePosition()->getX();
    *y = tp::InputHelper::Instance().getMousePosition()->getY();
}



