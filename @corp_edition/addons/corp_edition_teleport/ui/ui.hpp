#include "ctrls.hpp"

class BaseTitle;
class BaseBackgroundBox;
class BaseListBox;
class CancelButton;
class ConfirmButton;

class CORP_TeleportDialog {
    idd = TELEPORT_DIALOG_IDD;

    onLoad = "[] spawn CORP_fnc_teleport_uiStart;";

    class controlsBackground {
        class Title: BaseTitle {
            text = $STR_CORP_TELEPORT_DN;
        };

        class Background: BaseBackgroundBox {};
    };

    class Controls {
        class PlayersList: BaseListBox {
            idc = TELEPORT_LIST_IDC;

            x = safeZoneX + safeZoneW * 0.4;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.2;
            h = safeZoneH * 0.52;

            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };

        class CloseButton: CancelButton {
            idc = TELEPORT_CLOSE_IDC;

            x = safeZoneX + safeZoneW * 0.4;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.0975;
            h = safeZoneH * 0.05;
        };

        class TeleportButton: ConfirmButton {
            idc = TELEPORT_TELEPORT_IDC;

            x = safeZoneX + safeZoneW * 0.5025;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.095;
            h = safeZoneH * 0.05;

            text = $STR_CORP_TELEPORT_TELEPORT;
        };
    };
};
