/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

#include "..\ui\ctrls.hpp"

// Module's global variables declaration.

// CORP_var_boatProjection_object
// Declared in the addAction code to have access to the object the action is attached to then get the players around.

// CORP_var_boatProjection_logic
// Declared in the addAction code to have access to the module and its disance parameter.

CORP_var_boatProjection_players     = [];
CORP_var_boatProjection_coordinates = [];
CORP_var_boatProjection_marker      = "";

waitUntil {!isNull (findDisplay BOAT_PROJECTION_DIALOG_IDD)};

disableSerialization;

private _dialog     = findDisplay BOAT_PROJECTION_DIALOG_IDD;
private _boatList   = _dialog displayCtrl BOAT_PROJECTION_BOATLIST_IDC;
private _map        = _dialog displayCtrl BOAT_PROJECTION_MAP_IDC;
private _close      = _dialog displayCtrl BOAT_PROJECTION_CLOSE_IDC;
private _projection = _dialog displayCtrl BOAT_PROJECTION_PROJECTION_IDC;

// Feeding/updating the list.
[] spawn {
    disableSerialization;

    private _dialog = findDisplay BOAT_PROJECTION_DIALOG_IDD;
    private _list   = _dialog displayCtrl BOAT_PROJECTION_LIST_IDC;

    while {!isNull (findDisplay BOAT_PROJECTION_DIALOG_IDD)} do {
        // Get the players at proximity.
        CORP_var_boatProjection_players = [CORP_var_boatProjection_object, 25] call CORP_fnc_alivePlayersRadius;

        // Empty the list.
        lbClear _list;

        // Then fill it again.
        {
            lbAdd [BOAT_PROJECTION_LIST_IDC, name _x];
            lbSetData [BOAT_PROJECTION_LIST_IDC, _forEachIndex, name _x];
        } forEach CORP_var_boatProjection_players;

        sleep 0.5;
    };
};

// Feed available boat types list.
{
    lbAdd [BOAT_PROJECTION_BOATLIST_IDC, getText (configFile >> "CfgVehicles" >> (_x select 0) >> "displayName")];
} forEach (getArray (configFile >> "CfgCORP" >> "BoatProjection" >> "boats"));

_boatList lbSetCurSel 0;

// Handle projection marker positionning.
_map ctrlAddEventHandler ["mouseButtonDblClick", {
    // If a marker already exist, delete it.
    if (CORP_var_boatProjection_marker != "") then {
        deleteMarkerLocal CORP_var_boatProjection_marker;
    };

    private _center = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
    _center set [2, 0];

    private _farEnoughtCost = true;

    // Check for the nearest coast to be far enougth.
    for [{private _i = 0; private _d = CORP_var_boatProjection_logic getVariable "CoastDistance";}, {_i < _d}, {_i = _i + 2}] do {
        private _pos = [_center, _i,  (22.5 * _i) mod 360] call BIS_fnc_relPos;

        if (((ATLToASL _pos) select 2) > 0) exitWith {
            _farEnoughtCost = false;
        };
    };

    // If the coast is far enougth, create the marker.
    if (_farEnoughtCost) then {
        CORP_var_boatProjection_coordinates = _center;
        CORP_var_boatProjection_marker = createMarkerLocal ["Marker1", CORP_var_boatProjection_coordinates];
        CORP_var_boatProjection_marker setMarkerShapeLocal "ICON";
        CORP_var_boatProjection_marker setMarkerTypeLocal "respawn_para";
    };
}];

// Cancel projection.
_close ctrlAddEventHandler ["MouseButtonDown", {
    closeDialog BOAT_PROJECTION_DIALOG_IDD;
}];

// Handle projection.
_projection ctrlAddEventHandler ["MouseButtonDown", {
    if (CORP_var_boatProjection_marker != "") then {
        // We ask the server to create the boast then embarque players.
        [
            CORP_var_boatProjection_coordinates,
            CORP_var_boatProjection_players,
            lbCurSel BOAT_PROJECTION_BOATLIST_IDC
        ] remoteExec ["CORP_fnc_BoatProjection_server", 2];

        closeDialog BOAT_PROJECTION_DIALOG_IDD;
    };
}];
