/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

private _logic    = param [0, objNull, [objNull]];
private _units    = param [1, [], [[]]];
private _triggers = _logic call BIS_fnc_moduleTriggers;

if (count _units == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_HUNTERS_DN", _logic, localize "STR_CORP_CORE_NO_UNIT_SYNCHED"]] call BIS_fnc_error;};
if (count _triggers == 0) exitWith {[format ["%1 %2 : %3", localize "STR_CORP_HUNTERS_DN", _logic, localize "STR_CORP_CORE_NO_TRIGGER_SYNCHED"]] call BIS_fnc_error;};

private _huntingUnits    = _logic getVariable ["HuntingUnits", 4];
private _respawnDistance = _logic getVariable ["RespawnDistance", 300];
private _condition       = _logic getVariable ["Condition", "true"];
private _debug           = _logic getVariable ["Debug", false];

private _trigger = _triggers select 0;
private _units   = _units call CORP_fnc_getGroupedUnits;
private _side    = side (_units select 0);

// Holds every parameters of every hunts.
if (isNil {CORP_var_hunters_hunts}) then {
    CORP_var_hunters_hunts = [];
};

// Debug, draws units and their waypoints on map.
if (_debug && {hasInterface}) then {
    if (isNil {CORP_var_hunters_hunters}) then {
        CORP_var_hunters_hunters = grpNull;

        ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
            private _map		= _this select 0;
            private _sideColor	= [side CORP_var_hunters_hunters, "ARRAY"] call CORP_fnc_getSideColor;

            // Draw units icons.
            {
                _map drawIcon [
                    getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon"),
                    _sideColor,
                    visiblePosition _x,
                    0.5 / ctrlMapScale _map,
                    0.5 / ctrlMapScale _map,
                    getDirVisual _x
                ];
            } forEach (units CORP_var_hunters_hunters);

            // Draw waypoints.
            private _waypoints = waypoints CORP_var_hunters_hunters;

            if (count _waypoints > 0) then {
                _map drawLine [waypointPosition (_waypoints select 0), getPosASLVisual (leader CORP_var_hunters_hunters), _sideColor];
            };
        }];
    };
};

// Store the state of this hunt.
[CORP_var_hunters_hunts, str _logic, [_huntingUnits, _respawnDistance, _condition, _units]] call BIS_fnc_setToPairs;

// Create an empty group.
private _group = createGroup _side;

// Create the hunt.
[_group, _logic, getPosASL _trigger] call CORP_fnc_hunters_checkAndCreateHunters;
