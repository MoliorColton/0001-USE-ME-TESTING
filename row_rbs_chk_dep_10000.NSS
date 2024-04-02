// =============================================================
//
//    File: row_rbs_chk_dep_10000
//    Desc: Rowell's Banking System - Deposit 10000gp
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 16, 2006
// Updated: Nov 16, 2006
// Version: 1.0.0
//
// =============================================================

#include "row_inc_banking"


int StartingConditional() {
	object oPC         = GetLastSpeaker();
	int    iCheck      = 10000;
	int    iGoldInBank = RBS_GetSavedGold(oPC);
	
	if (GetGold(oPC) >= iCheck && iGoldInBank + iCheck <= iRBS_MaxDeposit )
		return TRUE;
		
	return FALSE;
	
}