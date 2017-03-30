class CfgPatches {
	class crp_cgs {
		units[] = {"CORP_Module_GearSystem"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionGearSystem {
			file = "\corp_edition_gear_system\functions";
			class GearSystem_Init {};
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

	class CORP_Module_GearSystem: Module_F {
		scope = 2;
		displayName = "Équipement";
		icon = "\corp_edition_gear_system\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_gearSystem_init";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
		is3DEN = 0;
	};
};
