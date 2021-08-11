/*!
 * File TPBetaGUI.h
 */


#pragma once

/// Betajaen's GUI 015 Uncompressed
/// Written by Robin "Betajaen" Southern 07-Nov-2006, http://www.ogre3d.org/wiki/index.php/BetaGUI
/// This code is under the Whatevar! licence. Do what you want; but keep the original copyright header.
#include <Ogre.h>
#include <vector>
#include <OgreOverlay.h>
#include <OgreOverlayElement.h>
#include <OgreOverlayContainer.h>
#include <OgreOverlayManager.h>

using namespace Ogre;
using namespace std;
namespace BetaGUI
{

    /// This code is not meant to be readable, if you base your future source on this, I will laugh at you.

    class GUI;

    class Window;

    class Button;

    class TextInput;

    class Callback;

    enum wt
    { /* Window Type */
        NONE = 0,
        MOVE = 1,
        RESIZE = 2,
        RESIZE_AND_MOVE = 3
    };

    class GUI
    {
    public:
        friend class Window;

        friend class Button;

        friend class TextInput;

        GUI(String font, uint fontSize);

        ~GUI();

        bool injectMouse(uint x, uint y, bool LMB);

        bool injectKey(String key, uint x, uint y);

        void injectBackspace(uint x, uint y);

        Window* createWindow(Vector4 Dimensions, String Material, wt type, String caption = "");

        inline void destroyWindow(Window* window)
        {
            mXW = window;
        }

        OverlayContainer* createOverlay(Ogre::String name, Vector2 position, Vector2 dimensions, Ogre::String material = "", Ogre::String caption = "", bool autoAdd = true);

        OverlayContainer* createMousePointer(Vector2 dimensions, Ogre::String material);

    protected:
        Overlay* mO;                        // Main sheet overlay
        std::vector<Window*> WN;                    // Windows
        Window* mXW;                        // Window to destroy
        OverlayContainer* mMP;                // Mouse Pointer Overlay
        String mFont;
        uint mFontSize;
        uint wc, bc, tc;
    };

    class Window
    {
    public:
        friend class Button;

        friend class TextInput;

        friend class GUI;

        Button* createButton(Vector4 Dimensions, String Material, String Text, Callback callback);

        TextInput* createTextInput(Vector4 Dimensions, String Material, String Value, uint length);

        void createStaticText(Vector4 Dimensions, String Text);

        inline void hide()
        {
            mO->hide();
        }

        inline void show()
        {
            mO->show();
        }

        inline bool isVisible()
        {
            return mO->isVisible();
        }

    protected:
        Window(Vector4 Dimensions, String Material, wt type, String caption, GUI* gui);

        ~Window();

        bool check(uint x, uint y, bool LMB);

        bool checkKey(String key, uint x, uint y);

        TextInput* mATI;                // Active TextInput
        Button* mRZ, * mAB, * mTB;            // Resizer, ActiveButton, Titlebar
        uint x, y, w, h;                    // Dimensions
        GUI* mGUI;                        // mGUI pointer
        OverlayContainer* mO;            // Overlay
        std::vector<BetaGUI::Button*> mB;    // Buttons
        std::vector<BetaGUI::TextInput*> mT;    // TextInputs
    };

    class BetaGUIListener
    {
    public:
        virtual void onButtonPress(Button* ref) = 0;
    };

    class Callback
    {
    public:
        friend class Window;

        friend class Button;

        Callback()
        {
            t = 0;
        }

        inline Callback(void(* functionPointer)(Button* ref))
        {
            t = 1;
            fp = functionPointer;
        }

        inline Callback(BetaGUIListener* l)
        {
            t = 2;
            LS = l;
        }

    protected:
        uchar t;                    // Type of callback: 0 - None, 1 - FunctionPointer 2 - GUIListener, 3 - Move Window, 4 - Resize
        void (* fp)(Button* ref);        // Function pointer (if 1)
        BetaGUIListener* LS;        // GuiListener (if 2)
    };

    class Button
    {
    public:
        friend class Window;

        Button(Vector4 Dimensions, String Material, String Text, Callback callback, Window* parent);

        inline ~Button()
        {
            mO->getParent()->removeChild(mO->getName());
            mCP->getParent()->removeChild(mCP->getName());
        }

    protected:
        inline void activate(bool a)
        {
            if (!a && mmn != "")
                mO->setMaterialName(mmn);
            if (a && mma != "")
                mO->setMaterialName(mma);
        }

        inline bool in(uint mx, uint my, uint px, uint py)
        {
            return (!(mx >= x + px && my >= y + py)) || (!(mx <= x + px + w && my <= y + py + h));
        }

        OverlayContainer* mO, * mCP;            // Main Overlay and Caption
        String mmn, mma;                        // MaterialName Normal, MaterialName Active
        BetaGUI::Callback callback;            // Callback to use
        uint x, y, w, h;                        // Dimensions.
    };

    class TextInput
    {
    public:
        friend class Window;

        TextInput(Vector4 Dimensions, String Material, String Value, uint length, Window* parent);

        ~TextInput()
        {}

        inline String getValue()
        {
            return value;
        }

        inline void setValue(String v)
        {

            mCP->setCaption(value = v);
        }

    protected:
        inline bool in(uint mx, uint my, uint px, uint py)
        {
            return (!(mx >= x + px && my >= y + py)) || (!(mx <= x + px + w && my <= y + py + h));
        }

        OverlayContainer* mO, * mCP;
        String mmn, mma, value;
        uint x, y, w, h, length;
    };
} // End of Namespace