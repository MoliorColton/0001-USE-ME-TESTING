/*
    Script:			This is the MASTER initialization script.  It goes in all areas OnClientEnter script OR is called
					from an existing OnClientEnter script. The purpose of this script is 3 fold.  First is to 
					initialize any system that requires a one-time initialization routine after a server reset.
					This could also be done during Module OnLoad but I find this to be more reliable.  The second 
					section is to initialize anything for a player since the last reset that requires a one time
					run - such as caching database variables for quests.  Lastly it performs any AreaOnEnter routines 
					that have to run whenever a player enters a new area such as activating spawns etc.

*/



void SaveLocation(object oPC)
{
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	if (oESSENCE == OBJECT_INVALID) return;
	location lPC = GetLocation(oPC);
	SetLocalLocation(oESSENCE, "LAST_LOCATION", lPC);
}




void main()
{
	// This should be placed in the OnClientEnter script field or called from there.  First we find out if
	// we were called via someone elses OnClientEnter script for the area or if we are the actual script for
	// that event.
	object oPC = OBJECT_SELF;
	if (GetIsOwnedByPlayer(oPC) == FALSE) oPC = GetMaster(oPC);
	if (GetIsOwnedByPlayer(oPC) == FALSE) oPC = GetFirstEnteringPC();
	if (GetIsOwnedByPlayer(oPC) == FALSE) return;
	
	DelayCommand(0.1, SaveLocation(oPC));
	
	object oMOD = GetModule();
	
	// Check for each module currently supported that requires an onload initialization.  These will only
	// run when the first player enters the world since the last server reset.  We put it here because
	// from my personal experience, OnModuleLoad events work sporadically at best.
	if (!GetLocalInt(oMOD, "LEG_SYSTEMS_INIT"))
	{
		// Set the systems to initalized.
		SetLocalInt(oMOD, "LEG_SYSTEMS_INIT", 1);
		
		// Check for the Legends BANTER Module
		if (GetLocalInt(oMOD, "LEG_BANTER_ACTIVE")) ExecuteScript("leg_banter_init", oMOD);
			
		// Check for the Legends FACTIONS plugin.
		if (GetLocalInt(oMOD, "LEG_FACTIONS_ACTIVE")) ExecuteScript("leg_factions_init", oMOD);								
	}
		
	// Run any modules that require code applied to each entering player for the first time and 
	// only one time per server reset (like caching quest variables).
	if (!GetLocalInt(oPC, "LEG_PLAYER_INIT"))
	{
		
		// Check for the Legends BANTER Module
		if (GetLocalInt(oMOD, "LEG_BANTER_ACTIVE"))	ExecuteScript("leg_banter_pcinit", oPC);
		if (GetLocalInt(oMOD, "LEG_QUEST_ACTIVE")) ExecuteScript("leg_quest_pcinit", oPC);
		
		// See if the Infobox plugin is active
		if (GetLocalInt(oMOD, "LEG_INFO_ACTIVE")) ExecuteScript("leg_info_pcinit", oPC);
	
		// Check for the Life Plugin.
		if (GetLocalInt(oMOD, "LEG_WORLD_ACTIVE")) ExecuteScript("leg_world_pcinit", oPC);
						
		// See if the Crafting plugin is active
		if (GetLocalInt(oMOD, "LEG_CRAFT_ACTIVE")) ExecuteScript("leg_craft_pcinit", oPC);
		
		// See if the Tele plugin is active
		if (GetLocalInt(oMOD, "LEG_TELE_ACTIVE")) ExecuteScript("leg_tele_pcinit", oPC);
			
		// See if the Housing plugin is active
		if (GetLocalInt(oMOD, "LEG_HOUSING_ACTIVE")) ExecuteScript("leg_housing_pcinit", oPC);
		
		// See if the Factions plugin is active
		if (GetLocalInt(oMOD, "LEG_FACTIONS_ACTIVE")) ExecuteScript("leg_factions_pcinit", oPC);
			
		// Run World's custom Player Init script
		//string sPlayerInitScript = GetLocalString(oMOD, "LEG_CUSTOM_PCINIT");
		//if (sPlayerInitScript != "") ExecuteScript(sPlayerInitScript, oPC);
		
		// Set the Player to Initialized.
		SetLocalInt(oPC, "LEG_PLAYER_INIT", 1);
	}
	
	// Run any On Area Enter code for modules that need to run each time an area is entered.
	// LEG_SPAWN etc
	// Check for the Tele Plugin.
	if (GetLocalInt(oMOD, "LEG_TELE_ACTIVE")) ExecuteScript("leg_tele_onenter", oPC);
		
	// Check for the World Plugin.
	if (GetLocalInt(oMOD, "LEG_WORLD_ACTIVE")) ExecuteScript("leg_world_onenter", oPC);
			
	// Check for the Legends SPAWN Module (also used in various other modules such as LOOT)
	if (GetLocalInt(oMOD, "LEG_SPAWN_ACTIVE")) ExecuteScript("leg_spawn_onenter", oPC);			
	
	// Check for the Quest Plugin.
	if (GetLocalInt(oMOD, "LEG_QUEST_ACTIVE")) ExecuteScript("leg_quest_onenter", oPC);

	// Check for the Factions Plugin.
	if (GetLocalInt(oMOD, "LEG_FACTIONS_ACTIVE")) ExecuteScript("leg_factions_onenter", oPC);

	// Check for the Housing Plugin.
	if (GetLocalInt(oMOD, "LEG_HOUSING_ACTIVE")) ExecuteScript("leg_housing_onenter", oPC);
}