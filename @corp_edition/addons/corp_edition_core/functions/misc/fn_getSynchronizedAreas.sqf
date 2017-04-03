if !("Module_F" in ([configFile >> "CfgVehicles" >> typeof _this, true] call BIS_fnc_returnParents)) exitWith {["Module expected"] call BIS_fnc_error;};

private _areas = [];

{
	if ((typeOf _x) in ["CORP_Module_AreaEllipse", "CORP_Module_AreaRectangle", "CORP_Module_AreaPosition"]) then {
		_areas pushBack _x;
	};
} forEach (synchronizedObjects _this);

_areas
