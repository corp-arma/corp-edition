#define ACTION_PRIORITY 6

player addAction [
	"<t color='#ffae00'>[DEV] Arsenal</t>",
	{
		["Open", true] spawn BIS_fnc_arsenal;
	},
	nil,
	ACTION_PRIORITY,
	false,
	true
];
