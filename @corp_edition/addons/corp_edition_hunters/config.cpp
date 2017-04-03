class CfgPatches {
	class CORP_Edition_Hunters {
		units[] = {"CORP_Module_Hunters"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core", "cba_arrays"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionHunters {
			file = "\corp_edition_hunters\functions";
			class Hunters_Init {};
			class Hunters_CheckAndCreateHunters {};
			class Hunters_HuntersBehaviour {};
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class AttributesBase {
			class Edit;
			class Combo;
			class Checkbox;
		};

		class ModuleDescription {
			class Anything;
		};
	};

	class CORP_Module_Hunters: Module_F {
		scope = 2;
		displayName = $STR_CORP_HUNTERS_DN;
		icon = "\corp_edition_hunters\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_hunters_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		class Attributes: AttributesBase {
			class HuntingUnits: Edit {
				property = "CORP_Module_Hunters_HuntingUnits";
				displayName = $STR_CORP_HUNTERS_HUNTING_UNITS_DN;
				description = $STR_CORP_HUNTERS_HUNTING_UNITS_DESC;
				typeName = "NUMBER";
				defaultValue = "4";
			};

			class RespawnDistance: Combo {
				property = "CORP_Module_Hunters_RespawnDistance";
				displayName = $STR_CORP_HUNTERS_RESPAWN_DISTANCE_DN;
				description = $STR_CORP_HUNTERS_RESPAWN_DISTANCE_DESC;
				typeName = "NUMBER";
				defaultValue = "300";

				class Values {
					class 100 {name = "100m"; value = 100;};
					class 200 {name = "200m"; value = 200;};
					class 300 {name = "300m"; value = 300;};
					class 400 {name = "400m"; value = 400;};
					class 500 {name = "500m"; value = 500;};
					class 600 {name = "600m"; value = 600;};
				};
			};

			class Condition: Edit {
				property = "CORP_Module_Hunters_Condition";
				displayName = $STR_CORP_HUNTERS_CONDITION_DN;
				description = $STR_CORP_HUNTERS_CONDITION_DESC;
				typeName = "STRING";
				defaultValue = """true""";
			};

			class Debug: Checkbox {
				property = "CORP_Module_Hunters_Debug";
				displayName = $STR_CORP_HUNTERS_DEBUG_DN;
				description = $STR_CORP_HUNTERS_DEBUG_DESC;
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};
};
