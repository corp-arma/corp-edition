/*
	Outils d'édition du CORP
	http://www.corp-arma.fr
*/

class CfgPatches {
	class CORP_Edition_Global_AddAction {
		units[] = {"CORP_Module_GlobalAddaction"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "A3_3DEN", "corp_edition_core", "cba_strings"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionGlobalAddAction {
			file = "\corp_edition_global_addaction\functions";
			class GlobalAddAction_Init {};
			class GlobalAddAction_AddAction {};
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

	class CORP_Module_GlobalAddaction: Module_F {
		scope = 2;
		displayName = $STR_CORP_GLOBAL_ADDACTION_DN;
		icon = "\corp_edition_global_addaction\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_globalAddAction_init";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 0;

		class Attributes: AttributesBase {
			class ActionText: Edit {
				property = "CORP_Module_GlobalAddAction_ActionText";
				displayName = $STR_CORP_GLOBAL_ADDACTION_ACTION_TEXT_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_ACTION_TEXT_DESC;
				typeName = "STRING";
				defaultValue = """Action""";
			};

			class ServerExpression: Edit {
				property = "CORP_Module_GlobalAddAction_ServerExpression";
				displayName = $STR_CORP_GLOBAL_ADDACTION_SERVER_EXPRESSION_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_SERVER_EXPRESSION_DESC;
				typeName = "STRING";
				defaultValue = """""";
			};

			class ClientExpression: Edit {
				property = "CORP_Module_GlobalAddAction_ClientExpression";
				displayName = $STR_CORP_GLOBAL_ADDACTION_CLIENT_EXPRESSION_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_CLIENT_EXPRESSION_DESC;
				typeName = "STRING";
				defaultValue = """""";
			};

			class ActionDistance: Edit {
				property = "CORP_Module_GlobalAddAction_ActionDistance";
				displayName = $STR_CORP_GLOBAL_ADDACTION_ACTION_DISTANCE_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_ACTION_DISTANCE_DESC;
				typeName = "NUMBER";
				defaultValue = "3";
				control = "SliderAddactionDistance";
			};

			class DeleteObject: Checkbox {
				property = "CORP_Module_GlobalAddAction_DeleteObject";
				displayName = $STR_CORP_GLOBAL_ADDACTION_DELETE_OBJECT_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_DELETE_OBJECT_DESC;
				typeName = "BOOL";
				defaultValue = "false";
			};

			class RemoveAction: Checkbox {
				property = "CORP_Module_GlobalAddAction_RemoveAction";
				displayName = $STR_CORP_GLOBAL_ADDACTION_REMOVE_ACTION_DN;
				description = $STR_CORP_GLOBAL_ADDACTION_REMOVE_ACTION_DESC;
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};
};
