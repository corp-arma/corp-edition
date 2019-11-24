/*
    Outils d'édition du CORP
    http://www.corp-arma.fr

    NOM :			CORP_fnc_getGroupedUnits
    AUTEUR :		zgmrvn
    DESCRIPTION :
        accepte un tableau de d'unités et retourne toutes les unités groupées ensemble (y compris les unités d'origine)

    EXAMPLE :
        [unit1, unit2] call CORP_fnc_getGroupedUnits; // [unit1, unit2, _unit3, _unit4]
*/

private _return	= [];

// pour chaque unité synchronisé
{
    private _unit = _x;

    // on parcoure chaque unité de son group
    {
        // que l'on ajoute au tableau final si elle n'y est pas déjà
        if !(_x in _return) then {
            _return pushBack _x;
        };
    } forEach (units _unit);
} forEach _this;

_return
