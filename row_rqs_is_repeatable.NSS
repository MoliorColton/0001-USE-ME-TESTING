// =============================================================
//
//    File: row_rqs_is_repeatable
//    Desc: Rowell's Quest System - Conversation Check: Is Quest Repeatable (after it is finished)??
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 18, 2007
// Updated: Jan 23, 2007
// Version: 1.0.0
//
//   Usage: 
//          NOTE: Database functionality is needed for this to work.
//
// =============================================================

#include "row_inc_quest"


int StartingConditional() {
    object oNPC     = OBJECT_SELF;
	int    iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
		
	return RQS_isQuestRepeatable(iQuestID);

		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}