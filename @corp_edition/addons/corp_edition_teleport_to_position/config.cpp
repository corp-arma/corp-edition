class CfgPatches {
    class CORP_Edition_Teleport_To_Position {
        units[] = {"CORP_Module_TeleportToPosition"};
        author = "CORP Modding Studio";
        requiredVersion = 1.66;
        requiredAddons[] = {"A3_Modules_F", "corp_edition_core"};
    };
};

class CfgFunctions {
    class CORP {
        tag = "CORP";

        class CORPEditionTeleportToPosition {
            file = "\corp_edition_teleport_to_position\functions";
            class TeleportToPosition_Init {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
        };

        class ModuleDescription {
            class AnyStaticObject;
        };
    };

    class CORP_Module_TeleportToPosition: Module_F {
        scope = 2;
        displayName = $STR_CORP_TELEPORT_TO_POSITION_DN;
        icon = "\corp_edition_teleport_to_position\icon.paa";
        category = "CORP_Modules";

        function = "CORP_fnc_teleportToPosition_init";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;

        class Attributes: AttributesBase {
            class ActionText: Edit {
                property = "CORP_Module_TeleportToPosition_ActionText";
                displayName = $STR_CORP_TELEPORT_TO_POSITION_ACTION_TEXT_DN;
                description = $STR_CORP_TELEPORT_TO_POSITION_ACTION_TEXT_DESC;
                typeName = "STRING";
                defaultValue = """Action""";
            };

            class ActionDistance: Edit {
                property = "CORP_Module_TeleportToPosition_ActionDistance";
                displayName = $STR_CORP_TELEPORT_TO_POSITION_ACTION_DISTANCE_DN;
                description = $STR_CORP_TELEPORT_TO_POSITION_ACTION_DISTANCE_DESC;
                typeName = "NUMBER";
                defaultValue = "3";
                control = "SliderAddactionDistance";
            };

            class TeleportPosition: Edit {
                property = "CORP_Module_TeleportToPosition_TeleportPosition";
                displayName = $STR_CORP_TELEPORT_TO_POSITION_TELEPORT_POSITION_DN;
                description = $STR_CORP_TELEPORT_TO_POSITION_TELEPORT_POSITION_DESC;
                typeName = "STRING";
                defaultValue = """[0, 0, 0]""";
            };

            class TeleportDirection: Edit {
                property = "CORP_Module_TeleportToPosition_TeleportDirection";
                displayName = $STR_CORP_TELEPORT_TO_POSITION_TELEPORT_DIRECTION_DN;
                description = $STR_CORP_TELEPORT_TO_POSITION_TELEPORT_DIRECTION_DESC;
                typeName = "NUMBER";
                defaultValue = "0";
            };
        };
    };
};
