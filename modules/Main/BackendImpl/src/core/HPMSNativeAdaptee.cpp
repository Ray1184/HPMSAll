/*!
 * File HPMSNativeAdaptee.h
 */

#include <core/HPMSNativeAdaptee.h>
#include <core/HPMSMaterialHelper.h>

#define ACCURACY 32

void hpms::NativeAdaptee::Clear()
{
    manualObject->clear();
}

void hpms::NativeAdaptee::BeginDraw(const glm::vec4& ambient, const glm::vec4& diffuse)
{
    manualObject->begin(hpms::MaterialHelper::CreateStandardColorMaterial(
            Ogre::ColourValue(ambient.x, ambient.y, ambient.z, ambient.w),
            Ogre::ColourValue(diffuse.x, diffuse.y, diffuse.z, diffuse.w)),
                        Ogre::RenderOperation::OT_LINE_STRIP);

}


void hpms::NativeAdaptee::DrawLine(const glm::vec3& p1, const glm::vec3& p2)
{

    manualObject->position(p1.x, p1.y, p1.z);

}


void hpms::NativeAdaptee::EndDraw()
{
    manualObject->end();

}

void hpms::NativeAdaptee::DrawCircle(const glm::vec3& center, float radius)
{
    unsigned point_index = 0;
    for (float theta = 0; theta <= 2 * Ogre::Math::PI; theta += Ogre::Math::PI / ACCURACY)
    {
        manualObject->position(radius * cos(theta) + center.x, radius * sin(theta) + center.y, center.z);
        manualObject->index(point_index++);
    }
    manualObject->index(0);
}


hpms::NativeAdaptee::NativeAdaptee(hpms::OgreContext* ctx) : AdapteeCommon(ctx)
{
    manualObject = hpms::SafeNewRaw<Ogre::ManualObject>("DebugDrawer");
    manualObject->setDynamic(true);
    ctx->GetSceneManager()->getRootSceneNode()->attachObject(manualObject);
}


hpms::NativeAdaptee::~NativeAdaptee()
{
    ctx->GetSceneManager()->getRootSceneNode()->detachObject(manualObject);
    hpms::SafeDeleteRaw(manualObject);
}

