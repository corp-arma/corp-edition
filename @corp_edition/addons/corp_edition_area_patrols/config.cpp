class CfgPatches {
    class CORP_Edition_Area_Patrols {
        units[] = {"CORP_Module_AreaPatrols"};
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {
            "A3_Modules_F",
            "CORP_Edition_Core",
            "cba_arrays"
        };
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class CORPEditionAreaPatrols {
            file = "\corp_edition_area_patrols\functions";
            class AreaPatrols_init {};
            class AreaPatrols_createAreaPatrol {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
        };

        class ModuleDescription {
            class Anything;
        };
    };

    class CORP_Module_AreaPatrols: Module_F {
        scope = 2;
        displayName = $STR_CORP_AREA_PATROLS_DN;
        icon = "\corp_edition_area_patrols\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_AreaPatrols_init";
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 0;
        is3DEN = 0;

        canSetArea = 1;
        class AttributeValues {
            size3[] = {50, 50, -1};
            isRectangle = 1;
        };

        class Attributes: AttributesBase {
            class NumberOfGroups: Edit {
                property = "CORP_Module_AreaPatrols_NumberOfGroups";
                displayName = $STR_CORP_AREA_PATROLS_NUMBER_OF_GROUPS_DN;
                description = $STR_CORP_AREA_PATROLS_NUMBER_OF_GROUPS_DESC;
                typeName = "NUMBER";
                defaultValue = "4";
            };

            class UnitsPerGroup: Edit {
                property = "CORP_Module_AreaPatrols_UnitsPerGroup";
                displayName = $STR_CORP_AREA_PATROLS_UNITS_PER_GROUP_DN;
                description = $STR_CORP_AREA_PATROLS_UNITS_PER_GROUP_DESC;
                typeName = "NUMBER";
                defaultValue = "4";
            };

            class WaypointsPerGroup: Edit {
                property = "CORP_Module_AreaPatrols_WaypointsPerGroup";
                displayName = $STR_CORP_AREA_PATROLS_WAYPOINTS_PER_GROUP_DN;
                description = $STR_CORP_AREA_PATROLS_WAYPOINTS_PER_GROUP_DESC;
                typeName = "NUMBER";
                defaultValue = "4";
            };

            class DynamicSimulation: Checkbox {
                property = "CORP_Module_AreaPatrols_DynamicSimulation";
                displayName = $STR_CORP_AREA_PATROLS_DYNAMIC_SIMULATION_DN;
                description = $STR_CORP_AREA_PATROLS_DYNAMIC_SIMULATION_DESC;
                typeName = "BOOL";
                defaultValue = "true";
            };

            class Debug: Checkbox {
                property = "CORP_Module_AreaPatrols_Debug";
                displayName = $STR_CORP_AREA_PATROLS_DEBUG_DN;
                description = $STR_CORP_AREA_PATROLS_DEBUG_DESC;
                typeName = "BOOL";
                defaultValue = "false";
            };
        };
    };
};
