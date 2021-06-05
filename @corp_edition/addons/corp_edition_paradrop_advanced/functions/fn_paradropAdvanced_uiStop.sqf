/*
    CORP Edition addons
    http://www.corp-arma.fr
*/

{
    deleteMarkerLocal _x;
} forEach CORP_var_paradropAdvanced_markers;

CORP_var_paradropAdvanced_object       = nil;
CORP_var_paradropAdvanced_logic        = nil;
CORP_var_paradropAdvanced_skyDivers    = nil;
CORP_var_paradropAdvanced_markers      = nil;
CORP_var_paradropAdvanced_selectedDrop = nil;

// saut custom
if (!isNil {CORP_var_paradropAdvanced_customDropMarker}) then {
    deleteMarkerLocal CORP_var_paradropAdvanced_customDropMarker;
    CORP_var_paradropAdvanced_customDropMarker = nil;
};
