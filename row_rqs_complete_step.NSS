// =============================================================
//
//    File: row_rqs_complete_step
//    Desc: Rowell's Quest System - Mark a Step of a Quest Completed.
//									Force an entire Quest to be marked as Completed.
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 18, 2007
// Updated: Jan 18, 2007
// Version: 1.0.0
//
//   Usage: This script will force either Part of a Quest, or an Entire Quest 
//			to be marked as COMPLETE.  You define the Player (oPC) by using any
//			of the NWN functions to get a Player Object (ie GetPCSpeaker(), GetLastKiller(), etc)
//			If you force the oNPC object to be OBJECT_INVALID, the ENTIRE QUEST will be marked as complete, and
//			do NOT save those changes to this template; make a new script with your changes.
//          NOTE: Database functionality is needed for this to work.
//
// =============================================================

#include "row_inc_quest"


void main() {
	object oPC      = GetPCSpeaker();
	object oNPC     = OBJECT_SELF;			// Change to OBJECT_INVALID to mark entire Quest completed.
											// If oNPC = OBJECT_INVALID, set iQuestID to be the QuestID
	int    iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	
	RQS_CompleteQuest(oPC, iQuestID, oNPC);

		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}


// ==== ORIGINAL CODE (DO NOT DELETE) ====================================================
//	object oPC      = GetPCSpeaker();
//	object oNPC     = OBJECT_SELF;			// Change to OBJECT_INVALID to mark entire Quest completed.
											// If oNPC = OBJECT_INVALID, set iQuestID to be the QuestID
//	int    iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	
//	RQS_CompleteQuest(oPC, iQuestID, oNPC);
