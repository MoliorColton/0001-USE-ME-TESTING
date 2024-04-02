// =============================================================
//
//    File: row_rbs_chk_brw_500
//    Desc: Rowell's Banking System - Borrow on Loan 500gp
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
	int    iCheck      = 500;
	int    iGoldOnLoan = RBS_GetLoanGold(oPC);
	int    iMaxLoan    = iRBS_MaxLoan * GetLevel(oPC);
	
	if (iGoldOnLoan + iCheck <= iMaxLoan )
		return TRUE;
		
	return FALSE;
	
}