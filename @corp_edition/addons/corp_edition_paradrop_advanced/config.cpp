/*
    CORP Edition addons
    http://www.corp-arma.fr
*/

class CfgPatches {
    class CORP_Edition_Paradrop_Advanced {
        units[] = { "CORP_Module_Paradrop_Advanced" };
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {
            "A3_Modules_F",
            "corp_edition_core"
        };
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class CORPEditionParadropAdvanced {
            file = "\corp_edition\corp_edition_paradrop_advanced\functions";
            class ParadropAdvanced_init {};
            class ParadropAdvanced_uiStart {};
            class ParadropAdvanced_uiStop {};
            class ParadropAdvanced_server {};
            class ParadropAdvanced_client {};
        };
    };
};

class CfgSounds {
    class C130Engine {
        name = "C130 Engine";
        sound[] = { "\corp_edition\corp_edition_paradrop_advanced\data\sounds\ext_engine_low.wss", 1, 1 };
        titles[] = { 0, "" };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Checkbox;
        };

        class ModuleDescription {
            class AnyStaticObject;
        };
    };

    class CORP_Module_Paradrop_Advanced: Module_F {
        scope = 2;
        displayName = $STR_CORP_PARADROP_ADVANCED_DN;
        icon = "corp_edition\corp_edition_paradrop_advanced\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_paradropAdvanced_init";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;

        class Attributes: AttributesBase {
            class CustomDrop: Checkbox {
                property = "CORP_Module_ParadropAdvanced_CustomDrop";
                displayName = $STR_CORP_PARADROP_ADVANCED_CUSTOM_DROP_DN;
                description = $STR_CORP_PARADROP_ADVANCED_CUSTOM_DROP_DESC;
                typeName = "BOOL";
                defaultValue = "false";
            };
        };
    };
};

#include "ui\ui.hpp"
