// =============================================================
//
//    File: row_rqs_on_spawn
//    Desc: Rowell's Quest System - Event: On Spawn Event for Quest Creature Encounters
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 26, 2007
// Updated: Jan 26, 2007
// Version: 1.0.0
//
//   Usage: 
//          NOTE: Database functionality is needed for this to work.
//
// =============================================================

#include "row_inc_quest"


void main() {
	object oPC      = GetEnteringObject();
	object oNPC     = OBJECT_SELF;
	
	RQS_OnSpawn(oPC, oNPC);
		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}