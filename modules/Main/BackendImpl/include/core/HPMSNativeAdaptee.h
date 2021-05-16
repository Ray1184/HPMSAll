/*!
 * File HPMSNativeAdaptee.h
 */

#pragma once

#include <api/HPMSNativeAdapter.h>
#include <OgreManualObject.h>
#include <core/HPMSAdapteeCommon.h>

namespace hpms
{
    class NativeAdaptee : public NativeAdapter, public AdapteeCommon
    {
    private:
        Ogre::ManualObject* manualObject;
    public:
        NativeAdaptee(hpms::OgreContext* ctx);

        virtual ~NativeAdaptee();

        void Clear() override;

        void BeginLine(const glm::vec4& ambient, const glm::vec4& diffuse) override;

        void DrawLine(const glm::vec3& p1, const glm::vec3& p2) override;

        void EndLine() override;


    };
}

