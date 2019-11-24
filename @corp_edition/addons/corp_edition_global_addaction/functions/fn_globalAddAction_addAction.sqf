/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr

    NAME : CORP_fnc_globalAddAction_addAction
    AUTHOR : zgmrvn
    DESCRIPTION : Adds a global addAction to the given object, JIP compatible.
    RETURN : Void.

    EXAMPLE :
        // server
        [
            _ammoBox,                            // object
            "<t color='#FF0000'>Mon action</t>", // action's text
            "_this execVM 'myClientScript.sqf'", // expression to execute client side, _this contains the player that triggered the action and the object if this one has not been deleted
            "",                                  // expression to exexute server side, _this contains the player that triggered the action and the object if this one has not been deleted
            6,                                   // display distance for the action
            false,                               // delete object ?
            true                                 // delete action ? Doesn't matter if the object is deleted
        ] call CORP_fnc_globalAddAction_addAction;
*/

#define ACTION_PREFIX "CORP_globalAddAction"

private _object           = param [0, objNull, [objNull]];
private _text             = param [1, "Action", [""]];
private _clientExpression = param [2, "", [""]];
private _serverExpression = param [3, "", [""]];
private _distance         = param [4, 3, [0]];
private _deleteObject     = param [5, false, [true]];
private _removeAction     = param [6, false, [true]];
private _label            = [[random 100000000, 8] call CBA_fnc_formatNumber, _this select 7] select (count _this > 7);

// If isServer, prepare the object.
if (isServer) then {
    // We store the action and its state in the member properties of the object.
    // The server creates a null action (-1) with a state of true for "the action still can be executed",
    // each client then replace this value with the id of the action if this one has to be created.
    _object setVariable [format ["%1_%2_id", ACTION_PREFIX, _label], -1, true];
    _object setVariable [format ["%1_%2_state", ACTION_PREFIX, _label], true, true];

    // If isDedicated, brodcast this function to clients.
    // In Eden, the rest of the function will be executed, it's not necessary to brodcast.
    if (isDedicated) then {
        [
            _object,
            _text,
            _clientExpression,
            _serverExpression,
            _distance,
            _deleteObject,
            _removeAction,
            _label
        ] remoteExec ["CORP_fnc_globalAddAction_addAction", -2, true];
    };
};

// If i'm a player (which is true in Eden), add action.
if (!isDedicated) then {
    // In the case of Eden, this part of the function will be unscheduled,
    // so we need move in scheduled because we need to wait for the server to brodcast the label of the action.
    [_object, _text, _clientExpression, _serverExpression, _distance, _deleteObject, _removeAction, _label] spawn {
        private _object           = _this select 0;
        private _text             = _this select 1;
        private _clientExpression = _this select 2;
        private _serverExpression = _this select 3;
        private _distance         = _this select 4;
        private _deleteObject     = _this select 5;
        private _removeAction     = _this select 6;
        private _label            = _this select 7;

        // If the object has been deleted (in the case of a JIP), exit the function.
        if (isNull _object) exitWith {};

        // We wait for the action's properties to have been borcasted by the server.
        waitUntil {!isNil {_object getVariable (format ["%1_%2_id", ACTION_PREFIX, _label])}};
        waitUntil {!isNil {_object getVariable (format ["%1_%2_state", ACTION_PREFIX, _label])}};

        // Check if the action has not been already executed (in the case of a JIP),
        // value must be -1 if not executed, -2 if executed.
        if !(_object getVariable ((format ["%1_%2_state", ACTION_PREFIX, _label]))) exitWith {};

        // addAction
        private _id = _object addAction [
            _text,
            {
                // Recuperation of paramaters passed to the action which are the parameters passed to the function.
                private _params           = _this select 3;
                private _object           = _params select 0;
                private _text             = _params select 1;
                private _clientExpression = _params select 2;
                private _serverExpression = _params select 3;
                private _distance         = _params select 4;
                private _deleteObject     = _params select 5;
                private _removeAction     = _params select 6;
                private _label            = _params select 7;

                private _client = [-2, 0] select isServer;
                private _server = 2;

                // Delete object ?
                if (_deleteObject) then {
                    [_object, {deleteVehicle _this}] remoteExec ["spawn", _server];
                } else {
                    // Else, delete action ?
                    if (_removeAction) then {
                        // Delete action for each client.
                        [
                            [_object, _label],
                            {
                                (_this select 0) removeAction ((_this select 0) getVariable (format ["%1_%2_id", ACTION_PREFIX, _this select 1]));
                            }
                        ] remoteExec ["spawn", _client];

                        // Server sets action's state to "already executed" (false).
                        [
                            [_object, _label],
                            {
                                (_this select 0) setVariable [format ["%1_%2_state", ACTION_PREFIX, _this select 1], false, true];
                            }
                        ] remoteExec ["spawn", _server];
                    };
                };

                // We pepare the array that will be passed to clients and server's expressions.
                // If the object has not been deleted, add it to the array.
                _data = [[_this select 1, _object], [_this select 1]] select _deleteObject;

                // If a client expression has been set, run it.
                if (_clientExpression != "") then {
                    // Execute the expression for client only.
                    [_data, compile _clientExpression] remoteExec ["spawn", _client];
                };

                // If a server expression has been set, run it.
                if (_serverExpression != "") then {
                    // Execute the expression for the server only.
                    [_data, compile _serverExpression] remoteExec ["spawn", _server];
                };
            },
            [
                _object,
                _text,
                _clientExpression,
                _serverExpression,
                _distance,
                _deleteObject,
                _removeAction,
                _label
            ],
            1.5,
            true,
            true,
            "",
            format ["(player distance _target) < %1", _distance]
        ];

        _object setVariable [format ["%1_%2_id", ACTION_PREFIX, _label], _id];
    };
};
