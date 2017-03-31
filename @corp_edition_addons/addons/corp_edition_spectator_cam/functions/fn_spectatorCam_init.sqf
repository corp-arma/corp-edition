if (!hasInterface) exitWith {};

private _logic		= param [0, objNull, [objNull]];
private _objects	= param [1, [], [[]]];

{
	_x addAction [
		"<t color='#ffffff'><img image='\corp_edition_spectator_cam\icon.paa'/> Caméra spectateur</t>",
		{
			// création de la caméra spéctateur
			["Initialize", [
				player,	// spectator
				[],		// WhitelistedSides
				true,	// allowAi
				true,	// allowFreeCamera
				true,	// allow3PPCamera
				true,	// showFocusInfo
				true,	// showCameraButtons
				true,	// showControlsHelper
				true,	// showHeader
				true 	// showLists
			]] spawn BIS_fnc_EGSpectator;

			// on attend que le dialog de la caméra existe
			waitUntil {!isNull (findDisplay 60492)};

			// puis on ajoute la possibilité de fermer la caméra en appuyant sur la touche échappe
			// par défaut il n'y a aucun moyen de fermer la caméra une fois ouverte
			_eh = (findDisplay 60492) displayAddEventHandler ["KeyDown", {
				_override = false;

				if ((_this select 1) == 1) then {
					["Terminate"] spawn BIS_fnc_EGSpectator;
					_override = true;
				};

				_override
			}];
		},
		nil,
		100,
		true,
		false,
		"",
		"(player distance _target) < 5"
	];
} forEach _objects;
