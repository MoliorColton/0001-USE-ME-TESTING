// =============================================================
//
//    File: row_area_enter
//    Desc: Rowell's Player Enters Area Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Nov 06, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnClientEnter Event in all Areas
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC = GetEnteringObject();
			
	if (GetIsPC(oPC)) {
		if (GetTag(GetArea(oPC)) == GetTag(GetAreaFromLocation(GetStartingLocation())))
			Row_ModulePlayerLoaded(oPC);
		else
			Row_AreaEnter(oPC);
			
		// USE CUSTOM LIGHTING SYSTEM - (IE TURN LAMPS/TORCHS ON/OFF DURING THE NIGHT/DAY)
		if (GetLocalInt(OBJECT_SELF, "USE_LIGHTING"))
			ExecuteScript("row_area_enter_light", OBJECT_SELF);
			
	}

	
	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================

		
}