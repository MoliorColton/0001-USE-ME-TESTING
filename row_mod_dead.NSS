// =============================================================
//
//    File: row_mod_dead
//    Desc: Rowell's Player Died Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Feb 06, 2007
// Version: 1.0.4
//
//   Usage: Place this script in the OnPlayerDeath Event in the Module
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC  = GetLastPlayerDied();
	object oNPC = GetLastKiller();
	
	
	if (GetIsPC(oPC)) {
		Row_PlayerDead(oPC, oNPC);
		ExecuteScript("nw_o0_death", oPC);
	}
		

	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================

		
}