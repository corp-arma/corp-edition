/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

private _c130j			= param [0, objNull, [objNull]];
private _delay			= param [1, 0, [0]];

sleep _delay;

// préparation de l'objet auquel le joueur sera attaché (téléporté)
private _helper = "Sign_Sphere10cm_F" createVehicleLocal [0, 0, 0];
_helper setPosASL (getPosASL _c130j);
_helper setDir (getDir _c130j);
_helper hideObject true;

// fondu de sortie
cutText ["", "BLACK OUT", 1];
1 fadeSound 0;
sleep 1;

// téléportation
player attachTo [_helper, [0, -8, 1.2]];

// fondu d'entrée
sleep 0.5;
cutText ["", "BLACK IN", 1];
1 fadeSound 1;

// on détache le joueur et supprime le helper
detach player;
deleteVehicle _helper;

// tant que le joueur est à moins de 1000 mètres de l'avion on joue le son des moteurs
_c130j spawn {
	while {(player distance _this) < 1000} do {
		_this say3D ["C130Engine", 400];

		sleep 7.1;
	};
};

// détection lorsque le joueur sors de l'avion
_c130j spawn {
	_bearing = getDir _this;
	waitUntil {(((getposASL player) vectorDiff (getPosASL _this)) select 2) <= 0};

	player allowDamage false;

	// phase d'ajustement de la vélocité pour simuler la perte de vitesse par rapport à l'avion
	{
		sleep (_x select 0);
		player setVelocity [((sin _bearing) * (_x select 1)), ((cos _bearing) * (_x select 1)), (velocity player) select 2];
	} forEach [
		[0.5, 8],
		[0.5, 12],
		[0.5, 20],
		[0.5, 30],
		[0.5, 40],
		[0.5, 50],
		[0.5, 70],
		[1.5, 70]
	];

	sleep 1;

	player allowDamage true;
};
