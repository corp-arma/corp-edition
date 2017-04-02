if !("Module_F" in ([configFile >> "CfgVehicles" >> typeof _this, true] call BIS_fnc_returnParents)) exitWith {["Module expected"] call BIS_fnc_error;};

private _triggers = [];

{
	if ((typeOf _x) in ["EmptyDetector", "EmptyDetectorAreaR50", "EmptyDetectorAreaR250", "EmptyDetectorArea10x10"]) then {
		_triggers pushBack _x;
	};
} forEach (synchronizedObjects _this);

_triggers
