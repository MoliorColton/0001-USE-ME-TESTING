/*
    Script:			This is the MASTER on death script.  It goes on all Dynamic Placeables, NPC's and monsters or 
					is called from an existing script via ExecuteScript function.  Like all Master Run Scripts, 
					this script examines which plugins are available and active and calls them.
	Version:		1.3
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		12/17/2010 - MV - Added support for Quest Plugin
					12/19/2010 - 1.02 MV - Added support for Info Plugin
					12/21/2010 - 1.03 MV - Added support for Info Criers
					07/08/2011 - 1.04 MV - Added support for Craft Plugin
					09/21/2012 - 1.1 MV - Fixed bug with relation to Loot Plugin
					10/19/2012 - 1.2 MV - Fixed issue that info placeables would play their info on death.
					05/22/2015 - 1.3 MV - Found SE spawns were re-firing before quest plugin could cancel things.  	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Master System for OnDeath events for Legends Modules.  This needs to be called from either the NWN2 stock
	// on death event for mobs/placeables or called from a custom on death event script or optionally called directly AS
	// the on death script.  First we determine if we were passed from another script or if we are called be the event.	
	object oPC = GetLastKiller();
	object oTarget = OBJECT_SELF;
	object oMODULE = GetModule();
	object oINVALID = OBJECT_INVALID;
	
	//Triston script for creatures dying
	//ExecuteScript("tb_mobdeath", oTarget);
	
	if (!GetIsObjectValid(oPC))
	{
		// A PC didn't kill me.  So who did?  Perhaps I was part of a "destroy" event from an SE.  If so, I can safely say the PC
		// involved in the SE killed me.
		oPC = GetLocalObject(oTarget, "SE_PlayerKiller");
	}
	SetLocalObject(oTarget, "XP_Winner", oPC);
	
	// Make sure we are the player and not some familiar
	object oMaster = GetMaster(oPC);
	if (oMaster != oINVALID) oPC = oMaster;

	// Only run these events if the killer was a player. 
	// Well, that seemed like a good idea until we discovered PC's may not kill ESCORTED dudes!
	//if (GetIsPC(oPC) == FALSE) return;
	
	//If the QUEST plugin is active, we have things to do when mobs die!
	if (GetLocalInt(oMODULE, "LEG_QUEST_ACTIVE"))
	{
		ExecuteScript("leg_quest_ondeath", oTarget);
		ExecuteScript("leg_quest_se_ondeath", oTarget);
	}
	
	// If the BANTER Plugin is active.
	if (GetLocalInt(oMODULE, "LEG_BANTER_ACTIVE"))
	{
		string sBanterDeathID = GetLocalString(oTarget, "LEG_BANTER_OnDeath");
		int iBanterDeathChance = GetLocalInt(oTarget, "LEG_BANTER_OnDeathChance");
		AddScriptParameterString(sBanterDeathID);
		AddScriptParameterInt(iBanterDeathChance);
		AddScriptParameterString("Death");
		ExecuteScriptEnhanced("leg_banter_speak", oTarget);
	}
	
	// If we are using the SPAWN Plugin we want to set some respawn times and other things.
	if (GetLocalInt(oMODULE, "LEG_SPAWN_ACTIVE")) ExecuteScriptEnhanced("leg_spawn_ondeath", oTarget);
	
	// If the CRAFT plugin is active, we have things to do when mobs die!
	if (GetLocalInt(oMODULE, "LEG_CRAFT_ACTIVE")) ExecuteScript("leg_craft_ondeath", oTarget);
	
	// If the INFO plugin is active.
	if (GetLocalInt(oMODULE, "LEG_INFO_ACTIVE"))
	{
		if (!GetLocalInt(oTarget, "LEG_INFO_NoDeath"))
		{
			// Fire off any triggers.
			ExecuteScript("leg_info_trigger", oTarget);
			
			// See if we have to add this death event to any criers.
			if (GetLocalInt(oTarget, "LEG_INFO_CrierAddMyDeath"))
			{
				AddScriptParameterString("At " + LEG_COMMON_GetTimeNon24(GetTimeHour(), LEG_COMMON_GetGameTimeMinute()) + " on " + LEG_COMMON_GetMonthName(GetCalendarMonth()) + " " + IntToString(GetCalendarDay()) + ", " + IntToString(GetCalendarYear()));
				AddScriptParameterString(GetName(oPC) + " defeated " + GetName(oTarget) + "!  Well done!");
				AddScriptParameterString("");
				ExecuteScriptEnhanced("leg_info_crieradd", oTarget);
			}
		}	
	}
}