/*
	CORP Edition addons
	http://www.corp-arma.fr
*/

private _playerPosition	= param [0, [0, 0, 0], [[]], 3];
private _finalPosition	= param [1, [0, 0, 0], [[]], 3];
private _bearing		= param [2, 0, [0]];

// création de l'avion à proximité du joueur pour forcer la transmission des paramètres sur le réseau
private _c130j = createVehicle ["C130J_static_EP1", _playerPosition, [], 0, "CAN_COLLIDE"];
_c130j setDir _bearing;

sleep 1;

// on place l'avion à sa position définitive
_c130j setPosASL _finalPosition;

// on attend qu'il y ait des joueurs dans l'avion
waitUntil {(count (nearestObjects [_c130j, ["Man"], 50])) > 0};

// on attend qu'il n'y ait plus de joueurs dans l'avion
waitUntil {(count (nearestObjects [_c130j, ["Man"], 50])) == 0};

sleep 10;

// on supprime l'avion
deleteVehicle _c130j;
