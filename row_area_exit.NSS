// =============================================================
//
//    File: row_area_exit
//    Desc: Rowell's Player Leaves Area Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Nov 06, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnClientExits Event in all Areas
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC = GetExitingObject();
		
	if (GetIsPC(oPC))
		Row_AreaExit(oPC);
		
	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================

	
}