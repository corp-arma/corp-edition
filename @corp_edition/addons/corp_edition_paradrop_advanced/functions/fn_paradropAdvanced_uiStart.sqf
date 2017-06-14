/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

#include "..\ui\ctrls.hpp"

// déclaration des variables du module
// CORP_var_paradropAdvanced_object, déclarée dans le code de l'action afin de récupérer l'objet drapeau et ainsi pouvoir récupérer les joueurs à proximité
// CORP_var_paradropAdvanced_logic, déclarée dans le code de l'action afin de récupérer la logique du module qui contient les sauts
CORP_var_paradropAdvanced_skyDivers			= [];
CORP_var_paradropAdvanced_markers			= [];
CORP_var_paradropAdvanced_selectedDrop		= [];
CORP_var_paradropAdvanced_customDropMarker	= "";

waitUntil {!isNull (findDisplay PARADROP_ADVANCED_DIALOG_IDD)};

disableSerialization;

_dialog		= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
_dropList	= _dialog displayCtrl PARADROP_ADVANCED_DROPLIST_IDC;
_map 		= _dialog displayCtrl PARADROP_ADVANCED_MAP_IDC;
_close 		= _dialog displayCtrl PARADROP_ADVANCED_CLOSE_IDC;
_jump		= _dialog displayCtrl PARADROP_ADVANCED_JUMP_IDC;

_customCtrlsGroup	= _dialog displayCtrl PARADROP_ADVANCED_CUSTOM_DROP_PARAMS_CONTROLS_GROUP_IDC;
_elevation			= _customCtrlsGroup controlsGroupCtrl PARADROP_ADVANCED_ELEVATION_IDC;
_bearing			= _customCtrlsGroup controlsGroupCtrl PARADROP_ADVANCED_BEARING_IDC;

// alimentation et actualisation de la liste des parachutistes
[] spawn {
	disableSerialization;

	_dialog	= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
	_diverList	= _dialog displayCtrl PARADROP_ADVANCED_DIVERLIST_IDC;

	while {!isNull (findDisplay PARADROP_ADVANCED_DIALOG_IDD)} do {
		// récupération des joueurs à proximité
		CORP_var_paradropAdvanced_skyDivers = [CORP_var_paradropAdvanced_object, 25] call CORP_fnc_alivePlayersRadius;

		// on vide la liste
		lbClear _diverList;

		// puis on la remplit de nouveau
		{
			lbAdd [PARADROP_ADVANCED_DIVERLIST_IDC, name _x];
			lbSetData [PARADROP_ADVANCED_DIVERLIST_IDC, _forEachIndex, name _x];
		} forEach CORP_var_paradropAdvanced_skyDivers;

		sleep 0.5;
	};
};

// ajout sur carte des points de saut disponibles
{
	_marker = createMarkerLocal [format ["paradropAdvanced_marker%1", _forEachIndex], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "mil_arrow2";
	_marker setMarkerSizeLocal [0.9, 0.9];
	CORP_var_paradropAdvanced_markers pushBack _marker;

	lbAdd [PARADROP_ADVANCED_DROPLIST_IDC, format ["Saut %1 (%2m)", _forEachIndex + 1, round ((_x select 0) select 2)]];
	lbSetData [PARADROP_ADVANCED_DROPLIST_IDC, _forEachIndex, str _x];
} forEach (CORP_var_paradropAdvanced_logic getVariable "Drops");

// création du marquer de selection
_marker = createMarkerLocal ["paradropAdvanced_selectedMarker", [0, 0, 0]];
_marker setMarkerDirLocal 0;
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_circle";
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerSizeLocal [1.3, 1.3];
CORP_var_paradropAdvanced_markers pushBack _marker;

// selection du saut depuis la liste de drops
_dropList ctrlAddEventHandler ["LBSelChanged", {
	_dialog	= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
	_map	= _dialog displayCtrl PARADROP_ADVANCED_MAP_IDC;

	// récupération de la donnée
	_data = call compile (lbData [PARADROP_ADVANCED_DROPLIST_IDC, _this select 1]);
	CORP_var_paradropAdvanced_selectedDrop = _data;

	// repositionnement du marker de séléction et animation de la carte
	"paradropAdvanced_selectedMarker" setMarkerPosLocal (_data select 0);
	_map ctrlMapAnimAdd [1, 0.1, _data select 0];
	ctrlMapAnimCommit _map;
}];

// annulation du saut
_close ctrlAddEventHandler ["MouseButtonDown", {
	closeDialog PARADROP_ADVANCED_DIALOG_IDD;
}];

// gestion du saut
_jump ctrlAddEventHandler ["MouseButtonDown", {
	_dialog		= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
	_dropList	= _dialog displayCtrl PARADROP_ADVANCED_DROPLIST_IDC;

	// si il-y-a bien un saut de selectionné
	if ((lbCurSel _dropList) >= 0) then {
		// les variables globales doivent être passées au thread
		// car en parallèle vient la destruction de celles-ci avec la fermeture du dialog
		[CORP_var_paradropAdvanced_selectedDrop, CORP_var_paradropAdvanced_skyDivers] spawn {
			_drop			= _this select 0;
			_divers			= _this select 1;
			_finalPosition	= _drop select 0;
			_bearing		= _drop select 1;
			_elevation		= _finalPosition select 2;
			_finalPosition	= [_finalPosition, 500, _bearing + 180] call bis_fnc_relPos;
			_playerPosition	= (getPosASL player) vectorAdd [0, 0, 100];

			[_playerPosition, _finalPosition, _bearing] remoteExec ["CORP_fnc_paradropAdvanced_server", 2];

			// on attend que le C130 ait été téléporté à sa positon définitive
			waitUntil {(count (nearestObjects [ASLToAGL _finalPosition, ["C130J_static_EP1"], 25])) > 0};

			_c130j = (nearestObjects [ASLToAGL _finalPosition, ["C130J_static_EP1"], 25]) select 0;

			// on attend que le C130J soit sur le bon azimut
			// ça prend un peu de temps à passer sur le réseau
			waitUntil {(abs ((getDirVisual _c130j) - _bearing)) <= 2};

			sleep 1;

			// embarquement des joueurs
			{
				[_c130j, 3 * _forEachIndex] remoteExec ["CORP_fnc_paradropAdvanced_client", _x];
			} forEach _divers;
		};

		closeDialog PARADROP_ADVANCED_DIALOG_IDD;
	};
}];

// dans le cas où le saut personnalisé est autorisé
if (CORP_var_paradropAdvanced_logic getVariable "CustomDrop") then {
	// gestion du positionnement du marqueur de saut personnalisé
	_map ctrlAddEventHandler ["mouseButtonDblClick", {
		_position = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];

		_position set [2,  (parseNumber (ctrlText PARADROP_ADVANCED_ELEVATION_IDC))];

		// dans le cas où le marqueur personalisé n'existe pas encore, on le créé
		if (CORP_var_paradropAdvanced_customDropMarker == "") then {
			CORP_var_paradropAdvanced_customDropMarker = createMarkerLocal ["paradropAdvanced_customMarker", _position];
			CORP_var_paradropAdvanced_customDropMarker setMarkerShapeLocal "ICON";
			CORP_var_paradropAdvanced_customDropMarker setMarkerTypeLocal "mil_arrow2";
			CORP_var_paradropAdvanced_customDropMarker setMarkerColorLocal "ColorOrange";
			CORP_var_paradropAdvanced_customDropMarker setMarkerDirLocal (parseNumber (ctrlText PARADROP_ADVANCED_BEARING_IDC));
			CORP_var_paradropAdvanced_customDropMarker setMarkerSizeLocal [0.9, 0.9];

			lbAdd [PARADROP_ADVANCED_DROPLIST_IDC, "Saut personnalisé"];
		};

		// actualisation des données contenues dans l'élément de la liste
		lbSetData [PARADROP_ADVANCED_DROPLIST_IDC, count (CORP_var_paradropAdvanced_logic getVariable "Drops"), str [_position, (parseNumber (ctrlText PARADROP_ADVANCED_BEARING_IDC))]];

		// remositionnement du marqueur
		CORP_var_paradropAdvanced_customDropMarker setMarkerPosLocal _position;

		// séléction du saut personnalisé comme saut par défaut
		lbSetCurSel [PARADROP_ADVANCED_DROPLIST_IDC, (count (CORP_var_paradropAdvanced_logic getVariable "Drops"))];
	}];

	// gestion du changement d'altitude du saut
	// en utilisant la molette de la souris
	_elevation ctrlAddEventHandler ["MouseZChanged", {
		_dialog		= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
		_dropList	= _dialog displayCtrl PARADROP_ADVANCED_DROPLIST_IDC;
		_control	= _this select 0;

		_mouseWheel = [-1, 1] select ((_this select 1) > 0);

		_elevation = parseNumber (ctrlText _control);
		_elevation = _elevation + _mouseWheel * 100;
		_elevation = _elevation max 0;

		// actualisation du texte du champs
		_control ctrlSetText (str _elevation);

		// si le saut personnalisé existe
		if (CORP_var_paradropAdvanced_customDropMarker != "") then {
			// on actualise les données de l'élément de la liste
			_data = call compile (_dropList lbData (count (CORP_var_paradropAdvanced_logic getVariable "Drops")));
			(_data select 0) set [2, _elevation];
			_dropList lbSetData [count (CORP_var_paradropAdvanced_logic getVariable "Drops"), str _data];

			// si le saut custom est selectionné, actualiser la variable du saut selectionné
			if ((lbCurSel _dropList) == (count (CORP_var_paradropAdvanced_logic getVariable "Drops"))) then {
				CORP_var_paradropAdvanced_selectedDrop = _data;
			};
		};
	}];

	// gestion du changement de l'azimut de saut
	// en utilisant la molette de la souris
	_bearing ctrlAddEventHandler ["MouseZChanged", {
		_dialog		= findDisplay PARADROP_ADVANCED_DIALOG_IDD;
		_dropList	= _dialog displayCtrl PARADROP_ADVANCED_DROPLIST_IDC;
		_control	= _this select 0;

		_mouseWheel = [-1, 1] select ((_this select 1) > 0);

		_bearing = parseNumber (ctrlText _control);
		_bearing = _bearing + _mouseWheel * 10;
		if (_bearing < 0) then {_bearing = 350;};
		if (_bearing > 350) then {_bearing = 0;};

		// actualisation du texte du champs
		_control ctrlSetText (str _bearing);

		// si le saut personnalisé existe
		if (CORP_var_paradropAdvanced_customDropMarker != "") then {
			// on actualise les données de l'élément de la liste
			_data = call compile (_dropList lbData (count (CORP_var_paradropAdvanced_logic getVariable "Drops")));
			_data set [1, _bearing];
			_dropList lbSetData [count (CORP_var_paradropAdvanced_logic getVariable "Drops"), str _data];

			// actualisation du marqueur
			CORP_var_paradropAdvanced_customDropMarker setMarkerDirLocal _bearing;

			// si le saut custom est selectionné, actualiser la variable du saut selectionné
			if ((lbCurSel _dropList) == (count (CORP_var_paradropAdvanced_logic getVariable "Drops"))) then {
				CORP_var_paradropAdvanced_selectedDrop = _data;
			};
		};
	}];
} else {
	_customCtrlsGroup ctrlShow false;

	_dropList ctrlSetPosition [
		safeZoneX + safeZoneW * 0.305,
		safeZoneY + safeZoneH * 0.21,
		safeZoneW * 0.1,
		safeZoneH * 0.52
	];

	_dropList ctrlCommit 0;
};

// annulation du saut
_close ctrlAddEventHandler ["MouseButtonDown", {
	closeDialog PARADROP_DIALOG_IDD;
}];

// selection du premier saut par défaut s'il-y-a au moins 1 saut
if (count (CORP_var_paradropAdvanced_logic getVariable "Drops") > 0) then {
	_dropList lbSetCurSel 0;
};
