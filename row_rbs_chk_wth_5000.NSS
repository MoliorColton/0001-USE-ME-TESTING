// =============================================================
//
//    File: row_rbs_chk_wth_5000
//    Desc: Rowell's Banking System - Withdraw 5000gp
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
	int    iCheck      = 5000;
	int    iGoldInBank = RBS_GetSavedGold(oPC);
	
	if (iGoldInBank >= iCheck)
		return TRUE;
		
	return FALSE;
	
}