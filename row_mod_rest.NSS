// =============================================================
//
//    File: row_mod_rest
//    Desc: Rowell's Player Rest Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Nov 06, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnPlayerRest Event in the Module
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC = GetLastPCRested();
	
	if (GetIsPC(oPC))
			Row_PlayerRest(oPC);

		
			
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
		
}