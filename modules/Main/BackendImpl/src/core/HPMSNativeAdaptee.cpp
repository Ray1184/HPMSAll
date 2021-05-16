/*!
 * File HPMSNativeAdaptee.h
 */

#include <core/HPMSNativeAdaptee.h>
#include <core/HPMSMaterialHelper.h>

void hpms::NativeAdaptee::Clear()
{
    manualObject->clear();
}

void hpms::NativeAdaptee::BeginLine(const glm::vec4& ambient, const glm::vec4& diffuse)
{
    manualObject->begin(hpms::MaterialHelper::CreateStandardColorMaterial(
            Ogre::ColourValue(ambient.x, ambient.y, ambient.z, ambient.w),
            Ogre::ColourValue(diffuse.x, diffuse.y, diffuse.z, diffuse.w)),
                        Ogre::RenderOperation::OT_LINE_STRIP);
}


void hpms::NativeAdaptee::DrawLine(const glm::vec3& p1, const glm::vec3& p2)
{

    manualObject->position(p1.x, p1.y, p1.z);
    manualObject->position(p2.x, p2.y, p2.z);

}


void hpms::NativeAdaptee::EndLine()
{
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

