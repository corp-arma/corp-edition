if (!hasInterface) exitWith {};

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

{
	_x execVM "\corp_edition_gear_system\scripts\arsenal.sqf";

	_x addAction [
		"<t color='#ffffff'><img image='\corp_edition_gear_system\arsenal.paa'/> Arsenal (complet)</t>",
		{["Open", true] spawn BIS_fnc_arsenal;},
		nil,
		100,
		true,
		false,
		"",
		"(player distance _target) < 5"
	];
} forEach _objects;
