if (!hasInterface) exitWith {};

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

{
	_x addAction [
		"<t color='#ffffff'><img image='\corp_edition_paradrop\icon.paa'/> Saut en parachute</t>",
		{CORP_var_paraJumpClassic_flag = (_this select 0); createDialog "CORP_ParaJumpClassicDialog";},
		nil,
		100,
		true,
		false,
		"",
		"(player distance _target) < 5"
	];
} forEach _objects;
