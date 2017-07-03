/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

class CfgPatches {
	class CORP_Edition_Boat_Projection {
		units[] = {"CORP_Module_BoatProjection"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "A3_3DEN", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionBoatProjection {
			file = "\corp_edition_boat_projection\functions";
			class BoatProjection_Init {};
			class BoatProjection_UiStart {};
			class BoatProjection_UiStop {};
			class BoatProjection_Server {};
			class BoatProjection_Client {};
		};
	};
};

class Cfg3DEN {
	class Attributes {
		class Controls;
		class Title;
		class Value;
		class Edit;
		class SliderDistance;

		class SliderCoastDistance: SliderDistance {
			class Controls: Controls {
				class Title: Title {};
				class Value: Value {
					sliderRange[] = {100, 1000};
					lineSize = 50;
					sliderStep = 50;
				};
				class Edit: Edit {};
			};
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class AttributesBase {
			class Edit;
		};

		class ModuleDescription {
			class AnyStaticObject;
		};
	};

	class CORP_Module_BoatProjection: Module_F {
		scope = 2;
		displayName = $STR_CORP_BOAT_PROJECTION_DN;
		icon = "\corp_edition_boat_projection\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_boatProjection_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		isDisposable = 0;
		is3DEN = 0;

		class Attributes: AttributesBase {
			class CoastDistance: Edit {
				property = "CORP_Module_Hunters_CoastDistance";
				displayName = $STR_CORP_BOAT_PROJECTION_COAST_DISTANCE_DN;
				description = $STR_CORP_BOAT_PROJECTION_COAST_DISTANCE_DESC;
				typeName = "NUMBER";
				defaultValue = "300";
				control = "SliderCoastDistance";
			};
		};
	};
};

#include "ui\ui.hpp"

class CfgCORP {
	class BoatProjection {
		boats[] = {
			{"B_G_Boat_Transport_01_F", 5},
			{"I_C_Boat_Transport_02_F", 8}
		};
	};
};
