/*
    Script:			This is the MASTER on spawn script.  It goes on all NPC's and monsters or is called from an
					existing script via ExecuteScript function.  Like all Master Run Scripts, this script examines which
					plugins are available and active and calls them.
	Version:		1.61
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A

	Change Log:		12/17/2010 - MV - Initial Revision
					10/17/2011 - MV 1.60 - Added fix for new loot plugin.		
					02/22/2013 - MV 1.61 - Fixed bug that caused loot on spawn to not work.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Master System for OnSpawn events for Legends Modules.  This needs to be called from either the NWN2 stock
	// on death event for monsters or called from a custom on death event script or optionally called directly AS
	// the on death script.  First we determine if we were passed from another script or if we are called be the event.	
	object oTarget = OBJECT_SELF;
	object oMODULE = GetModule();

	// If the LOOT Plugin is active.
	if (GetLocalInt(oMODULE, "LEG_LOOT_ACTIVE") && GetLocalInt(oMODULE, "LEG_LOOT_ONSPAWN"))
	{
		object oParent = GetLocalObject(oTarget, "SPAWN_Parent");
		if (!GetIsObjectValid(oParent)) oParent = oTarget;
		else if (GetLocalString(oParent, "LEG_LOOT_ID") == "") oParent = oTarget;
		AddScriptParameterObject(oTarget);
		AddScriptParameterObject(oParent);
		ExecuteScriptEnhanced("leg_loot_makeloot", oTarget);
	}
}