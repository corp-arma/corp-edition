class CfgPatches {
    class CORP_Edition_Core {
        units[] = {};
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {
            "A3_3DEN",
            "A3_Structures_F_Mil_Flags"
        };
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class Players {
            file = "\corp_edition\corp_edition_core\functions\players";
            class AlivePlayersRadius {};
            class FindPlayerFreePosition {};
        };

        class Geometry {
            file = "\corp_edition\corp_edition_core\functions\geometry";
            class Centroid {};
            class GetRandomPosInArea {};
        };

        class Misc {
            file = "\corp_edition\corp_edition_core\functions\misc";
            class GetSideColor {};
            class GetGroupedUnits {};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;

    class CORP_Modules: NO_CATEGORY {
        displayName = "CORP Modules";
    };
};

class Cfg3DEN {
    class Attributes {
        class Controls;
        class Title;
        class Value;
        class Edit;
        class SliderDistance;

        class SliderAddactionDistance: SliderDistance {
            class Controls: Controls {
                class Title: Title {};

                class Value: Value {
                    sliderRange[] = { 1, 15 };
                    lineSize = 1;
                    sliderStep = 1;
                };

                class Edit: Edit {};
            };
        };
    };
};

class CfgVehicles {
    class FlagCarrier_Asym;

    class Flag_CORP_F: FlagCarrier_Asym {
        author = $STR_CORP_CORE_AUTHOR;

        class SimpleObject {
            eden = 0;
            animate[] = { { "flag", 0 } };
            hide[] = {};
            verticalOffset = 3.977;
            verticalOffsetWorld = 0;
            init = "''";
        };

        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Flag_ARMEX_F.jpg";
        _generalMacro = "Flag_CORP_F";
        scope = 2;
        scopeCurator = 2;
        displayName = $STR_CORP_CORE_FLAG;

        class EventHandlers {
            init = "(_this select 0) setFlagTexture '\corp_edition\corp_edition_core\data\images\corp_flag_co.paa'";
        };
    };
};

class CfgCORP {};

#include "ui\base.hpp"
