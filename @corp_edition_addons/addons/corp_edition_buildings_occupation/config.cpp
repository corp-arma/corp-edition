class CfgPatches {
	class CORP_Edition_Buildings_Occupation {
		units[] = {"CORP_Module_BuildingsOccupation"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
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
			class Checkbox;
		};

		class ModuleDescription {
			class Anything;
		};
	};

	class CORP_Module_BuildingsOccupation: Module_F {
		scope = 2;
		displayName = "Occupation des bâtiments";
		icon = "\corp_edition_area_patrols\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_buildingsOccupation_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		class Attributes: AttributesBase {
			class UnitsPerArea: Edit {
				property = "CORP_Module_BuildingsOccupation_UnitsPerArea";
				displayName = "Nb. d'unités/zone";
				description = "Nombre d'unités par zone";
				typeName = "NUMBER";
				defaultValue = "10";
			};

			class KeepPosition: Edit {
				property = "CORP_Module_BuildingsOccupation_KeepPosition";
				displayName = "% d'unités statiques";
				description = "Pourcentage d'unités qui reste en place";
				typeName = "NUMBER";
				defaultValue = "0.5";
			};

			class DynamicSimulation: Checkbox {
				property = "CORP_Module_BuildingsOccupation_DynamicSimulation";
				displayName = "Simulation dynamique";
				description = "activer la Simulation Dynamique pour les groupes créés par le module";
				typeName = "BOOL";
				defaultValue = "true";
			};

			class Debug: Checkbox {
				property = "CORP_Module_BuildingsOccupation_Debug";
				displayName = "Débug";
				description = "Sur carte, déssine les zones et les IA créées";
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
