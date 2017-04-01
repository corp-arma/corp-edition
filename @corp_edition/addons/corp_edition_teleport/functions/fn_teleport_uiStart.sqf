#include "..\ui\ctrls.hpp"

[] spawn {
	waitUntil {!isNull (findDisplay TELEPORT_DIALOG_IDD)};

	disableSerialization;

	_dialog		= findDisplay TELEPORT_DIALOG_IDD;
	_list		= _dialog displayCtrl TELEPORT_LIST_IDC;
	_close		= _dialog displayCtrl TELEPORT_CLOSE_IDC;
	_teleport	= _dialog displayCtrl TELEPORT_TELEPORT_IDC;

	{
		lbAdd [TELEPORT_LIST_IDC, name _x];
		lbSetData [TELEPORT_LIST_IDC, _forEachIndex, name _x];
	} forEach allPlayers;

	_close ctrlAddEventHandler ["MouseButtonDown", {
		closeDialog TELEPORT_DIALOG_IDD;
	}];

	_teleport ctrlAddEventHandler ["MouseButtonDown", {
		_index = lbCurSel TELEPORT_LIST_IDC;

		if (_index >= 0) then {
			_player = lbData [TELEPORT_LIST_IDC, _index];

			{
				if ((name _x) == _player) exitWith {
					closeDialog TELEPORT_DIALOG_IDD;

					_x spawn {
						cutText ["", "BLACK OUT", 1];
						1 fadeSound 0;
						sleep 1;

						player setPosATL (_this getRelPos [2, 0]);
						player setDir ([player, _this] call BIS_fnc_dirTo);
						sleep 0.1;

						cutText ["", "BLACK IN", 1];
						1 fadeSound 1;
					};
				};
			} forEach allPlayers;
		};
	}];
};
