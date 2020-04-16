class CfgPatches {
    class CORP_Edition_Dev {
        units[] = {"CORP_Module_Dev"};
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

        class CORPEditionDev {
            file = "\corp_edition\corp_edition_dev\functions";
            class Dev_Init {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ModuleDescription {
            class AnyPlayer;
        };
    };

    class CORP_Module_Dev: Module_F {
        scope = 2;
        displayName = $STR_CORP_DEV_DN;
        icon = "\corp_edition\corp_edition_dev\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_dev_init";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;
    };
};
