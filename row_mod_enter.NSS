// =============================================================
//
//    File: row_mod_enter
//    Desc: Rowell's Player Enters Module Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Nov 06, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnClientEnter Event in the Module
//
// =============================================================

#include "row_inc_quest"


void main() {
	object oPC = GetEnteringObject();
			
	if (GetIsPC(oPC)) {
		Row_ModuleEnter(oPC);
		Row_ModulePlayerLoaded(oPC);
		RQS_PlayerEnter(oPC);
	}

	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
		
}