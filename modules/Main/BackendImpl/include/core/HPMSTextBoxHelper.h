/*!
 * File HPMSTextBoxHelper.h
 */

#pragma once

#include <OgreFontManager.h>
#include <OgreImage.h>
#include <string>

namespace hpms
{

    class TextBoxHelper
    {
    public:
        static void WriteToTexture(const std::string& str, const Ogre::TexturePtr& destTexture, Ogre::Box destRectangle, const Ogre::FontPtr& font, const Ogre::ColourValue& color, char justify = 'l', bool wordwrap = true);
    };

}
