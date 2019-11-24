/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr

    NAME : CORP_fnc_centroid
    AUTHOR : sacha
    DESCRIPTION : Return the isobarycenter of n 3D vectors.
    RETURN : Position array.

    EXAMPLE :
        [[Ax,Ay,Az], [Bx,By,Bz], [Cx,Cy,Cz], ..., [Nx,Ny,Nz]] call CORP_fnc_centroid;
*/

if ((count _this) > 1) then {
    ( (_this select 0) vectorAdd ((_this select [1, count _this - 1]) call CORP_fnc_centroid) ) vectorMultiply .5;
} else {
    _this select 0;
};
