class CfgPatches {
	class CORP_Edition_Lightpoint {
		units[] = {"CORP_Module_Lightpoint"};
		author = "CORP Modding Studio";
		requiredVersion = 1.66;
		requiredAddons[] = {"A3_Modules_F", "A3_3DEN", "corp_edition_core"};
	};
};

class CfgFunctions {
	class CORP {
		tag = "CORP";

		class CORPEditionLightpoint {
			file = "\corp_edition_lightpoint\functions";
			class Lightpoint_Init {};
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
		class SliderMultiplier;

		class SliderLightpointColor: SliderDistance {
			onLoad="comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!'; _ctrlGroup = _this select 0; [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;";
			attributeLoad="comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!'; _ctrlGroup = _this; [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;";

			class Controls: Controls {
				class Title: Title {};
				class Value: Value {
					sliderRange[] = {0, 255};
					lineSize = 50;
					sliderStep = 1;
				};
				class Edit: Edit {};
			};
		};

		class SliderLightpointBrightness: SliderMultiplier {
			class Controls: Controls {
				class Title: Title {};
				class Value: Value {
					sliderRange[] = {0.1, 10};
					sliderPosition = 2;
					lineSize = 0.1;
					sliderStep = 0.1;
				};
				class Edit: Edit {};
			};
		};

		class SliderLightpointFlareSize: SliderMultiplier {
			class Controls: Controls {
				class Title: Title {};
				class Value: Value {
					sliderRange[] = {0.1, 10};
					sliderPosition = 2;
					lineSize = 0.1;
					sliderStep = 0.1;
				};
				class Edit: Edit {};
			};
		};

		class SliderLightpointFlareDistance: SliderDistance {
			class Controls: Controls {
				class Title: Title {};
				class Value: Value {
					sliderRange[] = {25, 2500};
					lineSize = 25;
					sliderStep = 25;
				};
				class Edit: Edit {};
			};
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class AgumentsBase {

		};
		class AttributesBase {
			class Edit;
			class Checkbox;
		};

		class ModuleDescription {
			class Anything;
		};
	};

	class CORP_Module_Lightpoint: Module_F {
		scope = 2;
		displayName = $STR_CORP_LIGHTPOINT_DN;
		icon = "\corp_edition_lightpoint\icon.paa";
		category = "CORP_Modules";

		function = "CORP_fnc_lightpoint_init";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 1;
		isDisposable = 0;
		is3DEN = 1;

		class Attributes: AttributesBase {
			class Red: Edit {
				property = "CORP_Module_Lightpoint_Red";
				displayName = $STR_CORP_LIGHTPOINT_RED_DN;
				description = $STR_CORP_LIGHTPOINT_RED_DESC;
				typeName = "NUMBER";
				defaultValue = "255";
				control = "SliderLightpointColor";
			};
			class Green: Edit {
				property = "CORP_Module_Lightpoint_Green";
				displayName = $STR_CORP_LIGHTPOINT_GREEN_DN;
				description = $STR_CORP_LIGHTPOINT_GREEN_DESC;
				typeName = "NUMBER";
				defaultValue = "255";
				control = "SliderLightpointColor";
			};
			class Blue: Edit {
				property = "CORP_Module_Lightpoint_Blue";
				displayName = $STR_CORP_LIGHTPOINT_BLUE_DN;
				description = $STR_CORP_LIGHTPOINT_BLUE_DESC;
				typeName = "NUMBER";
				defaultValue = "255";
				control = "SliderLightpointColor";
			};
			class Brightness: Edit {
				property = "CORP_Module_Lightpoint_Brightness";
				displayName = $STR_CORP_LIGHTPOINT_BRIGHTNESS_DN;
				description = $STR_CORP_LIGHTPOINT_BRIGHTNESS_DESC;
				typeName = "NUMBER";
				defaultValue = "1";
				control = "SliderLightpointBrightness";
			};
			class UseFlare: Checkbox {
				property = "CORP_Module_Lightpoint_UseFlare";
				displayName = $STR_CORP_LIGHTPOINT_USE_FLARE_DN;
				description = $STR_CORP_LIGHTPOINT_USE_FLARE_DESC;
				typeName = "BOOL";
				defaultValue = "false";
			};
			class FlareSize: Edit {
				property = "CORP_Module_Lightpoint_FlareSize";
				displayName = $STR_CORP_LIGHTPOINT_FLARE_SIZE_DN;
				description = $STR_CORP_LIGHTPOINT_FLARE_SIZE_DESC;
				typeName = "NUMBER";
				defaultValue = "1";
				control = "SliderLightpointBrightness";
			};
			class FlareMaxDistance: Edit {
				property = "CORP_Module_Lightpoint_FlareMaxDistance";
				displayName = $STR_CORP_LIGHTPOINT_FLARE_MAX_DISTANCE_DN;
				description = $STR_CORP_LIGHTPOINT_FLARE_MAX_DISTANCE_DESC;
				typeName = "NUMBER";
				defaultValue = "250";
				control = "SliderLightpointFlareDistance";
			};
		};
	};
};
