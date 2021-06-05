/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

#include "..\ui\ctrls.hpp"

// déclaration des variables du module
// CORP_var_paraJumpClassic_flag, déclarée dans le code de l'action afin de récupérer l'objet drapeau et ainsi pouvoir récupérer les joueurs à proximité
CORP_var_paraJumpClassic_skyDivers   = [];
CORP_var_paraJumpClassic_coordinates = [];
CORP_var_paraJumpClassic_marker      = "";
CORP_var_paraJumpClassic_elevation   = "5000";

[] spawn {
    waitUntil {!isNull (findDisplay PARADROP_DIALOG_IDD)};

    disableSerialization;

    _dialog   = findDisplay PARADROP_DIALOG_IDD;
    _altitude = _dialog displayCtrl PARADROP_ALTITUDE_IDC;
    _map      = _dialog displayCtrl PARADROP_MAP_IDC;
    _close    = _dialog displayCtrl PARADROP_CLOSE_IDC;
    _jump     = _dialog displayCtrl PARADROP_JUMP_IDC;

    // alimentation et actualisation de la liste
    [] spawn {
        disableSerialization;

        _dialog = findDisplay PARADROP_DIALOG_IDD;
        _list   = _dialog displayCtrl PARADROP_LIST_IDC;

        while {!isNull (findDisplay PARADROP_DIALOG_IDD)} do {
            // récupération des joueurs à proximité
            CORP_var_paraJumpClassic_skyDivers = [CORP_var_paraJumpClassic_flag, 25] call CORP_fnc_alivePlayersRadius;

            // on vide la liste
            lbClear _list;

            // puis on la remplit de nouveau
            {
                lbAdd [PARADROP_LIST_IDC, name _x];
                lbSetData [PARADROP_LIST_IDC, _forEachIndex, name _x];
            } forEach CORP_var_paraJumpClassic_skyDivers;

            sleep 0.5;
        };
    };

    // gestion du changement d'altitude du saut
    // en utilisant la molette de la souris
    _altitude ctrlAddEventHandler ["MouseZChanged", {
        _mouseWheel = [-1, 1] select ((_this select 1) > 0);
        _definition = parseNumber (ctrlText PARADROP_ALTITUDE_IDC);
        _definition = _definition + _mouseWheel * 100;

        CORP_var_paraJumpClassic_elevation = str _definition;
        ctrlSetText [PARADROP_ALTITUDE_IDC, str _definition];
    }];

    // gérer l'ajout de lettres
    _altitude ctrlAddEventHandler ["KeyDown", {
        _elevation = ctrlText PARADROP_ALTITUDE_IDC;
        _elevation = toArray _elevation;
        _filter    = toArray "0123456789";
        _iterate   = true;

        // on boucle sur la chaîne du champs convertie en tableau
        // tant que l'on a pas trouvé de caractère interdit
        for [{_i = 0; _c = count _elevation;}, {_i < _c && {_iterate}}, {_i = _i + 1}] do {
            // si le caractère ajouté n'est pas un chiffre
            if !((_elevation select _i) in _filter) then {
                // on affecte la dernière valeur d'altiture connue
                // et on arrête la boucle
                _elevation = CORP_var_paraJumpClassic_elevation;
                _iterate = false;
            };
        };

        // si la boucle est arrivée à son terme
        // on a toujours un tableau qu'il vaut repasser en chaîne
        if (_iterate) then {
            _elevation = toString _elevation;
        };

        // on sauvegarde la nouvelle valeur du champ
        // et on le remplis
        CORP_var_paraJumpClassic_altitude = _elevation;
        ctrlSetText [PARADROP_ALTITUDE_IDC, _elevation];
    }];

    // gestion du positionnement du marqueur de saut
    _map ctrlAddEventHandler ["mouseButtonDblClick", {
        if (CORP_var_paraJumpClassic_marker != "") then {
            deleteMarkerLocal CORP_var_paraJumpClassic_marker;
        };

        CORP_var_paraJumpClassic_coordinates = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
        CORP_var_paraJumpClassic_marker = createMarkerLocal ["Marker1", CORP_var_paraJumpClassic_coordinates];
        CORP_var_paraJumpClassic_marker setMarkerShapeLocal "ICON";
        CORP_var_paraJumpClassic_marker setMarkerTypeLocal "respawn_para";
    }];

    // annulation du saut
    _close ctrlAddEventHandler ["MouseButtonDown", {
        closeDialog PARADROP_DIALOG_IDD;
    }];

    // gestion du saut
    _jump ctrlAddEventHandler ["MouseButtonDown", {
        if ((count CORP_var_paraJumpClassic_coordinates) > 0) then {
            CORP_var_paraJumpClassic_coordinates set [2, parseNumber (ctrlText PARADROP_ALTITUDE_IDC)];

            {
                [2 * _forEachIndex, CORP_var_paraJumpClassic_coordinates] remoteExec ["CORP_fnc_paradrop_paradrop", _x];
            } forEach CORP_var_paraJumpClassic_skyDivers;

            closeDialog PARADROP_DIALOG_IDD;
        };
    }];
};
