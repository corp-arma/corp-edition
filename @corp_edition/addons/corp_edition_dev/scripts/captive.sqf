#define ACTION_PRIORITY 5.98

player addAction [
    "<t color='#ffae00'>[DEV] Devenir captif</t>",
    { player setCaptive true },
    nil,
    ACTION_PRIORITY,
    false,
    true,
    "",
    "!captive _target"
];

player addAction [
    "<t color='#ffae00'>[DEV] Ne plus être captif</t>",
    { player setCaptive false },
    nil,
    ACTION_PRIORITY,
    false,
    true,
    "",
    "captive _target"
];
