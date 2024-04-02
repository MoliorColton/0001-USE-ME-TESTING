// =============================================================
//
//    File: row_mod_gainitem
//    Desc: Rowell's Player Gains an Item
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Jan 26, 2007
// Version: 1.0.0
//
//   Usage: Place this script in the OnAcquireItem Event in the Module
//
// =============================================================

#include "row_inc_quest"


void main() {
	object oPC = GetModuleItemAcquiredBy();
	
	Row_ItemGain();
	RQS_OnGain(oPC);
	ExecuteScript("x2_mod_def_aqu", OBJECT_SELF);

	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}