/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

#define SEARCH_DISTANCE 1000
#define WAYPOINT_COMPLETION 20

private _group = param [0, grpNull, [grpNull]];
private _logic = param [1, objNull, [objNull]];

// We check for player near the hunting group.
private _huntersCentroid = [units _group, {getPosASL _x}] call CBA_fnc_filter;
private _players         = [_huntersCentroid call CORP_fnc_centroid, SEARCH_DISTANCE, [west]] call CORP_fnc_alivePlayersRadius;

// If there are players near the hunting group.
if ((count _players) > 0) then {
    // We remove waypoints.
    while {(count (waypoints _group)) > 0} do {
        deleteWaypoint ((waypoints _group) select 0);
    };

    // Compute isobarycenter of found players.
    _players = [_players, {getPosASL _x}] call CBA_fnc_filter;
    private _playersCentroid = _players call CORP_fnc_centroid;

    // We add the new waypoint which once completed will call this function again.
    private _wp = _group addWaypoint [_playersCentroid, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius WAYPOINT_COMPLETION;
    _wp setWaypointStatements ["true", "(group this) call CORP_fnc_hunters_huntersBehaviour;"];

// If there is no more players near the hunting group
// we set the hunting condition to "false" to stop the creation of hunting groups.
} else {
    ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) set [0, "false"];
};
