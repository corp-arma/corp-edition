if (!hasInterface) exitWith {};

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

private _actionDText		= _logic getVariable ["ActionText", "Action"];
private _actionDistance		= _logic getVariable ["ActionDistance", 3];
private _teleportPosition	= _logic getVariable ["TeleportPosition", [0, 0, 0]];
private _teleportDirection	= _logic getVariable ["TeleportDirection", 0];

{
	_x addAction [
		_actionDText,
		{
			_position	= call compile ((_this select 3) select 0);
			_direction	= (_this select 3) select 1;

			cutText ["", "BLACK OUT", 1];
			1 fadeSound 0;
			sleep 1;

			player setPosASL _position;
			player setDir _direction;
			sleep 1;

			cutText ["", "BLACK IN", 1];
			1 fadeSound 1;
		},
		[_teleportPosition, _teleportDirection],
		100,
		true,
		false,
		"",
		format ["(player distance _target) < %1", _actionDistance]
	];
} forEach _objects;
