/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

private _actions	= [];
private _planes 	= [];

{
	if (typeOf _x == "C130J_static_EP1") then {
		_planes pushBack _x;
	} else {
		_actions pushBack _x;
	};
} forEach _objects;

// serveur
if (isServer) then {
	private _drops = [];

	{
		_drops pushBack [getPosATL _x, getDir _x];
		deleteVehicle _x;
	} forEach _planes;

	_logic setVariable ["Drops", _drops, true];
};

// joueur
if (hasInterface) then {
	{
		_x addAction [
			"<t color='#ffffff'><img image='\corp_edition_paradrop_advanced\icon.paa'/> Saut en parachute avancé</t>",
			{
				CORP_var_paradropAdvanced_object = _this select 0;
				CORP_var_paradropAdvanced_logic = _this select 3;
				createDialog "CORP_ParadropAdvancedDialog";
			},
			_logic,
			100,
			true,
			false,
			"",
			"(player distance _target) < 5"
		];
	} forEach _actions;
};
