/*
	framework de mission du CORP
	http://www.corp-arma.fr
*/

private _center		= param [0, [0, 0, 0], [[]], 3];
private _area		= param [1, [0, 0, 0, false, -1], [[]], 5];
private _side		= param [2, east, [sideUnknown]];
private _units		= param [3];
private _waypoints	= param [4, 4, [0]];

// fonction de séléction aléatoire d'une position dans une zone rectangulaire ou circulaire
private _fnc_findPos = {
	private _origin	= param [0, [0, 0, 0], [[]], 3];
	private _area	= param [1, [0, 0, 0, false, -1], [[]], 5];

	// si la zone est rectangulaire
	if (_area select 3) then {
		// horizontal
		_origin	= [_origin, random (_area select 0), ((_area select 2) + 90) + 180 * (round (random 1))] call BIS_fnc_relPos;

		// vertical
		_origin	= [_origin, random (_area select 1), (_area select 2) + 180 * (round (random 1))] call BIS_fnc_relPos;

	// sinon, la zone est circulaire
	} else {
		systemChat "pas codé";
	};

	_origin set [2, 0];

	_origin
};

// on détermine la position des points de passage
private _waypointsPositions = [];

for [{private _i = 0}, {_i < _waypoints}, {_i = _i + 1}] do {
	private _pos = [_center, _area] call _fnc_findPos;
	_waypointsPositions pushBack _pos;
};

// on créé le groupe
private _group = [
	_waypointsPositions select 0,
	_side,
	_units
] call BIS_fnc_spawnGroup;

// on attribue les points de passage
deleteWaypoint [_group, 0];

private _formations = ["STAG COLUMN","VEE","ECH LEFT","ECH RIGHT","COLUMN","LINE"];

_group setFormation (selectRandom _formations);
_group setCombatMode "SAFE";
_group setBehaviour "RED";
_group setSpeedMode "LIMITED";

{
	_type = ["MOVE", "CYCLE"] select (_forEachIndex == ((count _waypointsPositions) - 1));

	_wp = _group addWaypoint [_waypointsPositions select _forEachIndex, 0];
	_wp setWaypointCompletionRadius 4;
	_wp setWaypointFormation (selectRandom _formations);
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointType _type;
} forEach _waypointsPositions;

_group
