/*!
 * File HPMSObject.h
 */

#pragma once

#include <string>
#include <unordered_map>

namespace hpms
{
	class Object
	{
	public:
		virtual const std::string Name() const = 0;		
	};
}
