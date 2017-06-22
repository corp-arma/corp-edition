/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

private _building	= (nearestObjects [player, ["Building"], 50]) select 0;
private _pos		= _building worldToModel (ASLToAGL (getPosASL player));
private _dir		= (getDir player) - (getDir _building);

if (_dir < 0) then {
	_dir = _dir + 360;
};

if (isNil {CORP_buildingsOccupation_positions}) then {
	CORP_buildingsOccupation_positions = "";
};

CORP_buildingsOccupation_positions = CORP_buildingsOccupation_positions + (format ["{{%1,%2,%3},%4},%5", _pos select 0, _pos select 1, _pos select 2, floor _dir, endl]);

copyToClipboard CORP_buildingsOccupation_positions;
