/*
	Outils d'édition du CORP
	http://www.corp-arma.fr
*/

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

private _actionText			= _logic getvariable ["ActionText", "Action"];
private _serverExpression	= _logic getVariable ["ServerExpression", ""];
private _clientExpression	= _logic getVariable ["ClientExpression", ""];
private _actionDistance		= _logic getVariable ["ActionDistance", 6];
private _deleteObject		= _logic getVariable ["DeleteObject", false];
private _removeAction		= _logic getVariable ["RemoveAction", false];

// on attache une action à tous les objets synchronisés au module
{
	[
		_x,					// objet
		_actionText,		// texte de l'action
		_clientExpression,	// expression à exécuter chez les clients
		_serverExpression,	// expression à exécuter côté serveur
		_actionDistance,	// distance d'affichage de l'action
		_deleteObject,		// supprimer l'objet
		_removeAction		// supprimer l'action, pas d'importance si l'objet est supprimé
	] call CORP_fnc_globalAddAction_addAction;
} forEach _objects;
