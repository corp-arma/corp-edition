/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

#include "ctrls.hpp"

class BaseTitle;
class BaseBackgroundBox;
class BaseListBox;
class BaseMap;
class CancelButton;
class ConfirmButton;

class CORP_BoatProjectionDialog {
	idd = BOAT_PROJECTION_DIALOG_IDD;

	onLoad		= "[] spawn CORP_fnc_boatProjection_uiStart;";
	onUnload	= "[] spawn CORP_fnc_boatProjection_uiStop;";

	class ControlsBackground {
		class Title: BaseTitle {
			text = $STR_CORP_BOAT_PROJECTION_DN;
		};

		class Background: BaseBackgroundBox {};
	};

	class Controls {
		class PlayersList: BaseListBox {
			idc = BOAT_PROJECTION_LIST_IDC;

			x = safeZoneX + safeZoneW * 0.2;
			y = safeZoneY + safeZoneH * 0.21;
			w = safeZoneW * 0.1;
			h = safeZoneH * 0.52;

			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};

		class BoatList: BaseListBox {
			idc = BOAT_PROJECTION_BOATLIST_IDC;

			x = safeZoneX + safeZoneW * 0.305;
			y = safeZoneY + safeZoneH * 0.21;
			w = safeZoneW * 0.1;
			h = safeZoneH * 0.52;

			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};

		class Map: BaseMap {
			idc = BOAT_PROJECTION_MAP_IDC;

			x = safeZoneX + safeZoneW * 0.41;
			y = safeZoneY + safeZoneH * 0.21;
			w = safeZoneW * 0.39;
			h = safeZoneH * 0.52;

			tooltip = $STR_CORP_PARADROP_ADVANCED_MAP_TOOLTIP;
		};

		class CloseButton: CancelButton {
			idc = BOAT_PROJECTION_CLOSE_IDC;

			x = safeZoneX + safeZoneW * 0.4;
			y = safeZoneY + safeZoneH * 0.74;
			w = safeZoneW * 0.0975;
			h = safeZoneH * 0.05;
		};

		class ProjectionButton: ConfirmButton {
			idc = BOAT_PROJECTION_PROJECTION_IDC;

			x = safeZoneX + safeZoneW * 0.5025;
			y = safeZoneY + safeZoneH * 0.74;
			w = safeZoneW * 0.095;
			h = safeZoneH * 0.05;

			text = $STR_CORP_PARADROP_ADVANCED_PROJECTION;
		};
	};
};
