// =============================================================
//
//    File: row_rbs_init
//    Desc: Rowell's Banking System - Initialize Banking System for PC
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 16, 2006
// Updated: Nov 16, 2006
// Version: 1.0.0
//
// =============================================================

#include "row_inc_banking"


void main() {
	object oPC = GetPCSpeaker();

	RBS_InitCharacter(oPC);	
	
}