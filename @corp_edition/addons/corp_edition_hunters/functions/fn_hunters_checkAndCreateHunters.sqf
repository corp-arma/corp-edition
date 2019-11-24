/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

#define EVENT_HANDLER_ID_KEY "CORP_hunters_killedEventHandlerId"
#define HUNTERS_LOGIC_KEY "CORP_hunters_huntersLogic"

private _group  = param [0, grpNull, [grpNull]];
private _logic  = param [1, objNull, [objNull]];
private _center = param [2, [0, 0, 0], [[]], 3];

// If no more alive units in the group.
if (({alive _x} count (units _group)) == 0) then {
    private _condition	= ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 2;

    // If the hunting condition is still true.
    if (call compile _condition) then {
        private _side            = side _group;
        private _huntingUnits    = ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 0;
        private _respawnDistance = ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 1;
        private _parentUnits     = ([CORP_var_hunters_hunts, str _logic] call BIS_fnc_getFromPairs) select 3;

        // We look for a clear position.
        private _freePos = [_center, _respawnDistance] call CORP_fnc_findPlayerFreePosition;

        // We prepare the group's array.
        _array = [_parentUnits] call CBA_fnc_shuffle;

        while {count _array < _huntingUnits} do {
            _array set [count _array, selectRandom _array];
        };

        _array resize _huntingUnits;

        // Then we create a new group based on this array.
        _group = [_freePos, _side, [_array, {typeOf _x}] call CBA_fnc_filter] call BIS_fnc_spawnGroup;
        _group deleteGroupWhenEmpty true;

        // debug
        if !(isNil {CORP_var_hunters_hunters}) then {
            CORP_var_hunters_hunters = _group;
        };

        // For each unit of the group.
        {
            // Cloning parent units' gear.
            _x setUnitLoadout [getUnitLoadout (selectRandom _parentUnits), true];

            // Event hander when killed.
            private _id = _x addEventHandler ["Killed", {
                private _unit  = _this select 0;
                private _logic = _unit getVariable [HUNTERS_LOGIC_KEY, objNull];
                private _group = group _unit;

                // This function check if the group is dead, if yes it creates a new group.
                [_group, _logic, getPosASL _unit] call CORP_fnc_hunters_checkAndCreateHunters;

                // Remove the event handler.
                _unit removeEventHandler ["Killed", (_unit getVariable EVENT_HANDLER_ID_KEY)];

                // Destroy unit's variables.
                _unit setVariable [EVENT_HANDLER_ID_KEY, nil];
                _unit setVariable [HUNTERS_LOGIC_KEY, nil];

                // The killed unit is moved out of the group so it doesn't affects the isobarycenter.
                [_unit] join grpNull;
            }];

            // We store the ID of the event handler so we can delete it inside the event handler.
            _x setVariable [EVENT_HANDLER_ID_KEY, _id];
            _x setVariable [HUNTERS_LOGIC_KEY, _logic];
        } forEach (units _group);

        // Behaviour and waypoints of the group.
        [_group, _logic] call CORP_fnc_hunters_huntersBehaviour;
    };
};
