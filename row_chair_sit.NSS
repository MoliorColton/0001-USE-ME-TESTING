// =============================================================
//
//    File: row_chair_sit
//    Desc: Rowell's Usable Sitting Chair
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 04, 2006
// Updated: Nov 04, 2006
// Version: 1.0.0
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oChair = OBJECT_SELF;
	object oPC    = GetLastUsedBy();
	
	SendMessageToPC(oPC, GetName(oPC) + " is Using/Sitting on " + GetName(oChair));
	SpeakString(GetName(oPC) + " is Using/Sitting on " + GetName(oChair));
//	AssignCommand(oPC, ActionSit(oChair));

}

