// =============================================================
//
//    File: row_obj_bind_altar
//    Desc: Rowell's Soul Binding Altar
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 11, 2006
// Updated: Nov 11, 2006
// Version: 1.0.0
//
//   Usage: This Script attaches to a useable Placeable.
//          When the Placeable is used, the character's soul is
//          bound to the Altar.  When the character dies and respawns,
//          they ressurrect at the altar that they are bound to.
//          NOTE: Database functionality is needed for this to work.
//
// =============================================================

#include "row_inc_functions"


void main() {
	object oPC = GetLastUsedBy();
	
	Row_BindAltar(OBJECT_SELF, oPC);
	
}