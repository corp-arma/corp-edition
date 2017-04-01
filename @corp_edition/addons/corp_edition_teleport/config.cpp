class CfgPatches {
	class CORP_Edition_Teleport {
		units[] = {"CORP_Module_Teleport"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionTeleport {
			file = "\corp_edition_teleport\functions";
			class Teleport_Init {};
			class Teleport_UiStart {};
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class ModuleDescription {
			class AnyStaticObject;
		};
	};

	class CORP_Module_Teleport: Module_F {
		scope = 2;
		displayName = $STR_CORP_TELEPORT_DN;
		icon = "\corp_edition_teleport\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_teleport_init";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
		is3DEN = 0;
	};
};

#include "ui\ui.hpp"
