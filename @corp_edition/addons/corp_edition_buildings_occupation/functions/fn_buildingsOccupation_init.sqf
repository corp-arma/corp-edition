private _logic	= param [0, objNull, [objNull]];
private _units	= param [1, [], [[]]];

if (count _units == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_BUILDINGS_OCCUPATION_DN", _logic, localize "STR_CORP_CORE_NO_UNIT_SYNCHED"]] call BIS_fnc_error;};

private _area				= _logic getvariable ["objectArea", [0, 0, 0, false, 0]];
private _numberOfUnits		= _logic getVariable ["NumberOfUnits", 10];
private _keepPosition		= _logic getVariable ["KeepPosition", 0.5];
private _resumeDistance		= _logic getVariable ["ResumeDistance", 25];
private _dynamicSimulation	= _logic getVariable ["DynamicSimulation", true];
private _debugUnits			= _logic getVariable ["DebugUnits", false];
private _debugBuildings		= _logic getVariable ["DebugBuildings", false];

private _units	= _units call CORP_fnc_getGroupedUnits;
private _side	= side (_units select 0);

// si la machine a une interface
if (hasInterface) then {
	// si le débug d'unités est demandé et
	if (_debugUnits) then {
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

	// si le débug de bâtiments est demandé
	if (_debugBuildings) then {
		private _buildings = nearestObjects [getPosASL _logic, ["Building"], (_area select 0) max (_area select 1), true];

		{
			private _color = ["ColorRed", "ColorGreen"] select (isClass (configFile >> "CfgCORP" >> "BuildingsOccupation" >> "Buildings" >> typeOf _x));

			private _bbr = boundingBoxReal _x;
			private _p1 = _bbr select 0;
			private _p2 = _bbr select 1;
			private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
			private _maxLength = abs ((_p2 select 1) - (_p1 select 1));

			private _marker = createMarkerLocal [format ["BuildingsOccupation_building%1", _forEachIndex], getposASL _x];
			_marker setMarkerShapeLocal "RECTANGLE";
			_marker setMarkerDirLocal (getDir _x);
			_marker setMarkerSizeLocal [_maxWidth * 0.5, _maxLength * 0.5];
			_marker setMarkerColorLocal _color;
		} forEach _buildings;
	};
};

// création de l'occupation
private _occupation = [getPosASL _logic, (_area select 0) max (_area select 1), _numberOfUnits, _side, [_units, {typeOf _x}] call CBA_fnc_filter, _keepPosition] call CORP_fnc_buildingsOccupation_occupation;

// stockage des unitiés créées dans la logique
_logic setVariable ["createdUnits", _occupation];

// si débug demandé, on pousses les unités créées dans le tableau des unités à débuger
if !(isNil {CORP_var_buildingsOccupation_occupations}) then {
	CORP_var_buildingsOccupation_occupations pushBack _occupation;
};

// traitement sur les unités créées
{
	// activation/désactivation de la simulation dynamique pour les unités créées
	(group _x) enableDynamicSimulation _dynamicSimulation;

	// copie de l'équipement d'une des unités synchronisée
	_x setUnitLoadout [getUnitLoadout (selectRandom _units), true];
} forEach _occupation;
