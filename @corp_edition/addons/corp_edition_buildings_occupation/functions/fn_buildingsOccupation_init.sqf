private _logic	= param [0, objNull, [objNull]];
private _units	= param [1, [], [[]]];

if (count _units == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_BUILDINGS_OCCUPATION_DN", _logic, localize "STR_CORP_CORE_NO_UNIT_SYNCHED"]] call BIS_fnc_error;};

private _area				= _logic getvariable ["objectArea", [0, 0, 0, false, 0]];
private _numberOfUnits		= _logic getVariable ["NumberOfUnits", 10];
private _keepPosition		= _logic getVariable ["KeepPosition", 50];
private _dynamicSimulation	= _logic getVariable ["DynamicSimulation", true];
private _debug				= _logic getVariable ["Debug", false];

_keepPosition = _keepPosition / 100;

private _units	= _units call CORP_fnc_getGroupedUnits;
private _side	= side (_units select 0);

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
				private _areaUnits	= _x;
				// pour chaque unité en vie de la zone on dessine une icône
				{
					if (alive _x) then {
						_map drawIcon [
							getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon"),
							[side _x, "ARRAY"] call CORP_fnc_getSideColor,
							visiblePosition _x,
							0.5 / ctrlMapScale _map,
							0.5 / ctrlMapScale _map,
							getDirVisual _x
						];
					};
				} forEach _areaUnits;
			} forEach CORP_var_buildingsOccupation_occupations;
		}];
	};

	// on dessine la zone sur carte
	private _marker = createMarker [format ["area_%1", _logic], _logic];
	_marker setMarkerShape (["ELLIPSE", "RECTANGLE"] select (_area select 3));
	_marker setMarkerSize [_area select 0, _area select 1];
	_marker setMarkerDir (_area select 2);
	_marker setMarkerBrush "Border";
	_marker setMarkerColor ([_side, "STRING"] call CORP_fnc_getSideColor);
};

// création de l'occupation
private _occupation = [getPosASL _logic, (_area select 0) max (_area select 1), _numberOfUnits, _side, [_units, {typeOf _x}] call CBA_fnc_filter, _keepPosition] call CORP_fnc_buildingsOccupation_occupation;

if !(isNil {CORP_var_buildingsOccupation_occupations}) then {
	CORP_var_buildingsOccupation_occupations pushBack _occupation;
};

{
	// activation/désactivation de la simulation dynamique pour les unités créées
	_x enableDynamicSimulation _dynamicSimulation;

	// copie de l'équipement d'une des unités synchronisée
	_x setUnitLoadout [getUnitLoadout (selectRandom _units), true];
} forEach _occupation;
