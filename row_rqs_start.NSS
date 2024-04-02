// =============================================================
//
//    File: row_rqs_start
//    Desc: Rowell's Quest System - Start a Quest
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


void main() {
	object oPC      = GetPCSpeaker();
	object oNPC     = OBJECT_SELF;
	int    iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	
	RQS_StartQuest(oPC, iQuestID, oNPC);

		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}