/*
    NOM :			CORP_fnc_getSideColor
    AUTEUR :		zgmrvn
    DESCRIPTION :
        Retourne les informations de couleur d'un side. En fonction du mode :
            - "ARRAY" : retourne la couleur sous forme de tableau [R, G, B, A]
            - "STRING" : retourne la couleur sous forme de chaîne utilisable par la commande setMarkerColor

    EXAMPLE :
        [west, "ARRAY"] call CORP_fnc_getSideColor; // [0, 0.3, 0.6, 1]
*/

private _side	= param [0, civilian, [sideUnknown]];
private _mode	= param [1, "ARRAY", [""]];
private _color	= [];

if (_mode == "STRING") then {
    _color = switch (_side) do {
        case east: {"ColorEAST"};
        case independent: {"ColorGUER"};
        case west: {"ColorWEST"};
        default {"ColorCIV"};
    };
} else {
    _color = switch (_side) do {
        case east: {[0.5, 0, 0, 1]};
        case independent: {[0, 0.5, 0, 1]};
        case west: {[0, 0.3, 0.6, 1]};
        default {[0.4, 0, 0.5, 1]};
    };
};

_color
