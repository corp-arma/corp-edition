/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

if (CORP_var_boatProjection_marker != "") then {
    deleteMarkerLocal CORP_var_boatProjection_marker;
};

CORP_var_boatProjection_object      = nil;
CORP_var_boatProjection_logic       = nil;
CORP_var_boatProjection_players     = nil;
CORP_var_boatProjection_coordinates = nil;
CORP_var_boatProjection_marker      = nil;
