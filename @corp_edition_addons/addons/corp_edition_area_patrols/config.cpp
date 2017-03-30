class CfgPatches {
	class CORP_Edition_Area_Patrols {
		units[] = {"CORP_Module_AreaPatrols"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionAreaPatrols {
			file = "\corp_edition_area_patrols\functions";
			class AreaPatrols_init {};
			class AreaPatrols_createAreaPatrol {};
		};
	};
};

class CfgVehicles {
	class Logic;

	class Module_F: Logic {
		class AttributesBase {
			class Edit;
			class Checkbox;
		};

		class ModuleDescription {
			class Anything;
		};
	};

	class CORP_Module_AreaPatrols: Module_F {
		scope = 2;
		displayName = "Area Patrols";
		icon = "\corp_edition_area_patrols\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_AreaPatrols_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		class Attributes: AttributesBase {
			class GroupsPerArea: Edit {
				property = "CORP_Module_AreaPatrols_GroupsPerArea";
				displayName = "Nb. groupes/zone";
				description = "Nombre de groupes par zone";
				typeName = "NUMBER";
				defaultValue = "4";
			};

			class UnitsPerGroup: Edit {
				property = "CORP_Module_AreaPatrols_UnitsPerGroup";
				displayName = "Nb. unit&#233;s max/groupe";
				description = "Nombre d'unit&#233;s max par groupe";
				typeName = "NUMBER";
				defaultValue = "4";
			};

			class WaypointsPerGroup: Edit {
				property = "CORP_Module_AreaPatrols_WaypointsPerGroup";
				displayName = "Nb. points de passage/groupe";
				description = "Nombre de points de passage par groupe";
				typeName = "NUMBER";
				defaultValue = "4";
			};
		};
	};
};
