/*!
 * File HPMSNativeAdaptee.h
 */

#include <core/HPMSNativeAdaptee.h>
#include <core/HPMSMaterialHelper.h>

void hpms::NativeAdaptee::DrawLine(const glm::vec3& p1, const glm::vec3& p2)
{
    manualObject->begin(hpms::MaterialHelper::CreateStandardColorMaterial(
            Ogre::ColourValue(1, 1, 1, 1),
            Ogre::ColourValue(0, 1, 0, 1)),
                        Ogre::RenderOperation::OT_LINE_STRIP);
    manualObject->position(p1.x, p1.y, p1.z);
    manualObject->position(p2.x, p2.y, p2.z);
    manualObject->end();
}

hpms::NativeAdaptee::NativeAdaptee(hpms::OgreContext* ctx) : AdapteeCommon(ctx)
{
    manualObject = hpms::SafeNewRaw<Ogre::ManualObject>("DebugDrawer");
    ctx->GetSceneManager()->getRootSceneNode()->attachObject(manualObject);
}


hpms::NativeAdaptee::~NativeAdaptee()
{
    ctx->GetSceneManager()->getRootSceneNode()->detachObject(manualObject);
    hpms::SafeDeleteRaw(manualObject);
}

