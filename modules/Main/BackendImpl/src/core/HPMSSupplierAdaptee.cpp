/*!
 * File HPMSSupplierAdaptee.cpp
 */

#include <core/HPMSSupplierAdaptee.h>
#include <core/HPMSWalkmapAdaptee.h>
#include <core/HPMSOverlayImageAdaptee.h>
#include <core/HPMSBackgroundImageAdaptee.h>
#include <core/HPMSOverlayTextAreaAdaptee.h>
#include <sstream>


hpms::EntityAdapter* hpms::SupplierAdaptee::CreateEntity(const std::string& path)
{
	Check();
	auto* entity = hpms::SafeNew<hpms::EntityAdaptee>(ctx, path);
	entities.push_back(entity);
	return entity;
}

hpms::SceneNodeAdapter* hpms::SupplierAdaptee::GetRootSceneNode()
{
	Check();
	return rootNode;
}

hpms::CameraAdapter* hpms::SupplierAdaptee::GetCamera()
{
	Check();
	return camera;
}

hpms::LightAdapter* hpms::SupplierAdaptee::CreateLight(float r, float g, float b)
{
	Check();
	auto* light = hpms::SafeNew<hpms::LightAdaptee>(ctx);
	light->SetColor(glm::vec3(r, g, b));
	return light;
}

hpms::ParticleAdapter* hpms::SupplierAdaptee::CreateParticleSystem(const std::string& name, const std::string& templateName)
{
	Check();
	auto* ps = hpms::SafeNew<hpms::ParticleAdaptee>(ctx, name, templateName);
	return ps;
}

hpms::BackgroundImageAdapter*
hpms::SupplierAdaptee::CreateBackgroundImage(const std::string& path)
{
	return hpms::SafeNew<hpms::BackgroundImageAdaptee>(path, ctx);
}


hpms::OverlayImageAdapter*
hpms::SupplierAdaptee::CreateOverlayImage(const std::string& path, int x, int y, int zOrder)
{
	return hpms::SafeNew<hpms::OverlayImageAdaptee>(path, x, y, zOrder, ctx);
}

hpms::OverlayTextAreaAdapter*
hpms::SupplierAdaptee::CreateTextArea(const std::string& message, const std::string& fontName, float fontSize, int x, int y, int width, int height, int zOrder)
{
	return hpms::SafeNew<hpms::OverlayTextAreaAdaptee>(message, fontName, fontSize, x, y, width, height, zOrder, ctx);
}

void hpms::SupplierAdaptee::SetAmbientLight(const glm::vec3& rgb)
{
	Check();
	(ctx)->GetSceneManager()->setAmbientLight(Ogre::ColourValue(rgb.x, rgb.y, rgb.z));
}

hpms::WalkmapAdapter* hpms::SupplierAdaptee::CreateWalkmap(const std::string& name)
{
	return hpms::SafeNew<hpms::WalkmapAdaptee>(name);
}

void hpms::SupplierAdaptee::CleanupPending()
{
	// Deleting all created overlay.
	//Ogre::OverlayManager* overlayManager = ctx->GetOverlayManager();
	//overlayManager->destroyAllOverlayElements();
	//overlayManager->destroyAll();
}

std::string hpms::SupplierAdaptee::GetImplName()
{
	std::stringstream ss;
	ss << "Ogre 3D " << OGRE_VERSION_MAJOR << "." << OGRE_VERSION_MINOR << "." << OGRE_VERSION_PATCH << " (" << OGRE_VERSION_NAME << ")";
	return ss.str();
}


hpms::SupplierAdaptee::SupplierAdaptee(hpms::OgreContext* ctx) : AdapteeCommon(ctx)
{
	Check();
	auto* ogreRootNode = (ctx)->GetSceneManager()->getRootSceneNode();
	rootNode = hpms::SafeNew<hpms::SceneNodeAdaptee>(ctx, ogreRootNode, ogreRootNode->getName(), nullptr, true);
	auto* ogreCamera = (ctx)->GetCamera();
	camera = hpms::SafeNew<hpms::CameraAdaptee>(ctx, ogreCamera->getName());
}

hpms::SupplierAdaptee::~SupplierAdaptee()
{
	hpms::SafeDelete(camera);
	hpms::SafeDelete(rootNode);
	hpms::WalkmapManager::GetSingleton().unloadAll();
}




