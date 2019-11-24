class CfgPatches {
    class CORP_Edition_Buildings_Occupation {
        units[] = {"CORP_Module_BuildingsOccupation"};
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {"A3_Modules_F", "A3_3DEN", "corp_edition_core", "cba_arrays"};
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class CORPEditionBuildingsOccupation {
            file = "\corp_edition_buildings_occupation\functions";
            class BuildingsOccupation_Init {};
            class BuildingsOccupation_Occupation {};
            class BuildingsOccupation_getRelPos {};
        };
    };
};

class Cfg3DEN {
    class Attributes {
        class Controls;
        class Title;
        class Value;
        class Edit;
        class SliderDistance;

        class SliderBuildingsOccupationResumeDistance: SliderDistance {
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    sliderRange[] = {5, 50};
                    lineSize = 1;
                    sliderStep = 5;
                };
                class Edit: Edit {};
            };
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Combo;
            class Checkbox;
        };

        class ModuleDescription {
            class Anything;
        };
    };

    class CORP_Module_BuildingsOccupation: Module_F {
        scope = 2;
        displayName = $STR_CORP_BUILDINGS_OCCUPATION_DN;
        icon = "\corp_edition_buildings_occupation\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_buildingsOccupation_init";
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 0;
        is3DEN = 0;

        canSetArea = 1;
        class AttributeValues {
            size3[]={50, 50, -1};
        };

        class Attributes: AttributesBase {
            class NumberOfUnits: Edit {
                property = "CORP_Module_BuildingsOccupation_NumberOfUnits";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_NUMBER_OF_UNITS_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_NUMBER_OF_UNITS_DESC;
                typeName = "NUMBER";
                defaultValue = "10";
            };

            class KeepPosition: Edit {
                property = "CORP_Module_BuildingsOccupation_KeepPosition";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_KEEP_POSITION_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_KEEP_POSITION_DESC;
                typeName = "NUMBER";
                defaultValue = "0.5";
                control = "Slider";
            };

            class ResumeDistance: Edit {
                property = "CORP_Module_BuildingsOccupation_ResumeDistance";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_RESUME_DISTANCE_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_RESUME_DISTANCE_DESC;
                typeName = "NUMBER";
                defaultValue = "25";
                control = "SliderBuildingsOccupationResumeDistance";
            };

            class DynamicSimulation: Checkbox {
                property = "CORP_Module_BuildingsOccupation_DynamicSimulation";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_DYNAMIC_SIMULATION_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_DYNAMIC_SIMULATION_DESC;
                typeName = "BOOL";
                defaultValue = "true";
            };

            class DebugUnits: Checkbox {
                property = "CORP_Module_BuildingsOccupation_DebugUnits";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_UNITS_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_UNITS_DESC;
                typeName = "BOOL";
                defaultValue = "false";
            };

            class DebugBuildings: Checkbox {
                property = "CORP_Module_BuildingsOccupation_DebugBuildings";
                displayName = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_BUILDINGS_DN;
                description = $STR_CORP_BUILDINGS_OCCUPATION_DEBUG_BUILDINGS_DESC;
                typeName = "BOOL";
                defaultValue = "false";
            };
        };
    };
};

class CfgCORP {
    class BuildingsOccupation {
        class Buildings {
            // bâtiments Arma 3 vanilla, Stratis, Altis
            #include "includes\vanilla.hpp"

            // bâtiments de Tanoa
            #include "includes\tanoa.hpp"

            // bâtiments de Tanoa
            #include "includes\malden.hpp"

            // bâtiments Tchernarus
            #include "includes\european.hpp"

            // bâtiments Takistan
            #include "includes\middleEastern.hpp"

            // bâtiments Sahrani
            #include "includes\sahrani.hpp"
        };
    };
};
