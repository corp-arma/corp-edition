/*
    NOM :			CORP_fnc_findPlayerFreePosition
    AUTEUR :		zgmrvn
    DESCRIPTION :	retourne une position éloignée de tous joueurs

    EXAMPLE :
        [
            [2345, 12564, 0],					// centre
            250,								// distance minimum de tous joueurs
        ] call CORP_fnc_findPlayerFreePosition;
*/

#define MAX_ITERATIONS 16
#define DISTANCE_MULTIPLIER 1.5

private _center			= param [0, [0, 0, 0], [[]], 3];
private _minDistance	= param [1, 100, [0]];

// on recherche une position qui remplit le critère de distance minimum par rapport aux joueurs
// pour trouver cette position, on autorise MAX_ITERATIONS itérations aucours desquelles
// on incrémente la distance de recherche toutes les 3 itérations si aucune position valide n'a été trouvée
// la boucle est quitté prématurément quand une position est trouvée
private _i = 1;
private _m = DISTANCE_MULTIPLIER;

private _return = _center;

while {_i <= MAX_ITERATIONS} do {
    // on cherche une position éloignée du centre _m* la distance minimum souhaitée
    private _tempPos = [_center, _minDistance * _m, random 360] call BIS_fnc_relPos;
    private _players = [_tempPos, _minDistance, [west, east, independent]] call CORP_fnc_alivePlayersRadius;

    // si dans un rayon de 1* la distance de minimum shouaitée, aucun joueur n'a été trouvé
    // on quitte la boucle et on définit la position affecte la variable qui sera retournée par la fonction
    if (count _players == 0) exitWith {
        _return = _tempPos;
        _return set [2, 0];
    };

    // sinon, toutes les 3 itération infrutueuses, on ajoute 0.5* la distance de spawn à la distance de recherche
    if ((_i mod 3) == 0) then {
        _m = _m + 0.5;
    };

    _i = _i + 1;
};

_return
