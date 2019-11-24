/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr

    NAME : CORP_fnc_areaPatrols_createAreaPatrol
    AUTHOR : zgmrvn
    DESCRIPTION : Creates a randomly patrolling group in the given area.
    RETURN : Group.

    EXAMPLE :
        _patrol = [
            [1230, 2032, 0],                   // center
            [0, 0, 0, false, -1],              // area
            east,                              // side of the created group
            ["O_G_Soldier_F", "O_G_medic_F"],  // units' classnames
            [[1234, 2050, 0], [2435, 1266, 0]] // waypoints' positions
        ] call CORP_fnc_areaPatrols_createAreaPatrol;
*/

#define WAYPOINT_COMPLETION_RADIUS 4

private _center    = param [0, [0, 0, 0], [[]], 3];
private _area      = param [1, [0, 0, 0, false, -1], [[]], 5];
private _side      = param [2, east, [sideUnknown]];
private _units     = param [3];
private _waypoints = param [4, 4, [0]];

// We get random positions for our future waypoints.
private _waypointsPositions = [];

for [{private _i = 0}, {_i < _waypoints}, {_i = _i + 1}] do {
    private _pos = [_center, _area] call CORP_fnc_getRandomPosInArea;
    _waypointsPositions pushBack _pos;
};

// We create the group.
private _group = [
    _waypointsPositions select 0,
    _side,
    _units
] call BIS_fnc_spawnGroup;

_group deleteGroupWhenEmpty true;
deleteWaypoint [_group, 0];

// Then we set waypoints.
private _formations = ["STAG COLUMN","VEE","ECH LEFT","ECH RIGHT","COLUMN","LINE"];

_group setFormation (selectRandom _formations);
_group setCombatMode "SAFE";
_group setBehaviour "RED";
_group setSpeedMode "LIMITED";

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
