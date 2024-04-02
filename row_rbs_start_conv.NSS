// =============================================================
//
//    File: row_rbs_start_conv
//    Desc: Rowell's Banking System - Re-Start the Banker Conversation
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 17, 2006
// Updated: Nov 17, 2006
// Version: 1.0.0
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC  = GetPCSpeaker();
	object oNPC = OBJECT_SELF;
	
	AssignCommand(oPC, ActionStartConversation(oNPC, "row_rbs_banker", TRUE, FALSE));
	
}