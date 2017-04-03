private _logic	= param [0, objNull, [objNull]];
private _units	= param [1, [], [[]]];
private _areas	= _logic call CORP_fnc_getSynchronizedAreas;

if (count _units == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_BUILDINGS_OCCUPATION_DN", _logic, localize "STR_CORP_CORE_NO_UNIT_SYNCHED"]] call BIS_fnc_error;};
if (count _areas == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_BUILDINGS_OCCUPATION_DN", _logic, localize "STR_CORP_CORE_NO_AREA_SYNCHED"]] call BIS_fnc_error;};

// préparation du reste des données de la fonction
private _unitsFinal			= [];
private _side				= side (_units select 0);
private _unitsPerArea		= _logic getVariable ["UnitsPerArea", 10];
private _keepPosition		= _logic getVariable ["KeepPosition", 0.5];
private _dynamicSimulation	= _logic getVariable ["DynamicSimulation", true];
private _debug				= _logic getVariable ["Debug", false];

// on définit la couleur des zones en fonction du side des IA synchronisées
private _areasColor = [_side, "STRING"] call CORP_fnc_getSideColor;

// si le débug est demandé et que la machine a une interface
if (_debug && {hasInterface}) then {
	// on créé l'event handler responsable de dessiner les unités sur carte
	// cet event handler se base sur une variable globale qui sera chargé par chaque modules
	// seul le premier module a être activé exécutera ce code
	if (isNil {CORP_var_buildingsOccupation_occupations}) then {
		CORP_var_buildingsOccupation_occupations = [];

		// on déssine les unités sur carte
		((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
			private _map = _this select 0;

			// pour chaque zone
			{
				private _area = _x;

				// on définit la couleur de l'icône de l'unité
				private _sideColor = [side (_area select 0), "ARRAY"] call CORP_fnc_getSideColor;

				// pour chaque unité de la zone on dessine une icône
				{
					_map drawIcon [
						getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon"),
						_sideColor,
						visiblePosition _x,
						0.5 / ctrlMapScale _map,
						0.5 / ctrlMapScale _map,
						getDirVisual _x
					];
				} forEach _area;
			} forEach CORP_var_buildingsOccupation_occupations;

		}];
	};

	// on dessine les zones sur carte
	{
		private _area = _x getvariable ["objectArea", [0, 0, 0, false, 0]];

		private _marker = createMarker [format ["area_%1", _x], _x];
		_marker setMarkerShape (["ELLIPSE", "RECTANGLE"] select (_area select 3));
		_marker setMarkerSize [_area select 0, _area select 1];
		_marker setMarkerDir (_area select 2);
		_marker setMarkerBrush "Border";
		_marker setMarkerColor _areasColor;
	} forEach _areas;
};

// on récupères les unités synchronisées au module
// et on génère un tableau consolidé de toutes les classnames
{
	private _unit = _x;

	{
		_typeOf = typeOf _x;
		if !(_typeOf in _unitsFinal) then {
			_unitsFinal pushBack _typeOf;
		};
	} forEach (units _unit);
} forEach _units;

// pour chaque zone on créé l'occupation
{
	private _center	= getPosASL _x;
	private _area	= _x getvariable ["objectArea", [0, 0, 0, false, 0]];
	private _radius = (_area select 0) max (_area select 1);

	private _occupation = [_center, _radius, _unitsPerArea, _side, _unitsFinal, _keepPosition] call CORP_fnc_buildingsOccupation_occupation;

	if (_debug) then {
		CORP_var_buildingsOccupation_occupations pushBack _occupation;
	};

	// activation/désactivation de la simulation dynamique pour les unités créées
	{
		_x enableDynamicSimulation _dynamicSimulation;
	} forEach _occupation;
} forEach _areas;

// todo : supprimer tous les triggers synchronisés

// on supprime manuellement le module
// on ne le fait pas via la propriété "disposable" de la config
// parce que le module est supprimé avant que l'on ait récupéré les déclencheurs synchronisés
deleteVehicle _logic;
