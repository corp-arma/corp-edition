#include "ctrls.hpp"

class BaseTitle;
class BaseBackgroundBox;
class BaseListBox;
class BaseEdit;
class BaseMap;
class CancelButton;
class ConfirmButton;

class CORP_ParaJumpClassicDialog {
    idd = PARADROP_DIALOG_IDD;

    onLoad		= "[] spawn CORP_fnc_paradrop_uiStart;";
    onUnload	= "[] spawn CORP_fnc_paradrop_uiStop;";

    class ControlsBackground {
        class Title: BaseTitle {
            text = $STR_CORP_PARADROP_DN;
        };

        class Background: BaseBackgroundBox {};
    };

    class Controls {

        class PlayersList: BaseListBox {
            idc = PARADROP_LIST_IDC;

            x = safeZoneX + safeZoneW * 0.2;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.1;
            h = safeZoneH * 0.52;

            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };

        class Altitude: BaseEdit {
            idc = PARADROP_ALTITUDE_IDC;

            x = safeZoneX + safeZoneW * 0.305;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.1;
            h = safeZoneH * 0.05;

            text = "5000";
            tooltip = $STR_CORP_PARADROP_ELEVATION_TOOLTIP;
        };

        class Map: BaseMap {
            idc = PARADROP_MAP_IDC;

            x = safeZoneX + safeZoneW * 0.41;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.39;
            h = safeZoneH * 0.52;

            tooltip = $STR_CORP_PARADROP_DROPZONE_TOOLTIP;
        };

        class CloseButton: CancelButton {
            idc = PARADROP_CLOSE_IDC;

            x = safeZoneX + safeZoneW * 0.4;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.0975;
            h = safeZoneH * 0.05;
        };

        class TeleportButton: ConfirmButton {
            idc = PARADROP_JUMP_IDC;

            x = safeZoneX + safeZoneW * 0.5025;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.095;
            h = safeZoneH * 0.05;

            text = $STR_CORP_PARADROP_PARADROP;
        };
    };
};