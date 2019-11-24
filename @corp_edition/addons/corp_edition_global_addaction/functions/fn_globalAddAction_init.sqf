/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

private _logic   = param [0, objNull, [objNull]];
private _objects = param [1, [], [[]]];

private _actionText       = _logic getvariable ["ActionText", "Action"];
private _serverExpression = _logic getVariable ["ServerExpression", ""];
private _clientExpression = _logic getVariable ["ClientExpression", ""];
private _actionDistance   = _logic getVariable ["ActionDistance", 6];
private _deleteObject     = _logic getVariable ["DeleteObject", false];
private _removeAction     = _logic getVariable ["RemoveAction", false];

// Attach an action to every objects synched to the module.
{
    [
        _x,                // object
        _actionText,       // action's text
        _clientExpression, // client side expression
        _serverExpression, // server side expression
        _actionDistance,   // display distance
        _deleteObject,     // delete object
        _removeAction      // delete action, doesn't matter if the object is deleted.
    ] call CORP_fnc_globalAddAction_addAction;
} forEach _objects;
