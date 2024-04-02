// =============================================================
//
//    File: row_rqs_is_not_complete
//    Desc: Rowell's Quest System - Conversation Check: Quest is NotComplete
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 18, 2007
// Updated: Jan 18, 2007
// Version: 1.0.0
//
//   Usage: 
//          NOTE: Database functionality is needed for this to work.
//
// =============================================================

#include "row_inc_quest"


int StartingConditional() {
	object oPC      = GetLastSpeaker();
    object oNPC     = OBJECT_SELF;
	int    iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	
	return (RQS_isQuestComplete(oPC, iQuestID) == FALSE);

		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}
