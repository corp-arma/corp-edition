class CfgPatches {
	class CORP_Edition_SpectatorCam {
		units[] = {"CORP_Module_SpectatorCam"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionSpectatorCam {
			file = "\corp_edition_spectator_Cam\functions";
			class SpectatorCam_Init {};
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

	class CORP_Module_SpectatorCam: Module_F {
		scope = 2;
		displayName = "Caméra spectateur";
		icon = "\corp_edition_spectator_cam\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_spectatorCam_init";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
		is3DEN = 0;
	};
};
