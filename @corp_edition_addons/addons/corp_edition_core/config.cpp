class CfgPatches {
	class CORP_Edition_Core {
		units[] = {"CORP_Module_AreaEllipse", "CORP_Module_AreaRectangle"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class Players {
			file = "\corp_edition_core\functions\players";
			class AlivePlayersRadius {};
		};

		class Geometry {
			file = "\corp_edition_core\functions\geometry";
			class Centroid {};
		};

		class Misc {
			file = "\corp_edition_core\functions\misc";
			class FakeFunction {};
			class GetSideColor {};
		};
	};
};

class CfgFactionClasses {
	class NO_CATEGORY;
	class CORP_Modules: NO_CATEGORY {
		displayName = "CORP Modules";
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class AttributesBase {};

		class ModuleDescription {
			class Anything;
		};
	};

	class CORP_Module_AreaEllipse: Module_F {
		_generalMacro = "CORP_Module_AreaEllipse";
		scope = 2;
		displayName = $STR_CORP_CORE_ELLIPTICAL_AREA_DN;
		icon = "\corp_edition_core\icon_area_ellipse.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_fakeFunction";
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		canSetArea = 1;
		class AttributeValues {
			size3[]={20, 20, -1};
		};
	};

	class CORP_Module_AreaRectangle: CORP_Module_AreaEllipse {
		_generalMacro = "CORP_Module_AreaRectangle";
		displayName = $STR_CORP_CORE_RECTANGULAR_AREA_DN;
		icon = "\corp_edition_core\icon_area_rectangle.paa";

		class AttributeValues {
			size3[] = {20, 20, -1};
			isRectangle = 1;
		};
	};
};

class CfgCORP {};

#include "ui\base.hpp"
