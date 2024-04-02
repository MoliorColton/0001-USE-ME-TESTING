// =============================================================
//
//    File: row_mod_loseitem
//    Desc: Rowell's Player Loses an Item
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Jan 26, 2007
// Version: 1.0.0
//
//   Usage: Place this script in the OnUnAcquireItem Event in the Module
//
// =============================================================

#include "row_inc_quest"


void main() {
	object oPC   = GetModuleItemLostBy();
    object oItem = GetModuleItemLost();
	
	Row_ItemLose(oItem);
	RQS_OnLose(oPC, oItem);
	ExecuteScript("x2_mod_def_unaqu", OBJECT_SELF);

		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
	
}