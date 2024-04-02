// =============================================================
//
//    File: row_fp_door_transition
//    Desc: Rowell's Fair Play Door - Use/Transition Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 04, 2006
// Updated: Nov 04, 2006
// Version: 1.0.0
//
// =============================================================

#include "ginc_transition"

void main() {
	object oDoor      = OBJECT_SELF;
	object oPC        = GetClickingObject();
	object oTarget	  = GetTransitionTarget(oDoor);
		
	// IF THE AREA TRANSITION EXISTS, TAKE THE USER THERE
	if (oTarget != OBJECT_INVALID) {
		SetAreaTransitionBMP( AREA_TRANSITION_RANDOM );
		AttemptAreaTransition(oPC, oTarget);
		AssignCommand(oTarget, ActionCloseDoor(oTarget));
		

	}
	
}