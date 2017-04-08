class CfgPatches {
	class CORP_Edition_Buildings_Occupation {
		units[] = {"CORP_Module_BuildingsOccupation"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core", "cba_arrays"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionBuildingsOccupation {
			file = "\corp_edition_buildings_occupation\functions";
			class BuildingsOccupation_Init {};
			class BuildingsOccupation_Occupation {};
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

	class CORP_Module_BuildingsOccupation: Module_F {
		scope = 2;
		displayName = $STR_CORP_BUILDINGS_OCCUPATION_DN;
		icon = "\corp_edition_buildings_occupation\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_buildingsOccupation_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		canSetArea = 1;
		class AttributeValues {
			size3[]={50, 50, -1};
		};

		class Attributes: AttributesBase {
			class NumberOfUnits: Edit {
				property = "CORP_Module_BuildingsOccupation_NumberOfUnits";
				displayName = $STR_CORP_BUILDINGS_OCCUPATION_NUMBER_OF_UNITS_DN;
				description = $STR_CORP_BUILDINGS_OCCUPATION_NUMBER_OF_UNITS_DESC;
				typeName = "NUMBER";
				defaultValue = "10";
			};

			class KeepPosition: Combo {
				property = "CORP_Module_BuildingsOccupation_KeepPosition";
				displayName = $STR_CORP_BUILDINGS_OCCUPATION_KEEP_POSITION_DN;
				description = $STR_CORP_BUILDINGS_OCCUPATION_KEEP_POSITION_DESC;
				typeName = "NUMBER";
				defaultValue = "0.5";

				class Values {
					class 0	{name = "0%";	value = 0;};
					class 10 {name = "10%"; value = 0.1;};
					class 20 {name = "20%"; value = 0.2;};
					class 30 {name = "30%"; value = 0.3;};
					class 40 {name = "40%"; value = 0.4;};
					class 50 {name = "50%"; value = 0.5;};
					class 60 {name = "60%"; value = 0.6;};
					class 70 {name = "70%"; value = 0.7;};
					class 80 {name = "80%"; value = 0.8;};
					class 90 {name = "90%"; value = 0.9;};
					class 100 {name = "100%"; value = 1;};
				};
			};

			class DynamicSimulation: Checkbox {
				property = "CORP_Module_BuildingsOccupation_DynamicSimulation";
				displayName = $STR_CORP_BUILDINGS_OCCUPATION_DYNAMIC_SIMULATION_DN;
				description = $STR_CORP_BUILDINGS_OCCUPATION_DYNAMIC_SIMULATION_DESC;
				typeName = "BOOL";
				defaultValue = "true";
			};

			class Debug: Checkbox {
				property = "CORP_Module_BuildingsOccupation_Debug";
				displayName = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_DN;
				description = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_DESC;
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};
};

class CfgCORP {
	class BuildingsOccupation {
		class Buildings {
			// bâtiments Arma 3 vanilla, Stratis, Altis
			#include "includes\vanilla.hpp"

			// bâtiments de Tanoa
			#include "includes\tanoa.hpp"

			// bâtiments Tchernarus
			#include "includes\european.hpp"

			// bâtiments Takistan
			#include "includes\middleEastern.hpp"

			// bâtiments Sahrani
			#include "includes\sahrani.hpp"
		};
	};
};
