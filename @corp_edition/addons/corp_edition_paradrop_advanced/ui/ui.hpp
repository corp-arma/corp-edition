/*
    CORP Edition addons
    http://www.corp-arma.fr
*/

#include "ctrls.hpp"

class BaseTitle;
class BaseBackgroundBox;
class BaseListBox;
class BaseEdit;
class BaseMap;
class CancelButton;
class ConfirmButton;
class RscControlsGroup;
class RscText;

class CORP_ParadropAdvancedDialog {
    idd = PARADROP_ADVANCED_DIALOG_IDD;

    onLoad   = "[] spawn CORP_fnc_paradropAdvanced_uiStart;";
    onUnload = "[] spawn CORP_fnc_paradropAdvanced_uiStop;";

    class ControlsBackground {
        class Title: BaseTitle {
            text = $STR_CORP_PARADROP_ADVANCED_DN;
        };

        class Background: BaseBackgroundBox {};
    };

    class Controls {
        class PlayersList: BaseListBox {
            idc = PARADROP_ADVANCED_DIVERLIST_IDC;

            x = safeZoneX + safeZoneW * 0.2;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.1;
            h = safeZoneH * 0.52;

            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };

        class DropList: BaseListBox {
            idc = PARADROP_ADVANCED_DROPLIST_IDC;

            x = safeZoneX + safeZoneW * 0.305;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.1;
            h = safeZoneH * 0.255;

            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };

        class CustomDropParams: RscControlsGroup {
            idc = PARADROP_ADVANCED_CUSTOM_DROP_PARAMS_CONTROLS_GROUP_IDC;
            type = 15;

            x = safeZoneX + safeZoneW * 0.305;
            y = safeZoneY + safeZoneH * 0.475;
            w = safeZoneW * 0.1;
            h = safeZoneH * 0.255;

            class Controls {
                class Background: RscText {
                    x = 0;
                    y = 0;
                    w = safeZoneW * 0.1;
                    h = safeZoneH * 0.255;

                    colorBackground[] = {0.1, 0.1, 0.1, 1};
                };

                class ElevationLabel: RscText {
                    x = 0.01;
                    y = 0.01;
                    w = safeZoneW * 0.09;
                    h = safeZoneH * 0.03;

                    text = $STR_CORP_PARADROP_ADVANCED_ELEVATION;
                };

                class Elevation: BaseEdit {
                    idc = PARADROP_ADVANCED_ELEVATION_IDC;

                    x = 0.01;
                    y = 0.06;
                    w = safeZoneW * 0.09;
                    h = safeZoneH * 0.03;

                    text = "3000";
                };

                class BearingLabel: RscText {
                    x = 0.01;
                    y = 0.12;
                    w = safeZoneW * 0.09;
                    h = safeZoneH * 0.03;

                    text = $STR_CORP_PARADROP_ADVANCED_BEARING;
                };

                class Bearing: BaseEdit {
                    idc = PARADROP_ADVANCED_BEARING_IDC;

                    x = 0.01;
                    y = 0.17;
                    w = safeZoneW * 0.09;
                    h = safeZoneH * 0.03;

                    text = "0";
                };
            };
        };

        class Map: BaseMap {
            idc = PARADROP_ADVANCED_MAP_IDC;

            x = safeZoneX + safeZoneW * 0.41;
            y = safeZoneY + safeZoneH * 0.21;
            w = safeZoneW * 0.39;
            h = safeZoneH * 0.52;
        };

        class CloseButton: CancelButton {
            idc = PARADROP_ADVANCED_CLOSE_IDC;

            x = safeZoneX + safeZoneW * 0.4;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.0975;
            h = safeZoneH * 0.05;
        };

        class TeleportButton: ConfirmButton {
            idc = PARADROP_ADVANCED_JUMP_IDC;

            x = safeZoneX + safeZoneW * 0.5025;
            y = safeZoneY + safeZoneH * 0.74;
            w = safeZoneW * 0.095;
            h = safeZoneH * 0.05;

            text = $STR_CORP_PARADROP_ADVANCED_PARADROP;
        };
    };
};
