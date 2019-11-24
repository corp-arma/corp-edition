/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

private _building = (nearestObjects [player, ["Building"], 50]) select 0;
private _pos      = _building worldToModel (ASLToAGL (getPosASL player));
private _dir      = (getDir player) - (getDir _building);

if (_dir < 0) then {
    _dir = _dir + 360;
};

if (isNil {CORP_var_buildingsOccupation_positions}) then {
    CORP_var_buildingsOccupation_positions = "";
};

private _newPositions = format ["{{%1,%2,%3},%4},%5", _pos select 0, _pos select 1, _pos select 2, floor _dir, endl];
CORP_var_buildingsOccupation_positions = CORP_var_buildingsOccupation_positions + _newPositions;

copyToClipboard CORP_var_buildingsOccupation_positions;
