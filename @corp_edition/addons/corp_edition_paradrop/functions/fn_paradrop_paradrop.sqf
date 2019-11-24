/*
    CORP's Mission Editing Tools
    http://www.corp-arma.fr
*/

sleep (_this select 0);

cutText ["", "BLACK OUT", 1];
1 fadeSound 0;
sleep 1;

player setPosASL (_this select 1);

sleep 0.1;
cutText ["", "BLACK IN", 1];
1 fadeSound 1;
