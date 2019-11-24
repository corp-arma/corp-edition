#define ACTION_PRIORITY 5.99

CORP_var_debug_allowDamage = true;

player addAction [
    "<t color='#ffae00'>[DEV] Désactiver les dégâts</t>",
    {
        player allowDamage false;
        CORP_var_debug_allowDamage = false;

        // Invulnerability is disable when exiting spectator camera.
        // this block reactivates it by whatching the display.
        [] spawn {
            // As long as damages are disabled.
            while {!CORP_var_debug_allowDamage} do {
                // We wait for :
                // spectator camera open || damages re-enabled
                waitUntil { !isNull (findDisplay 60492) || CORP_var_debug_allowDamage };

                // If damages are no longer disabled, exit this loop.
                if (CORP_var_debug_allowDamage) exitWith {};

                // Otherwise, we keep whatching for the spectator camera to be closed.
                waitUntil { isNull (findDisplay 60492) };

                // Re-activate damages.
                sleep 0.1;
                player allowDamage false;
            };
        };
    },
    nil,
    ACTION_PRIORITY,
    false,
    true,
    "",
    "CORP_var_debug_allowDamage"
];

player addAction [
    "<t color='#ffae00'>[DEV] Activer les dégâts</t>",
    {
        player allowDamage true;
        CORP_var_debug_allowDamage = true;
    },
    nil,
    ACTION_PRIORITY,
    false,
    true,
    "",
    "!CORP_var_debug_allowDamage"
];
