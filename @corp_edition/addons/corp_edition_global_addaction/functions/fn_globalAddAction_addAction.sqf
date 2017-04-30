/*
	Outils d'édition du CORP
	http://www.corp-arma.fr

	NOM :			globalAddAction_addAction
	AUTEUR :		zgmrvn
	DESCRIPTION :	ajoute une action globale, compatible JIP

	EXAMPLE :
		// serveur
		[
			_ammoBox,								// objet
			"<t color='#FF0000'>Mon action</t>",	// texte de l'action
			"_this execVM 'monScriptclient.sqf'",	// expression à exécuter chez les clients, _this contient le joueur ayant déclenché l'action et l'objet si ce dernier n'a pas été supprimé
			"",										// expression à exécuter côté serveur, _this contient le joueur ayant déclenché l'action et l'objet si ce dernier n'a pas été supprimé
			6,										// distance d'affichage de l'action
			false,									// supprimer l'objet
			true									// supprimer l'action, pas d'importance si l'objet est supprimé
		] call CORP_fnc_globalAddAction_addAction;
*/

#define ACTION_PREFIX "CORP_globalAddAction"

private _object				= param [0, objNull, [objNull]];
private _text				= param [1, "Action", [""]];
private _clientExpression	= param [2, "", [""]];
private _serverExpression	= param [3, "", [""]];
private _distance			= param [4, 3, [0]];
private _deleteObject		= param [5, false, [true]];
private _removeAction		= param [6, false, [true]];
private _label				= [[random 100000000, 8] call CBA_fnc_formatNumber, _this select 7] select (count _this > 7);

// si je suis le serveur, je pépare l'objet
if (isServer) then {
	// on ajoute l'action et l'état de l'action dans les propriétés membres de l'objet
	// tout ce que le serveur fait c'est enregister une action nulle et un l'état valant true pour "l'action peut encore être exécutée", false pour "l'action a été exécutée et supprimée"
	// chaque client remplace ensuite cette valeur par l'id d'une action si celle ci doit être créée
	_object setVariable [format ["%1_%2_id", ACTION_PREFIX, _label], -1, true];
	_object setVariable [format ["%1_%2_state", ACTION_PREFIX, _label], true, true];

	// si je suis un serveur dediée, je brodcast la fonction chez les clients
	// en éditeur, la suite de la fonction sera exécutée, il n'est donc pas nécessaire de brodcaster
	if (isDedicated) then {
		[_object, _text, _clientExpression, _serverExpression, _distance, _deleteObject, _removeAction, _label] remoteExec ["CORP_fnc_globalAddAction_addAction", -2, true];
	};
};

// si je suis un joueur (ce qui est vrai en éditeur), ajouter l'action
if (!isDedicated) then {
	// dans le cas de l'éditeur, cette partie de la fonction sera en unscheduled
	// il faut donc passer en scheduled car il va falloir attendre que le label de l'action stocké dans l'objet ait été brodcasté par le serveur
	[_object, _text, _clientExpression, _serverExpression, _distance, _deleteObject, _removeAction, _label] spawn {
		private _object				= _this select 0;
		private _text				= _this select 1;
		private _clientExpression	= _this select 2;
		private _serverExpression	= _this select 3;
		private _distance			= _this select 4;
		private _deleteObject		= _this select 5;
		private _removeAction		= _this select 6;
		private _label				= _this select 7;

		// si l'objet a été supprimé (dans le cas d'une reconnexion en cours de partie), on quitte la fonction
		if (isNull _object) exitWith {};

		// on attend que les propriétés de l'action ait été brodcastées par le serveur
		waitUntil {!isNil {_object getVariable (format ["%1_%2_id", ACTION_PREFIX, _label])}};
		waitUntil {!isNil {_object getVariable (format ["%1_%2_state", ACTION_PREFIX, _label])}};

		// vérifier que l'action n'ait pas déjà été exécutée (dans le cas d'une reconnexion en cours de partie)
		// la valeur doit être -1 si pas exécutée, -2 si exécutée
		if !(_object getVariable ((format ["%1_%2_state", ACTION_PREFIX, _label]))) exitWith {};

		// addAction
		private _id = _object addAction [
			_text,
			{
				// récupération des paramètres passés à l'action qui sont les paramètres passés à la fonction elle-même
				private _params				= _this select 3;
				private _object				= _params select 0;
				private _text				= _params select 1;
				private _clientExpression	= _params select 2;
				private _serverExpression	= _params select 3;
				private _distance			= _params select 4;
				private _deleteObject		= _params select 5;
				private _removeAction		= _params select 6;
				private _label				= _params select 7;

				private _client = [-2, 0] select isServer;
				private _server = 2;

				// faut-il supprimer l'objet ?
				if (_deleteObject) then {
					[_object, {deleteVehicle _this}] remoteExec ["spawn", _server];
				} else {
					// sinon, faut-il supprimer l'action ?
					if (_removeAction) then {
						// supprimer l'action pour tous les joueurs
						[
							[_object, _label],
							{
								(_this select 0) removeAction ((_this select 0) getVariable (format ["%1_%2_id", ACTION_PREFIX, _this select 1]));
							}
						] remoteExec ["spawn", _client];

						// le serveur passe l'état de l'action à déjà activée (false)
						[
							[_object, _label],
							{
								(_this select 0) setVariable [format ["%1_%2_state", ACTION_PREFIX, _this select 1], false, true];
							}
						] remoteExec ["spawn", _server];
					};
				};

				// on prépare le tableau de données qui sera passé aux expressions client et serveur
				// si l'objet n'a pas été supprimé, on l'ajoute au tableau de données
				_data = [[_this select 1, _object], [_this select 1]] select _deleteObject;

				// si une expression client a été renseignée, on l'exécute
				if (_clientExpression != "") then {
					// exécution de l'expression pour les clients seulement
					[_data, compile _clientExpression] remoteExec ["spawn", _client];
				};

				// si une expression serveur a été renseignée, on l'exécute
				if (_serverExpression != "") then {
					// exécution de l'expression pour le serveur seulement
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
