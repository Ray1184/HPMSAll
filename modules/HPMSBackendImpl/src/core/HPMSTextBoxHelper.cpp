/*!
 * File HPMSTextBoxHelper.cpp
 */

#include <core/HPMSTextBoxHelper.h>
#include <Ogre.h>
#include <common/HPMSUtils.h>

void hpms::TextBoxHelper::WriteToTexture(const std::string& str, const Ogre::TexturePtr& destTexture, Ogre::Box destRectangle, const Ogre::FontPtr& font, const Ogre::ColourValue& color, char justify, bool wordwrap)
{
    if (destTexture->getHeight() < destRectangle.bottom)
    {
        destRectangle.bottom = destTexture->getHeight();
    }
    if (destTexture->getWidth() < destRectangle.right)
    {
        destRectangle.right = destTexture->getWidth();
    }

    if (!font->isLoaded())
    {
        font->load();
    }

    Ogre::TexturePtr fontTexture = (Ogre::TexturePtr) Ogre::TextureManager::getSingleton().getByName(font->getMaterial()->getTechnique(0)->getPass(0)->getTextureUnitState(0)->getTextureName());

    Ogre::HardwarePixelBufferSharedPtr fontBuffer = fontTexture->getBuffer();
    Ogre::HardwarePixelBufferSharedPtr destBuffer = destTexture->getBuffer();

    Ogre::PixelBox destPb = destBuffer->lock(destRectangle, Ogre::HardwareBuffer::HBL_NORMAL);

    size_t nBuffSize = fontBuffer->getSizeInBytes();
    Ogre::uint8* buffer = (Ogre::uint8*) calloc(nBuffSize, sizeof(Ogre::uint8));

    Ogre::PixelBox fontPb(fontBuffer->getWidth(), fontBuffer->getHeight(), fontBuffer->getDepth(), fontBuffer->getFormat(), buffer);
    fontBuffer->blitToMemory(fontPb);

    Ogre::uint8* fontData = static_cast<Ogre::uint8*>( fontPb.data );
    Ogre::uint8* destData = static_cast<Ogre::uint8*>( destPb.data );

    const size_t fontPixelSize = Ogre::PixelUtil::getNumElemBytes(fontPb.format);
    const size_t destPixelSize = Ogre::PixelUtil::getNumElemBytes(destPb.format);

    const size_t fontRowPitchBytes = fontPb.rowPitch * fontPixelSize;
    const size_t destRowPitchBytes = destPb.rowPitch * destPixelSize;

    auto* glyphTexCoords = hpms::SafeNewArrayRaw<Ogre::Box>(str.size());

    Ogre::Font::UVRect glypheTexRect;
    size_t charheight = 0;
    size_t charwidth = 0;

    for (unsigned int i = 0; i < str.size(); i++)
    {
        if ((str[i] != '\t') && (str[i] != '\n') && (str[i] != ' '))
        {
            glypheTexRect = font->getGlyphTexCoords(str[i]);
            glyphTexCoords[i].left = glypheTexRect.left * fontTexture->getSrcWidth();
            glyphTexCoords[i].top = glypheTexRect.top * fontTexture->getSrcHeight();
            glyphTexCoords[i].right = glypheTexRect.right * fontTexture->getSrcWidth();
            glyphTexCoords[i].bottom = glypheTexRect.bottom * fontTexture->getSrcHeight();

            if (glyphTexCoords[i].getHeight() > charheight)
            {
                charheight = glyphTexCoords[i].getHeight();
            }
            if (glyphTexCoords[i].getWidth() > charwidth)
            {
                charwidth = glyphTexCoords[i].getWidth();
            }
        }

    }

    size_t cursorX = 0;
    size_t cursorY = 0;
    size_t lineend = destRectangle.getWidth();
    bool carriagreturn = true;
    for (unsigned int strindex = 0; strindex < str.size(); strindex++)
    {
        switch (str[strindex])
        {
            case ' ':
                cursorX += charwidth;
                break;
            case '\t':
                cursorX += charwidth * 3;
                break;
            case '\n':
                cursorY += charheight;
                carriagreturn = true;
                break;
            default:
            {
                if ((cursorX + glyphTexCoords[strindex].getWidth() > lineend) && !carriagreturn)
                {
                    cursorY += charheight;
                    carriagreturn = true;
                }

                if (carriagreturn)
                {
                    size_t l = strindex;
                    size_t textwidth = 0;
                    size_t wordwidth = 0;

                    while ((l < str.size()) && (str[l] != '\n)'))
                    {
                        wordwidth = 0;

                        switch (str[l])
                        {
                            case ' ':
                                wordwidth = charwidth;
                                ++l;
                                break;
                            case '\t':
                                wordwidth = charwidth * 3;
                                ++l;
                                break;
                            case '\n':
                                l = str.size();
                        }

                        if (wordwrap)
                        {
                            while ((l < str.size()) && (str[l] != ' ') && (str[l] != '\t') && (str[l] != '\n'))
                            {
                                wordwidth += glyphTexCoords[l].getWidth();
                                ++l;
                            }
                        } else
                        {
                            wordwidth += glyphTexCoords[l].getWidth();
                            l++;
                        }

                        if ((textwidth + wordwidth) <= destRectangle.getWidth())
                        {
                            textwidth += (wordwidth);
                        } else
                        {
                            break;
                        }
                    }

                    if ((textwidth == 0) && (wordwidth > destRectangle.getWidth()))
                    {
                        textwidth = destRectangle.getWidth();
                    }

                    switch (justify)
                    {
                        case 'c':
                            cursorX = (destRectangle.getWidth() - textwidth) / 2;
                            lineend = destRectangle.getWidth() - cursorX;
                            break;

                        case 'r':
                            cursorX = (destRectangle.getWidth() - textwidth);
                            lineend = destRectangle.getWidth();
                            break;

                        default:
                            cursorX = 0;
                            lineend = textwidth;
                            break;
                    }

                    carriagreturn = false;
                }

                if ((cursorY + charheight) > destRectangle.getHeight())
                {
                    goto stop;
                }

                for (size_t i = 0; i < glyphTexCoords[strindex].getHeight(); i++)
                    for (size_t j = 0; j < glyphTexCoords[strindex].getWidth(); j++)
                    {
                        float alpha = color.a * (fontData[(i + glyphTexCoords[strindex].top) * fontRowPitchBytes + (j + glyphTexCoords[strindex].left) * fontPixelSize + 1] / 255.0);
                        float invalpha = 1.0 - alpha;
                        size_t offset = (i + cursorY) * destRowPitchBytes + (j + cursorX) * destPixelSize;
                        Ogre::ColourValue pix;
                        Ogre::PixelUtil::unpackColour(&pix, destPb.format, &destData[offset]);
                        pix = (pix * invalpha) + (color * alpha);
                        Ogre::PixelUtil::packColour(pix, destPb.format, &destData[offset]);
                    }

                cursorX += glyphTexCoords[strindex].getWidth();
            }
        }
    }

    stop:
    hpms::SafeDeleteArrayRaw(glyphTexCoords);

    destBuffer->unlock();

    free(buffer);
    buffer = nullptr;
}
