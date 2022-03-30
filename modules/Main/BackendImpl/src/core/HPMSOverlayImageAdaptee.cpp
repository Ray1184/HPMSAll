/*!
 * File HPMSOverlayImageAdaptee.cpp
 */

#include <core/HPMSOverlayImageAdaptee.h>
#include <core/HPMSSceneNodeAdaptee.h>
#include <OgreColourValue.h>


std::string hpms::OverlayImageAdaptee::GetName() const
{
	return name;
}

void hpms::OverlayImageAdaptee::SetPosition(const glm::vec3& position)
{
	Check();
	Check(ogrePanel);
	int z = (int)ogrePanel->getZOrder();
	ogrePanel->setPosition(position.x, position.y);
	if (z != (int)position.z)
	{
		overlay->setZOrder((unsigned int)position.z);
	}


}

glm::vec3 hpms::OverlayImageAdaptee::GetPosition() const
{
	return glm::vec3(ogrePanel->getLeft(), ogrePanel->getTop(), ogrePanel->getZOrder());
}

void hpms::OverlayImageAdaptee::SetRotation(const glm::quat& rotation)
{
	// Not implementend.
}

glm::quat hpms::OverlayImageAdaptee::GetRotation() const
{
	// Not implementend.
	return glm::quat();
}

void hpms::OverlayImageAdaptee::SetScale(const glm::vec3& scale)
{
	// Not implementend.
}

glm::vec3 hpms::OverlayImageAdaptee::GetScale() const
{
	// Not implementend.
	return glm::vec3();
}

void hpms::OverlayImageAdaptee::SetVisible(bool visible)
{
	Check(ogrePanel);
	if (visible)
	{
		ogrePanel->show();
	}
	else {
		ogrePanel->hide();
	}
}

bool hpms::OverlayImageAdaptee::IsVisible() const
{
	Check(ogrePanel);
	return ogrePanel->isEnabled();
}

void hpms::OverlayImageAdaptee::SetBlending(BlendingType mode)
{
	switch (mode)
	{
	case BlendingType::OVERLAY:
		hpms::MaterialHelper::SetMaterialTextureAddMode(ogrePanel->getMaterial());
		break;
	default:
		hpms::MaterialHelper::SetMaterialTextureStandardMode(ogrePanel->getMaterial());
	}
}

void hpms::OverlayImageAdaptee::Show()
{
	Check();
	if (!enabled)
	{
		enabled = true;
		ogrePanel->show();
	}
}

void hpms::OverlayImageAdaptee::Hide()
{
	Check();
	if (enabled)
	{
		enabled = false;
		ogrePanel->hide();
	}
}

void hpms::OverlayImageAdaptee::SetAlpha(float alpha)
{
	Check();
	auto* texState = ogrePanel->getMaterial()->getTechnique(0)->getPass(0)->getTextureUnitState(0);
	texState->setAlphaOperation(Ogre::LayerBlendOperationEx::LBX_MODULATE, Ogre::LayerBlendSource::LBS_TEXTURE, Ogre::LayerBlendSource::LBS_MANUAL, 1.0f, alpha);
}

void hpms::OverlayImageAdaptee::AddNode(hpms::SceneNodeAdapter* node)
{
	Check();
	auto* nodeAdaptee = dynamic_cast<hpms::SceneNodeAdaptee*>(node);
	overlay->add3D(nodeAdaptee->GetNativeNode());
}

void hpms::OverlayImageAdaptee::RemoveNode(hpms::SceneNodeAdapter* node)
{
	Check();
	auto* nodeAdaptee = dynamic_cast<hpms::SceneNodeAdaptee*>(node);
	overlay->remove3D(nodeAdaptee->GetNativeNode());
}


hpms::OverlayImageAdaptee::OverlayImageAdaptee(const std::string& imagePath, int x, int y, int zOrder, OgreContext* ctx) : AdapteeCommon(ctx),
																														   ogrePanel(nullptr),
																														   overlay(nullptr)
{
	Check();
	name = imagePath + "_" + std::to_string(x) + std::to_string(y) + std::to_string(zOrder);
	Ogre::OverlayManager* overlayManager = ctx->GetOverlayManager();
	overlay = overlayManager->getByName("Overlay_" + name);
	if (overlay == nullptr)
	{
		overlay = overlayManager->create("Overlay_" + name);
		ogrePanel = dynamic_cast<Ogre::OverlayContainer*>(overlayManager->createOverlayElement("Panel", "OverlayElement_" + name));
		unsigned int width, height;
		auto material = hpms::MaterialHelper::CreateTexturedMaterial(imagePath, &width, &height, name);
		ogrePanel->setMaterial(material);
		ogrePanel->setMetricsMode(Ogre::GMM_PIXELS);
		ogrePanel->setPosition(x, y);
		ogrePanel->setDimensions(width, height);


		overlay->add2D(ogrePanel);
	}
	else
	{
		ogrePanel = overlay->getChild("OverlayElement_" + name);
	}
	ogrePanel->show();
	overlay->setZOrder(zOrder);
	SetBlending(BlendingType::NORMAL);
	overlay->show();


}

hpms::OverlayImageAdaptee::~OverlayImageAdaptee()
{
	ogrePanel->hide();
	overlay->hide();

}




