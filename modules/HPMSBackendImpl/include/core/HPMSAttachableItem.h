/*!
 * File HPMSAttachableItem.h
 */

#pragma once

namespace hpms {
    class AttachableItem {
    public:
        virtual Ogre::MovableObject* GetNative() = 0;
    };
}
