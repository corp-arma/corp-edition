/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

if (!hasInterface) exitWith {};

_mode  = param [0, "", [""]];
_input = param [1, [], [[]]];

_logic = _input param [0, objNull, [objNull]];

_red              = _logic getVariable ["Red", 256];
_green            = _logic getVariable ["Green", 256];
_blue             = _logic getVariable ["Blue", 256];
_brightness       = _logic getVariable ["Brightness", 1];
_useFlare         = _logic getVariable ["UseFlare", false];
_flareSize        = _logic getVariable ["FlareSize", 1];
_flareMaxDistance = _logic getVariable ["FlareMaxDistance", 250];

_red   = _red / 256;
_green = _green / 256;
_blue  =_blue / 256;

switch _mode do {
    // mission
    case "init": {
        _lightsource = "#lightpoint" createVehicleLocal (getposATL _logic);
        _lightsource setPosATL (getPosATL _logic);

        _lightsource setLightColor [_red, _green, _blue];
        _lightsource setLightBrightness _brightness;
        _lightsource setLightUseFlare _useFlare;
        _lightsource setLightFlareSize _flareSize;
        _lightsource setLightFlareMaxDistance _flareMaxDistance;
    };

    // Eden
    case "attributesChanged3DEN": {
        if (isNil {_logic getVariable "lightpoint"}) then {
            _lightsource = "#lightpoint" createVehicleLocal (getposATL _logic);
            _logic setVariable ["lightpoint", _lightsource];
        };

        _lightsource = _logic getVariable "lightpoint";
        _lightsource setPosATL (getPosATL _logic);

        _lightsource setLightColor [_red, _green, _blue];
        _lightsource setLightBrightness _brightness;
        _lightsource setLightUseFlare _useFlare;
        _lightsource setLightFlareSize _flareSize;
        _lightsource setLightFlareMaxDistance _flareMaxDistance;
    };

    // supression du module
    case "unregisteredFromWorld3DEN": {
        deleteVehicle (_logic getVariable "lightpoint");
    };
};
