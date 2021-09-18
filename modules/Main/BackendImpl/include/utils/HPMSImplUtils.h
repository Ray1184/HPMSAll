/*!
 * File HPMSImplUtils.h
 */


#pragma once

namespace hpms {

    inline glm::vec3 Vec3ImplToApi(const Ogre::Vector3& in) {
        return glm::vec3(in.x, in.y, in.z);
    }

    inline Ogre::Vector3 Vec3ApiToImpl(const glm::vec3& in) {
        return Ogre::Vector3(in.x, in.y, in.z);
    }

    inline glm::quat QuatImplToApi(const Ogre::Quaternion& in) {
        return glm::quat(in.x, in.y, in.z);
    }

    inline Ogre::Quaternion QuatApiToImpl(const glm::quat& in) {
        return Ogre::Quaternion(in.x, in.y, in.z);
    }

}