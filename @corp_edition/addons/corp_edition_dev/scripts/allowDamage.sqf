#define ACTION_PRIORITY 5.99

CORP_var_debug_allowDamage = true;

player addAction [
	"<t color='#ffae00'>[DEV] Désactiver les dégâts</t>",
	{
		player allowDamage false;
		CORP_var_debug_allowDamage = false;

		// l'invincibilité est désactivée à la sortie de la caméra spectateur
		// ce script la réactive en surveillant la fermeture du display
		[] spawn {
			// tant que les dégâts sont désactivés
			while {!CORP_var_debug_allowDamage} do {
				// on attend que
				// caméra spectateur affichée || dégâts réactivés
				waitUntil { !isNull (findDisplay 60492) || CORP_var_debug_allowDamage };

				// si les dégâts ne sont plus désactivés, on sort de la boucle
				if (CORP_var_debug_allowDamage) exitWith {};

				// sinon, on continue et on attend que la caméra spectateur soit refermée
				waitUntil { isNull (findDisplay 60492) };

				// on re-désactive les dégâts
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
