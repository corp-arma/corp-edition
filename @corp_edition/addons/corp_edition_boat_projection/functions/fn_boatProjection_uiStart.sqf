/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

#include "..\ui\ctrls.hpp"

// déclaration des variables du module
// CORP_var_boatProjection_object, déclarée dans le code de l'action afin de récupérer l'objet sur lequel est attachée l'action et ainsi pouvoir récupérer les joueurs à proximité
// CORP_var_boatProjection_logic, déclarée dans le code de l'action afin de récupérer la logique du module qui contient le paramètre de distance
CORP_var_boatProjection_players		= [];
CORP_var_boatProjection_coordinates	= [];
CORP_var_boatProjection_marker		= "";

waitUntil {!isNull (findDisplay BOAT_PROJECTION_DIALOG_IDD)};

disableSerialization;

private _dialog		= findDisplay BOAT_PROJECTION_DIALOG_IDD;
private _boatList	= _dialog displayCtrl BOAT_PROJECTION_BOATLIST_IDC;
private _map 		= _dialog displayCtrl BOAT_PROJECTION_MAP_IDC;
private _close 		= _dialog displayCtrl BOAT_PROJECTION_CLOSE_IDC;
private _projection	= _dialog displayCtrl BOAT_PROJECTION_PROJECTION_IDC;

// alimentation et actualisation de la liste
[] spawn {
	disableSerialization;

	private _dialog	= findDisplay BOAT_PROJECTION_DIALOG_IDD;
	private _list	= _dialog displayCtrl BOAT_PROJECTION_LIST_IDC;

	while {!isNull (findDisplay BOAT_PROJECTION_DIALOG_IDD)} do {
		// récupération des joueurs à proximité
		CORP_var_boatProjection_players = [CORP_var_boatProjection_object, 25] call CORP_fnc_alivePlayersRadius;

		// on vide la liste
		lbClear _list;

		// puis on la remplit de nouveau
		{
			lbAdd [BOAT_PROJECTION_LIST_IDC, name _x];
			lbSetData [BOAT_PROJECTION_LIST_IDC, _forEachIndex, name _x];
		} forEach CORP_var_boatProjection_players;

		sleep 0.5;
	};
};

// alimentation de la liste de bateaux disponibles
{
	lbAdd [BOAT_PROJECTION_BOATLIST_IDC, getText (configFile >> "CfgVehicles" >> (_x select 0) >> "displayName")];
} forEach (getArray (configFile >> "CfgCORP" >> "BoatProjection" >> "boats"));

_boatList lbSetCurSel 0;

// gestion du positionnement du marqueur de saut
_map ctrlAddEventHandler ["mouseButtonDblClick", {
	// si un marker éxiste déjà, on le supprime
	if (CORP_var_boatProjection_marker != "") then {
		deleteMarkerLocal CORP_var_boatProjection_marker;
	};

	private _center = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
	_center set [2, 0];

	private _farEnoughtCost = true;

	// on vérifie que la côte la plus proche est suffisament loins
	for [{private _i = 0; private _d = CORP_var_boatProjection_logic getVariable "CoastDistance";}, {_i < _d}, {_i = _i + 2}] do {
		private _pos = [_center, _i,  (22.5 * _i) mod 360] call BIS_fnc_relPos;

		if (((ATLToASL _pos) select 2) > 0) exitWith {
			_farEnoughtCost = false;
		};
	};

	// si la côte est assez loins, on créé le marker
	if (_farEnoughtCost) then {
		CORP_var_boatProjection_coordinates = _center;
		CORP_var_boatProjection_marker = createMarkerLocal ["Marker1", CORP_var_boatProjection_coordinates];
		CORP_var_boatProjection_marker setMarkerShapeLocal "ICON";
		CORP_var_boatProjection_marker setMarkerTypeLocal "respawn_para";
	};
}];

// annulation du saut
_close ctrlAddEventHandler ["MouseButtonDown", {
	closeDialog BOAT_PROJECTION_DIALOG_IDD;
}];

// gestion de la projection
_projection ctrlAddEventHandler ["MouseButtonDown", {
	if (CORP_var_boatProjection_marker != "") then {
		// on demande au serveur de créer les bateaux et de faire embarquer les joueurs
		[CORP_var_boatProjection_coordinates, CORP_var_boatProjection_players, lbCurSel BOAT_PROJECTION_BOATLIST_IDC] remoteExec ["CORP_fnc_BoatProjection_server", 2];

		closeDialog BOAT_PROJECTION_DIALOG_IDD;
	};
}];
