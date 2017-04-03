((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
	private _map = _this select 0;

	_map drawIcon [
		getText (configFile >> "CfgVehicles" >> typeOf player >> "Icon"),
		[1, 1, 1, 1],
		visiblePosition player,
		0.5 / ctrlMapScale _map,
		0.5 / ctrlMapScale _map,
		getDirVisual player
	];
}];
