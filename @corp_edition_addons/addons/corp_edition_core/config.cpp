class CfgPatches {
	class CORP_Edition_Core {
		units[] = {};
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
	};
};

class CfgFactionClasses {
	class NO_CATEGORY;
	class CORP_Modules: NO_CATEGORY {
		displayName = "CORP Modules";
	};
};

class CfgCORP {};

#include "ui\base.hpp"
