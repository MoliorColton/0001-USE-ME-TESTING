/*

    Script:			Called by the LOOT plugin.  Sometimes we have loot chests that are spawned from a quest.
					If that chest is looted, then we need to clear the quest spawns table.  This is the same
					as when a player kills a quest mob that's spawned based on a quest except this happens
					when the chest is looted.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		05/18/2015 - 1.00 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oParent)
{
	// If I was spawned due to a quest, then clear that up so I don't spawn again.  Loot or no loot, I only spawn once for this player
	// and now that they've opened me, make sure I don't spawn for them again.  Called from the LOOT plugin on-opened. 
	string sWPTag = GetTag(oParent);
	
	// If this PC needed this chest, then clear up the spawner in the table for them now that they've opened it.
	if (GetLocalInt(oParent, "LEG_SPAWN_QuestBased") && GetLocalInt(oPC, sWPTag))
	{
		SetLocalInt(oParent, "LEG_SPAWN_TriggerSpawn", 1);
		SetLocalInt(oPC, sWPTag, 0);
		DeletePersistentVariable(oPC, sWPTag, QUESTPREFIX + "_questspawns");
	}	


}