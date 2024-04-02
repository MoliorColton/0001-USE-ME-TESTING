#include "bosschest_include"

//The Main Differences are with the profession_production script used in convos are the following:
//1 - arguments HAVE TO BE STRINGS. UI in NWN2 can only take STRING variables as arguments.
//2 - POOLS have to be specified by TAGS, if any. (for example with Furnace).
//3 - The Skill requirement as to be specified as well in the arguments
//4 - POOLS and REQs have been added as arguments BEFORE sOUTPUT, so it should be easier to copy from convo.
//Refer to the fletching xml to see how it was implemented on the "OnLeftClick=UIObject_Misc_ExecuteServerScript" lines.

void main(string sPOOL, string sREQ, string sOUTPUT_A, string sOUTPUT_B, string sOUTPUT_C, string sMULT, string sSKILL, string sXP, string sTAG_A, string sQTY_A, string sTAG_B, string sQTY_B, string sSUCCESS_CHANCE, string sSUCCESS_CHANCE_A, string sFAIL_PRODUCT, string sQTY_O)
{
	object oPC = OBJECT_SELF;
        if (sOUTPUT_A == "runite")
    {
        int nQUEST = GetJournalEntry("28", oPC);
        if ((nQUEST !=20) && (nQUEST != 20))
        {
            SendMessageToPC(oPC, "You must have completed the quest to be able to loot this chest.");
            return;
        }
    }
	object oINVALID = OBJECT_INVALID;
	object oPOOL = oINVALID;
	if (sPOOL != "")
	{
		oPOOL = GetNearestObjectByTag(sPOOL, oPC);
		string sNAME_POOL = GetName(oPOOL);		
	}
	string sANIM = "openlock";
	string sSOUND;
	int nSKILL = StringToInt(sSKILL);
	switch (nSKILL)
	{
		case SKILL_BARROWS: sSOUND = ""; sANIM = "openlock"; break;
		default: return;
	}
	SetLocalString(oPC, "INPUT_TAG_A", sTAG_A);
	SetLocalString(oPC, "INPUT_TAG_B", sTAG_B);
	SetLocalString(oPC, "OUTPUT_TAG_A", sOUTPUT_A);
	SetLocalString(oPC, "OUTPUT_TAG_B", sOUTPUT_B);
	SetLocalString(oPC, "OUTPUT_TAG_C", sOUTPUT_C);
	SetLocalString(oPC, "FAIL_TAG", sFAIL_PRODUCT);
	SetLocalInt(oPC, "PROF_SKILL", nSKILL);
	SetLocalInt(oPC, "INPUT_QTY_A", StringToInt(sQTY_A));
	SetLocalInt(oPC, "INPUT_QTY_B", StringToInt(sQTY_B));
	SetLocalInt(oPC, "SUCCESS_CHANCE", StringToInt(sSUCCESS_CHANCE));
	SetLocalInt(oPC, "SUCCESS_CHANCE_A", StringToInt(sSUCCESS_CHANCE_A));
	SetLocalInt(oPC, "OUTPUT_XP", StringToInt(sXP));
	SetLocalInt(oPC, "OUTPUT_MULT", StringToInt(sMULT));
	SetLocalInt(oPC, "OUTPUT_QTY", StringToInt(sQTY_O));
	BeginProfessionLoop(oPC, oPOOL, sSOUND, sANIM);
}