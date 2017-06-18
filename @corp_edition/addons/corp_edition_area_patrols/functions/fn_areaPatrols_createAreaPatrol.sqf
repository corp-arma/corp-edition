/*
	Outils d'édition du CORP
	http://www.corp-arma.fr
*/

#define WAYPOINT_COMPLETION_RADIUS 4

private _center		= param [0, [0, 0, 0], [[]], 3];
private _area		= param [1, [0, 0, 0, false, -1], [[]], 5];
private _side		= param [2, east, [sideUnknown]];
private _units		= param [3];
private _waypoints	= param [4, 4, [0]];

// on détermine la position des points de passage
private _waypointsPositions = [];

for [{private _i = 0}, {_i < _waypoints}, {_i = _i + 1}] do {
	private _pos = [_center, _area] call CORP_fnc_getRandomPosInArea;
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
_group deleteGroupWhenEmpty true;

{
	_wp = _group addWaypoint [_waypointsPositions select _forEachIndex, 0];
	_wp setWaypointCompletionRadius WAYPOINT_COMPLETION_RADIUS;
	_wp setWaypointFormation (selectRandom _formations);
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointType "MOVE";

	if (_forEachIndex == ((count _waypointsPositions) - 1)) then {
		_wp = _group addWaypoint [_waypointsPositions select _forEachIndex, 0];
		_wp setWaypointCompletionRadius WAYPOINT_COMPLETION_RADIUS;
		_wp setWaypointFormation (selectRandom _formations);
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointType "CYCLE";
	};
} forEach _waypointsPositions;

_group
