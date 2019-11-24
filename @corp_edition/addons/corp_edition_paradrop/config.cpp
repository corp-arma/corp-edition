class CfgPatches {
    class CORP_Edition_Paradrop {
        units[] = {"CORP_Module_Paradrop"};
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class CORPEditionParadrop {
            file = "\corp_edition_paradrop\functions";
            class Paradrop_Init {};
            class Paradrop_UiStart {};
            class Paradrop_UiStop {};
            class Paradrop_Paradrop {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ModuleDescription {
            class AnyStaticObject;
        };
    };

    class CORP_Module_Paradrop: Module_F {
        scope = 2;
        displayName = $STR_CORP_PARADROP_DN;
        icon = "\corp_edition_paradrop\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_paradrop_init";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;
    };
};

#include "ui\ui.hpp"
