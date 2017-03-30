private _logic				= param [0, objNull, [objNull]];
private _units				= param [1, [], [[]]];
private _unitsFinal			= [];
private _triggers			= synchronizedObjects _logic;
private _areas				= [];
private _side				= side (_units select 0);
private _groupsPerArea		= (_logic getVariable ["GroupsPerArea", 4]);
private _unitsPerGroup		= _logic getVariable ["UnitsPerGroup", 4];
private _waypointsPerGroup	= _logic getVariable ["WaypointsPerGroup", 4];

// todo : ajouter des sortie en cas d'erreur sur les paramètres

// pour chaque unité synchronisée au module
{
	private _unit = _x;

	// on récupères toutes les unités de son groupe
	// et on les ajoute au tableau final d'unités si elles n'y sont pas
	{
		_typeOf = typeOf _x;
		if !(_typeOf in _unitsFinal) then {
			_unitsFinal pushBack _typeOf;
		};
	} forEach (units _unit);
} forEach _units;

// pour chaque déclencheur synchronisé au module
{
	// on vérifie si la condition vaut true
	// si c'est le cas, c'est une zone définie par l'éditeur
	// on la pousse donc dans le tableau des zones
	if (((triggerStatements _x) select 0) == "true") then {
		_areas pushBack _x;
	};
} forEach _triggers;

// pour chaque zone on créé les patrouilles
{
	private _center	= getPosASL _x;
	private _area	= triggerArea _x;

	for "_i" from 0 to (_groupsPerArea - 1) do {
		private _unitsResized = [];
		private _random = ceil (random _unitsPerGroup);

		for "_ii" from 0 to _random do {
			_unitsResized pushBack (selectRandom _unitsFinal);
		};

		systemChat str _unitsResized;

		_patrol = [_center, _area, _side, _unitsResized, _waypointsPerGroup] call CORP_fnc_areaPatrols_createAreaPatrol;
	};
} forEach _areas;

// on supprime manuellement le module
// on ne le fait pas via la propriété "disposable" de la config
// parce que le module est supprimé avant que l'on ait récupéré les déclencheurs synchronisés
deleteVehicle _logic;
