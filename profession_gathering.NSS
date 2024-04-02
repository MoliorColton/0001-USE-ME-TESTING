#include "profession_include"
#include "table_farming"




void CheckStump(object oPLANT, object oPC)
{
    int nSKILL = GetSkillRank(SKILL_FARMING, oPC);
    int nChanceToKeepStump;

    if (nSKILL < 10) nChanceToKeepStump = 50;
    else if (nSKILL < 30) nChanceToKeepStump = 25;
    else if (nSKILL < 50) nChanceToKeepStump = 10;
    else if (nSKILL < 70) nChanceToKeepStump = 5;
    else if (nSKILL < 92) nChanceToKeepStump = 3;
    else nChanceToKeepStump = 1;

    if (Random(100) > nChanceToKeepStump) 
    {
        DeleteLocalInt(oPLANT, "PLANT_STAGE");
    }
    else 
    {
        FloatingTextStringOnCreature("This plant is ill. You will need a Plant Cure to harvest it.", oPC, FALSE);
        SetLocalInt(oPLANT, "PLANT_STAGE", 4);
        SetLocalInt(oPLANT, "PLANT_STUMP", TRUE);
    }
}


void HandlePlant(object oPC, object oPLANT, int nSTAGE)
{
	switch (nSTAGE)
	{
		case 1: FloatingTextStringOnCreature("This plant has been recently planted. Compost is needed to make it grow.", oPC, FALSE); break;
		case 2: FloatingTextStringOnCreature("This plant is growing.", oPC, FALSE); break;
		case 3: CheckStump(oPLANT, oPC); break;
		case 4: FloatingTextStringOnCreature("This plant is ill. You will need to use a Plant Cure to harvest it.", oPC, FALSE); break;
	}
}

void main()
{
	object oPC = GetLastUsedBy();
	if (GetIsPC(oPC) == FALSE) return;
	if (GetLocalInt(oPC, "PROF_SKILL") > 0) return;
	object oPOOL = OBJECT_SELF;
	int nSTAGE = GetLocalInt(oPOOL, "PLANT_STAGE");
	if (nSTAGE > 0)
	{
		HandlePlant(oPC, oPOOL, nSTAGE);
		return;
	}
	string sTOOL = GetLocalString(oPOOL, "TOOL");
	string sADD = GetLocalString(oPOOL, "ADD");
	string sWARN = HSS_FEEDBACK_COLOUR + GetLocalString(oPOOL, "WARN");
	int nEQUIP;
	int nLVL = GetLocalInt(oPOOL, "LEVEL");
	int nSKILL = GetLocalInt(oPOOL, "SKILL");
	string sPROF = GetLocalString(oPOOL, "PROF_SKILL");
	string sANIM;
	switch (nSKILL)
	{
		case SKILL_FISHING: 
			sPROF = "Fishing"; 
			sANIM = "fishrod"; 
			if (sADD == "") sANIM = "getground"; 
			break;
		case SKILL_MINING:
			sPROF = "Mining";
			sANIM = "*1attack01";
			nEQUIP = TRUE;
			break;
		case SKILL_WOODCUTTING: 
			sPROF = "Woodcutting";
			sANIM = "*1attack02";
			nEQUIP = TRUE;
			break;
		case SKILL_THIEVING: 
			sPROF = "Thieving"; 
			sANIM = "openlockloop"; 
			nEQUIP = FALSE;
			break;
		default: SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "An error occurred: the resource node is not linked to any gathering profession."); 
	}
	SetLocalString(oPC, "PROF_SOUND", sPROF);
	int nSKILLRANK = GetSkillRank(nSKILL, oPC);
	if (nSKILLRANK < nLVL)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need at least " + IntToString(nLVL) + " levels in " + sPROF + " to do this.");
		return;
	}
	object oINVALID = OBJECT_INVALID;
	object oTOOL = GetItemPossessedBy(oPC, sTOOL);
	if (nEQUIP == TRUE)
	{
		oTOOL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		if (GetTag(oTOOL) != sTOOL)
		{
			oTOOL = oINVALID;
			sWARN = sWARN + " (The tool has to be equipped)";
		}
	}
	object oADD = GetItemPossessedBy(oPC, sADD);
	if ((sTOOL != "") && (oTOOL == oINVALID)) SendMessageToPC(oPC, sWARN);
	else if ((sADD != "") && (oADD == oINVALID)) SendMessageToPC(oPC, sWARN);
	else 
	{
		string sTEXT;
		float fTOOL = IntToFloat(GetLocalInt(oTOOL, "QUALITY") * 2);
		float fMASTER = IntToFloat(nSKILLRANK - nLVL);
		if (fMASTER > 20.0) fMASTER = 20.0;
		float fDIV = 5.0;
		float fLOOP = 20.0 - fTOOL - fMASTER;
		if (fLOOP < 4.0) fLOOP = 4.0; 
		
		switch(nSKILL)
		{
		case SKILL_FISHING: fDIV = 1.25; fMASTER = fMASTER / fDIV; 	
		break;
		}

		SetLocalInt(oPC, "PROF_SKILL", nSKILL);
		SetLocalFloat(oPC, "PROF_LOOP", fLOOP);
		BeginProfessionLoop(oPC, oPOOL, sTEXT, sANIM);

	}
}