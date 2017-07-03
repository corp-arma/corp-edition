/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

private _coordinates	= _this select 0;
private _players		= _this select 1;
private _boatData		= (getArray (configFile >> "CfgCORP" >> "BoatProjection" >> "boats")) select (_this select 2);
private _boatClassname	= _boatData select 0;
private _boatPlaces		= _boatData select 1;
private _dir			= [_coordinates, [worldSize / 2, worldSize / 2, 0]] call BIS_fnc_dirTo;

private _boat = objNull;

for [{_i = 0; _c = count _players;}, {_i < _c}, {_i = _i + 1}] do {
	private _mod = _i mod _boatPlaces;

	if (_mod == 0) then {
		_boat = createVehicle [_boatClassname, [_coordinates, (_i / 5) * 10, _dir + 135] call BIS_fnc_relPos, [], 0, "CAN_COLLIDE"];
		_boat setDir _dir;
	};

	[_boat, _mod] remoteExec ["CORP_fnc_BoatProjection_client", _players select _i];
};
