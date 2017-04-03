#define EVENT_HANDLER_ID_KEY "CORP_hunters_killedEventHandlerId"
#define HUNTERS_LOGIC_KEY "CORP_hunters_huntersLogic"

private _group	= param [0, grpNull, [grpNull]];
private _logic	= param [1, objNull, [objNull]];
private _center	= param [2, [0, 0, 0], [[]], 3];

// si plus d'unités vivantes dans le groupe
if (({alive _x} count (units _group)) == 0) then {
	private _condition	= ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 2;

	// si la condition de chasse est toujours vraie
	if (call compile _condition) then {
		private _side				= side _group;
		private _huntingUnits		= ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 0;
		private _respawnDistance	= ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 1;
		private _parentUnits		= ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 3;

		// on cherche une position dégagée
		private _freePos = [_center, _respawnDistance] call CORP_fnc_findPlayerFreePosition;

		// on prépare le tableau du groupe
		_array = [_parentUnits] call CBA_fnc_shuffle;

		while {count _array < _huntingUnits} do {
			_array set [count _array, selectRandom _array];
		};

		_array resize _huntingUnits;

		//  et on créé un nouveau groupe
		_group = [_freePos, _side, [_array, {typeOf _x}] call CBA_fnc_filter] call BIS_fnc_spawnGroup;

		// debug
		if !(isNil {CORP_var_hunters_hunters}) then {
			CORP_var_hunters_hunters = _group;
		};

		{
			// copie de l'équipement des unités parentes
			_x setUnitLoadout [getUnitLoadout (selectRandom _parentUnits), true];

			// event handler pour chaque unité du groupe quand tuée
			private _id = _x addEventHandler ["Killed", {
				private _unit	= _this select 0;
				private _logic	= _unit getVariable [HUNTERS_LOGIC_KEY, objNull];
				private _group	= group _unit;

				// on exécute cette fonction qui va vérifier s'il n'y a plus d'unités vivantes dans le groupe
				// et le cas échéant, en créer un nouveau
				[_group, _logic, getPosASL _unit] call CORP_fnc_hunters_checkAndCreateHunters;

				// on supprime l'event handler
				_unit removeEventHandler ["Killed", (_unit getVariable EVENT_HANDLER_ID_KEY)];

				// on détruit les variable de l'unité
				_unit setVariable [EVENT_HANDLER_ID_KEY, nil];
				_unit setVariable [HUNTERS_LOGIC_KEY, nil];

				// l'unité tuée quitte le groupe
				// de cette manière, les unités mortes ne seront pas prises en compte dans le calcul de l'isobarycentre
				[_unit] join grpNull;
			}];

			// on conserve l'id de l'event handler pour pouvoir le supprimer dans l'event handler
			_x setVariable [EVENT_HANDLER_ID_KEY, _id];
			_x setVariable [HUNTERS_LOGIC_KEY, _logic];
		} forEach (units _group);

		// comportement et points de passage du groupe
		[_group, _logic] call CORP_fnc_hunters_huntersBehaviour;
	};
};
