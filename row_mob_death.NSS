// =============================================================
//
//    File: row_mob_death
//    Desc: Rowell's Creature Death Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Feb 06, 2007
// Version: 1.0.4
//
//   Usage: Place this script in the OnDeath Event of Creatures
//
// =============================================================

#include "row_inc_factions"
#include "row_inc_quest"
#include "x2_inc_compon"
#include "x0_i0_spawncond"

void main() { 
	object oPC    = GetLastKiller();
	object oNPC   = OBJECT_SELF;
    int    nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int    nAlign = GetAlignmentGoodEvil(oNPC);

		
	string sDeathScript = GetLocalString(oNPC, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, oNPC);

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
        AdjustAlignment(oPC, ALIGNMENT_EVIL, 5);

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    craft_drop_items(oPC);

	// HANDLE NPC DEATH COUNT INCREMENT
	IncreaseNPCdeaths(oNPC);
	
	// HANDLE FACTION CHANGES (IF APPLICABLE)
	RFS_ProcessNPC(oPC, oNPC, "kill");
	
	// HANDLE QUEST CHANGES (IF APPLICABLE)
	RQS_OnKill(oPC, oNPC);

	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}