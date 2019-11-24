/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr

    NAME : CORP_fnc_buildingsOccupation_occupation
    AUTHOR : zgmrvn
    DESCRIPTION : Creates IAs inside the buildings of the area.
    RETURN : Array of units.
    
    EXAMPLE :
        _occupation = [
            [2000, 1000, 0],                  // center
            200,                              // radius
            40,                               // number of units
            east,                             // side
            ["O_medic_F", "O_soldier_exp_F"], // type of unit
            _keepPosition                     // percentage of static units (0 to 1)
        ] call CORP_fnc_buildingsOccupation_occupation;
*/

#define PATH_ACTIVATION_LOOP_DELAY 10

private _center         = param [0, [0, 0, 0], [objNull, []], 3];
private _radius         = param [1, 100, [0]];
private _unitsCount     = param [2, 10, [0]];
private _side           = param [3, east, [sideUnknown]];
private _units          = param [4, [], [[]]];
private _keepPosition   = param [5, 0.5, [0]];
private _resumeDistance = param [6, 25, [0]];

private _positions = []; // Every position found inside the area.
private _buildings = nearestObjects [_center, ["Building"], _radius, true];
private _return    = [];

// Find enemy sides.
private _sides	= [west, east, independent];
_sides deleteAt (_sides find _side);

// Get every positions inside the given area.
{
    private _building = _x;

    if (isClass (configFile >> "CfgCORP" >> "BuildingsOccupation" >> "Buildings" >> (typeOf _building))) then {
        private _buildingsPositions = getArray (configFile >> "CfgCORP" >> "BuildingsOccupation" >> "Buildings" >> (typeOf _building) >> "positions");

        {
            _positions pushBack [_building, _x select 0, _x select 1];
        } forEach _buildingsPositions;
    };
} forEach _buildings;

_positions = [_positions] call CBA_fnc_shuffle;
private _positionsCount = count _positions;

// Create IAs
// as long as the number of created units is lower than the requested number
// and as long as there are less units than available positions.
for [{private _i = 0}, {(_i < _unitsCount) && {_i < _positionsCount}}, {_i = _i + 1}] do {
    private _position = _positions select _i;
    private _building = _position select 0;
    private _pos      = _position select 1;
    private _dir      = _position select 2;

    private _group = createGroup _side;
    _group deleteGroupWhenEmpty true;
    private _wp = _group addWaypoint [_pos, 0];
    deleteWaypoint [_group, (count (waypoints _group)) - 1];
    private _unit = _group createUnit [selectRandom _units, _building modelToWorld _pos, [], 0, "CAN_COLLIDE"];
    _unit setPos (_building modelToWorld _pos);
    _group setFormDir ((getDir _building) + _dir);
    _group setCombatMode "RED";
    _group setBehaviour "SAFE";
    _group setSpeedMode "LIMITED";
    _wp setWaypointType "HOLD";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointCompletionRadius 3;

    // If a percentage of static units is requested we disable AI's path finding
    // and we periodically check if a player is near the unit, if so we reactivate path finding.
    if (_keepPosition != 0) then {
        if ((random 1) < _keepPosition) then {
            _unit disableAI "PATH";

            // We check for player near the unit, if so, we reactivate path finding.
            [_unit, _sides, _resumeDistance] spawn {
                private _unit           = _this select 0;
                private _sides          = _this select 1;
                private _resumeDistance = _this select 2;
                private _loop           = true;
                private _pos            = ASLToATL getPosASL _unit;

                // Random delay to prevent units' loops to be synched.
                sleep random PATH_ACTIVATION_LOOP_DELAY;

                // As long as the unit is alive
                // we periodically check for a player near the unit.
                while {_loop && {alive _unit}} do {
                    private _players = [_pos, _resumeDistance, _sides] call CORP_fnc_alivePlayersRadius;

                    // If player were found, reactivate path finding.
                    if (count _players > 0) then {
                        _unit enableAI "PATH";
                        _loop = false;
                    };

                    sleep PATH_ACTIVATION_LOOP_DELAY;
                };
            };
        };
    };

    _return pushBack _unit;
};

_return
