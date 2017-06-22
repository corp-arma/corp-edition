private _logic	= param [0, objNull, [objNull]];
private _units	= param [1, [], [[]]];

if (count _units == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_AREA_PATROLS_DN", _logic, localize "STR_CORP_CORE_NO_UNIT_SYNCHED"]] call BIS_fnc_error;};

private _area				= _logic getvariable ["objectArea", [0, 0, 0, false, 0]];
private _numberOfGroups		= _logic getVariable ["NumberOfGroups", 4];
private _unitsPerGroup		= _logic getVariable ["UnitsPerGroup", 4];
private _waypointsPerGroup	= _logic getVariable ["WaypointsPerGroup", 4];
private _dynamicSimulation	= _logic getVariable ["DynamicSimulation", true];
private _debug				= _logic getVariable ["Debug", false];

private _units	= _units call CORP_fnc_getGroupedUnits;
private _side	= side (_units select 0);

// si le débug est demandé et que la machine a une interface
if (_debug && {hasInterface}) then {
	// on créé l'event handler responsable de dessiner les unités et les waypoints sur carte
	// cet event handler se base sur une variable globale qui sera chargé par chaque modules
	// seul le premier module a être activé exécutera ce code
	if (isNil {CORP_var_areaPatrols_patrols}) then {

		CORP_var_areaPatrols_patrols = [];

		// on déssine les zones et les unités sur carte
		((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
			private _map = _this select 0;

			// pour chaque groupe créé par un module Area Patrols et dont le paramètre "débug" est coché
			{
				private _group		= _x;
				private _sideColor	= [side _group, "ARRAY"] call CORP_fnc_getSideColor;

				// on dessine chaque unité du groupe
				{
					_map drawIcon [
						getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon"),
						_sideColor,
						visiblePosition _x,
						0.5 / ctrlMapScale _map,
						0.5 / ctrlMapScale _map,
						getDirVisual _x
					];
				} forEach (units _group);

				private _waypointsCount = count (waypoints _group);

				// on dessine les waypoints du groupe
				for [{private _i = (_waypointsCount - 1)}, {_i > 0}, {_i = _i - 1}] do {
					_map drawLine [waypointPosition [_group, _i], waypointPosition [_group, _i - 1], _sideColor];
				};
				_map drawLine [waypointPosition [_group, 0], waypointPosition [_group, _waypointsCount - 1], _sideColor];
			} forEach CORP_var_areaPatrols_patrols;
		}];
	};

	// on dessine la zone
	private _marker = createMarker [format ["area_%1", _logic], _logic];
	_marker setMarkerShape "RECTANGLE";
	_marker setMarkerSize [_area select 0, _area select 1];
	_marker setMarkerDir (_area select 2);
	_marker setMarkerBrush "Border";
	_marker setMarkerColor ([_side, "STRING"] call CORP_fnc_getSideColor);
};

private _patrols = [];

// on créé les patrouilles
for "_i" from 0 to (_numberOfGroups - 1) do {
	private _unitsResized = [];
	private _random = ceil (random (_unitsPerGroup - 1));

	for "_ii" from 0 to _random do {
		_unitsResized pushBack (selectRandom _units);
	};

	private _group = [getPosASL _logic, _area, _side, [_unitsResized, {typeOf _x}] call CBA_fnc_filter, _waypointsPerGroup] call CORP_fnc_areaPatrols_createAreaPatrol;
	_patrols pushBack _group;

	// debug
	if !(isNil {CORP_var_areaPatrols_patrols}) then {
		CORP_var_areaPatrols_patrols pushBack _group;
	};

	// activation/désactivation de la simulation dynamique pour le groupe créé
	_group enableDynamicSimulation _dynamicSimulation;

	// copie de l'équipement d'une des unités synchronisée
	{
		_x setUnitLoadout [getUnitLoadout (selectRandom _units), true];
	} forEach (units _group);
};

// stockage des groupes créés dans le module
_logic setVariable ["createdGroups", _patrols];
