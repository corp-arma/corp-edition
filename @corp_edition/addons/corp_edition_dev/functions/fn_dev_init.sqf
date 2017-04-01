if (!hasInterface) exitWith {};

private _units = param [1, [], [[]]];

if (player in _units) then {
	execVM "corp_edition_dev\scripts\arsenal.sqf";
	execVM "corp_edition_dev\scripts\allowDamage.sqf";
	execVM "corp_edition_dev\scripts\captive.sqf";

	addMissionEventHandler ["EntityRespawned", {
		if ((_this select 0) == player) then {
			execVM "corp_edition_dev\scripts\arsenal.sqf";
			execVM "corp_edition_dev\scripts\allowDamage.sqf";
			execVM "corp_edition_dev\scripts\captive.sqf";
		};
	}];
};
