if (!hasInterface) exitWith {};

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

{
    _x addAction [
        "<t color='#ffffff'><img image='\corp_edition_teleport\icon.paa'/> Téléportation</t>",
        { createDialog "CORP_TeleportDialog" },
        nil,
        100,
        true,
        false,
        "",
        "(player distance _target) < 5"
    ];
} forEach _objects;
