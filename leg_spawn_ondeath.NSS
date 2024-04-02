/*

    Script:			Main Death script for all spawn related objects.  This is called from the Master Death
	  				script which is placed on Mobs and placeable objects.  
	Version:		1.5
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		11/24/2010 - 1.00 MV - Initial Release
					11/27/2010 - 1.01 MV - Change name and moved to Spawn System.
					12/14/2010 - 1.02 MV - Fixed effect bug.
					09/19/2011 - 1.03 MV - Updated to support spawning 1.42
					11/22/2012 - 1.4 MV - Death now deactivates convo spawn points.
					01/18/2014 - 1.5 MV - Fixed so we check for spawns right after we die in case we respawn right away.

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// First lets get the parent.  Of course, if this object has no parent then it wasnt created using
	// the spawn plugin.  Possible if using say, the Quest Plugin and Loot Plugin for placeables but a
	// different system for spawning monsters.
	object oSelf = OBJECT_SELF;
	object oParent = GetLocalObject(oSelf, "SPAWN_Parent");
	string sIndex = GetLocalString(oSelf, "SPAWN_Index");
	SetLocalObject(oParent, "SPAWN_" + sIndex, OBJECT_INVALID);
	LEG_COMMON_TimeOfDeath(oSelf, oParent);	

	// Re-Add the child's Spawn Point back to the Parent's array
	// if the Spread Type on this is "One Spawn Per Point" to
	// tell the system it can be used again.
	if (GetLocalString(oParent, "LEG_SPAWN_Spread") == "One Spawn Per Point")
	{
		string sMySpawnWP = GetLocalString(oSelf, "SPAWN_MySpawnWP");
		LEG_COMMON_AddArrayElement(oParent, "LEG_SPAWN_Points", sMySpawnWP);
	}
	
	// Deactivate my Convo Spawners when I die.
	AddScriptParameterInt(1);
	AddScriptParameterInt(0);
	ExecuteScriptEnhanced("leg_spawn_convospawn", oSelf);

	AddScriptParameterInt(2);
	AddScriptParameterInt(0);
	ExecuteScriptEnhanced("leg_spawn_convospawn", oSelf);
	
	
	// If we are a placeable object, let's put a destroy effect on here if we are asked to do so.
	if (GetLocalInt(oParent, "LEG_SPAWN_ObjectType") == 1)
	{
		// If we are not supposed to drop our loot as a placeable, then lets ensure we don't do that.
		if (GetLocalInt(oParent, "LEG_SPAWN_DoNotDropMyLoot"))
			LEG_COMMON_DestroyInventory(oSelf);
		
		// Set up some defaults
		int iEffect = GetLocalInt(oParent, "LEG_SPAWN_DestroyEffect");
		string sEffect = GetLocalString(oParent, "LEG_SPAWN_DestroySefEffect");
		if (iEffect == 0)
			iEffect = 1185;
		DelayCommand(0.2, LEG_COMMON_VisualEffect(iEffect, oSelf, OBJECT_INVALID));
	}
	else
	{
		// We throw this in there in the event that we are not supposed to drop loot as a monster via the
		// SPAWN plugin.  NOTE that if monsters are configured to create loot on their person at time
		// of death, they simply do not create loot at all as handled by the leg_all_masterdeath script however
		// mobs MAY be told to create loot at spawn time in order for them to use it so we have to ensure
		// that in those cases, loot is destroyed before they drop it when they die.
		if (GetLocalInt(oParent, "LEG_SPAWN_DoNotDropMyLoot") && GetLocalInt(GetModule(), "LEG_LOOT_ONSPAWN"))
			LEG_COMMON_DestroyInventory(oSelf);
	}
	
	// Do a quick spawn check
	DelayCommand(0.2, ExecuteScript("leg_spawn_checkspawns", oSelf));
}