#define SEARCH_DISTANCE 1000
#define WAYPOINT_COMPLETION 20

private _group = param [0, grpNull, [grpNull]];
private _logic = param [1, objNull, [objNull]];

// on récupère les joueur à proximité du groupe de chasse
private _huntersCentroid	= [units _group, {getPosASL _x}] call CBA_fnc_filter;
private _players			= [_huntersCentroid call CORP_fnc_centroid, SEARCH_DISTANCE, [west]] call CORP_fnc_alivePlayersRadius;

// s'il reste des joueurs à portée du groupe de chasse
if ((count _players) > 0) then {
	// suppression des waypoints du groupe
	while {(count (waypoints _group)) > 0} do {
		deleteWaypoint ((waypoints _group) select 0);
	};

	// calcul de l'isobarycente des joueur trouvés
	_players = [_players, {getPosASL _x}] call CBA_fnc_filter;
	private _playersCentroid = _players call CORP_fnc_centroid;

	//systemChat str _playersCentroid;
	//systemChat str (getpos player);

	// ajout du waypoint qui une fois completé appelle de nouveau cette fonction
	// pour qu'un waypoint soit validé, il ne suffit pas que l'IA soit dans le rayon de complétion
	// il n'y a donc pas de risque de répétition infinie lorsque la distance entre le groupe et le barycentre des joueurs
	// est plus faible que le rayon de complétion du waypoint
	private _wp = _group addWaypoint [_playersCentroid, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius WAYPOINT_COMPLETION;
	_wp setWaypointStatements ["true", "(group this) call CORP_fnc_hunters_huntersBehaviour;"];

// s'il n'y a plus de joueurs à portée du groupe de chasse
// on définie la condition à "false" afin de killer la création d'un nouveau groupe
} else {
	([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) set [0, "false"];
};
