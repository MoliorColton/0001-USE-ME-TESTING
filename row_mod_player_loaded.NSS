// =============================================================
//
//    File: row_mod_player_loaded
//    Desc: Rowell's Player Completely Loaded Module Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Nov 06, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnPCLoaded Event in the Module
//
// =============================================================

#include "row_inc_banking"


void main() {
	object oPC = GetEnteringObject();
	SetLocalInt(oPC, "OKAY_TO_PORT", 1);
		
	// APPLY INTEREST TO CHARACTER BANK ACCOUNTS  (IF APPLICABLE)
	RBS_SavingsInterest(oPC);
	RBS_LoanInterest(oPC);
	
	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
	
		
}