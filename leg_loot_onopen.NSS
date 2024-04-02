
/*

    Script:			This is the magical opening script for Pandora's... er.. the loot.. yeah loot..mmmmm.
					It calls the leg_loot_makeloot script to spawn treasure content for the opener.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		11/26/2010 - Updated to work with Legends Master Modular Systems
					09/21/2012 - 1.2 MV - Fixed bug where spawn point configurations would never spawn loot.

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Who just opened me and who's mah daddy?
	object oPC = GetLastOpenedBy();
	object oParent = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");

	if (!GetIsObjectValid(oParent))
	{
		oParent = OBJECT_SELF;
	}
	else
	{
		if (GetLocalString(oParent, "LEG_LOOT_ID") == "")
		{
			oParent = OBJECT_SELF;
		}
	}
		
	// The script for making loot only needs 3 things. 
	// 1. The oPC = Person interacting with the loot object or NPC
	// 2. The oParent = Where all the loot variables are located, WP or NPC or Mob Corpse or Self
	// 3. The OBJECT_SELF = Where the Loot Items will be created.
	AddScriptParameterObject(oPC);
	AddScriptParameterObject(oParent);
	ExecuteScriptEnhanced("leg_loot_makeloot", OBJECT_SELF);
	
	// If the Quest plugin is active, then we need to check for this and clear up any quest spawners for this loot object.
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
	{
		AddScriptParameterObject(oPC);
		AddScriptParameterObject(oParent);
		ExecuteScriptEnhanced("leg_quest_clearspawner", OBJECT_SELF);
	}

}