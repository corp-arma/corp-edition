/*
	NOM :			CORP_fnc_centroid
	AUTEUR :		sacha
	DESCRIPTION :	retourne l'isobarycentre de n vecteurs 3D

	EXAMPLE :
		[[Ax,Ay,Az], [Bx,By,Bz], [Cx,Cy,Cz], ..., [Nx,Ny,Nz]] call CORP_fnc_centroid;
*/

if ((count _this) > 1) then {
	( (_this select 0) vectorAdd ((_this select [1, count _this - 1]) call CORP_fnc_centroid) ) vectorMultiply .5;
} else {
	_this select 0;
};
