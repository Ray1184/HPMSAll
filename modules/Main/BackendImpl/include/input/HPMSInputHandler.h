/*!
 * File HPMSInputHandler.h
 */


#pragma once

#ifdef CROSS_BUILD
#include <SDL2/SDL.h>
#else
#include <SDL.h>
#endif
#include <map>
#include <common/HPMSObject.h>
#include <common/HPMSUtils.h>
#include <thirdparty/TPInputHelper.h>
#include <api/HPMSInputUtils.h>


namespace hpms
{


	class InputHandler
	{
	private:

		std::map<SDL_Scancode, std::string> keyToString;
		std::map<SDL_Scancode, bool> keyState;

		std::map<tp::MouseButton, std::string> mouseButtonToString;
		std::map<tp::MouseButton, bool> mouseButtonState;

	public:
		InputHandler();

		inline void Update()
		{
			tp::InputHelper::Instance().update();
		}

		void HandleKeyboardEvent(std::vector<KeyEvent>& keys);

		void HandleMouseEvent(std::vector<MouseEvent>& mouseButtons, unsigned int* x, unsigned int* y);


	};
}