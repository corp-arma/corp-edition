/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

if (!hasInterface) exitWith {};

private _logic   = param [0, objNull, [objNull]];
private _objects = param [1, [], [[]]];

{
    _x addAction [
        format [
            "<t color='#ffffff'><img image='\corp_edition_boat_projection\icon.paa'/> %1</t>",
            localize "STR_CORP_BOAT_PROJECTION_DN"
        ],
        {
            CORP_var_boatProjection_object = (_this select 0);
            CORP_var_boatProjection_logic = _this select 3;
            createDialog "CORP_BoatProjectionDialog";},
        _logic,
        100,
        true,
        false,
        "",
        "(player distance _target) < 5"
    ];
} forEach _objects;
