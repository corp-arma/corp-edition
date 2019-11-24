/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr

    NAME : CORP_fnc_getRandomPosInArea
    AUTHOR : zgmrvn
    DESCRIPTION : Gets a random position in the given area.

    PARAMÈTRES :
        origine : tableau de coordonnées, centre de la zone
        zone : tableau au format zone, https://community.bistudio.com/wiki/triggerArea

    RETURN : Position array.

    EXAMPLE :
        [[12456, 2045, 0], [200, 120, 45, false]] call CORP_fnc_getRandomPosInArea;
*/

private _origin	= param [0, [0, 0, 0], [[]], [2, 3]];
private _area	= param [1, [0, 0, 0, false, -1], [[]], [4, 5]];

private _a				= _area select 0;
private _b				= _area select 1;
private _angle			= _area select 2;
private _isRectangle	= _area select 3;

// If the area is a rectangle.
if (_isRectangle) then {
    // horizontal
    _origin	= [_origin, random _a, (_angle + 90) + 180 * (round (random 1))] call BIS_fnc_relPos;

    // vertical
    _origin	= [_origin, random _b, _angle + 180 * (round (random 1))] call BIS_fnc_relPos;

// Else, if the area is an elipse.
} else {
    // Random angle.
    private _random = random 360;

    // Compute vector.
    private _x	= sin _random * random _a,
    private _y	= cos _random * random _b,

    // Rotate vector.
    private _xp = _y * (sin _angle) - _x * (cos _angle);
    private _yp = _y * (cos _angle) + _x * (sin _angle);

    // Vector addition.
    _origin = _origin vectorAdd [_xp, _yp, 0];
};

_origin set [2, 0];

_origin
