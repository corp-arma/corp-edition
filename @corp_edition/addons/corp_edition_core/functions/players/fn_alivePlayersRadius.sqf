/*
	NOM :			CORP_fnc_alivePlayersRadius
	AUTEUR :		zgmrvn (edit Sacha)
	DESCRIPTION :	récupère les joueur vivants/conscients (ACE3) dans une zone donnée

	EXAMPLE :
		[
			[2345, 12564, 0],					// centre
			250,								// rayon
			[west, independent],				// tableau de sides à rechercher
			true								// (optionnel) récupérer les IA en plus des joueurs ?. Défaut : false;
		] call CORP_fnc_alivePlayersRadius;
*/

private _center	= param [0, [0, 0, 0], [objNull, []], 3];
private _radius	= param [1, 100, [0]];
private _side	= param [2, [west, east, independent, civilian], [[]], [1, 2, 3, 4]];
private _debug	= param [3, false, [true]];

// composition du tableau des classes à rechercher pour la commande nearestObjects
private _filter = [];

{
	private _temp = switch (_x) do {
		case west: { "B_Soldier_Base_F" };
		case east: { "O_Soldier_Base_F" };
		case independent: { "I_Soldier_Base_F" };
		case civilian: { "Civilian_F" };
	};

	_filter pushBack _temp;
} forEach _side;

// récupération des unités
private _units = nearestObjects [_center, _filter, _radius];

// suppression des ia
if (!_debug) then {
	for [{private _i = count _units}, {_i >= 0}, {_i = _i - 1}] do {
		if (!isPlayer (_units select _i)) then {
			_units deleteAt _i;
		};
	};
};

// suppression de ce qui est mort
for [{private _i = count _units}, {_i >= 0}, {_i = _i - 1}] do {
	if (!alive (_units select _i)) then {
		_units deleteAt _i;
	};
};

// compatibilité ACE
// suppression des unités inconscientes
if (isClass (configfile >> "CfgPatches" >> "ace_medical")) then {
	for [{private _i = count _units}, {_i >= 0}, {_i = _i - 1}] do {
		if ((_units select _i) getVariable "ace_isunconscious") then {
			_units deleteAt _i;
		};
	};
};

_units
