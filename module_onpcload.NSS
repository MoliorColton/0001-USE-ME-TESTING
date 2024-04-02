#include "nw_i0_spells"

const int QUEST_LIMIT = 50;


void CreateEssence(object oPC)
{
	object oITEM = CreateItemOnObject("player_essence", oPC, 1, "", FALSE);
	if (oITEM == OBJECT_INVALID)
	{
		FloatingTextStringOnCreature("<color=red>ERROR: your player essence was not created successfully. Please make sure that you have free space in your inventory and relog.", oPC, FALSE, 60.0);
		return;
	}
	SetFirstName(oITEM, GetFirstName(oPC) + "'s essence");
	int nCOUNT = 1;
	int nQUEST;
	string sQUEST;
	while (nCOUNT <= QUEST_LIMIT)
	{
		sQUEST = IntToString(nCOUNT);
		nQUEST = GetJournalEntry(sQUEST, oPC);
		if (nQUEST > 0) SetLocalInt(oITEM, "QUEST_" + sQUEST, nCOUNT);
		nCOUNT = nCOUNT + 1;
	}
}

void UpdateQuests(object oPC, object oITEM)
{
	int nCOUNT = 1;
	int nSTEP;
	string sQUEST;
	while (nCOUNT <= QUEST_LIMIT)
	{
		sQUEST = IntToString(nCOUNT);
		nSTEP = GetLocalInt(oITEM, "QUEST_" + sQUEST);
		if (nSTEP > 0) AddJournalQuestEntry(sQUEST, nSTEP, oPC, FALSE);
		nCOUNT = nCOUNT + 1;
	}
}

void TeleportToLastLocation(object oPC, object oESSENCE)
{
	object oAREA = GetArea(oPC);
	if (GetTag(oAREA) != "unknown") return;
	location lLAST = GetLocalLocation(oESSENCE, "LAST_LOCATION");
	if (GetIsLocationValid(lLAST) == TRUE) AssignCommand(oPC, JumpToLocation(lLAST));
}

void FixStuck(object oPC, object oESSENCE)
{
	int nFOUND;
	int nTYPE;
	effect eFX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eFX))
    {
		nFOUND = FALSE;
		nTYPE = GetEffectType(eFX);
		switch (nTYPE)
		{
			case EFFECT_TYPE_CUTSCENE_PARALYZE:
			case EFFECT_TYPE_CUTSCENEGHOST:
			case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
				RemoveEffect(oPC, eFX);
				nFOUND = TRUE;
				break;		
		}
		if (nFOUND == TRUE) eFX = GetFirstEffect(oPC);
		else eFX = GetNextEffect(oPC);
    }
	DelayCommand(0.1, TeleportToLastLocation(oPC, oESSENCE));
}

void UpdateSkills(object oPC, object oESSENCE)
{
	int nSKILLS = GetNum2DARows("skills");
	int nSKILL = 29;
	while (nSKILL < nSKILLS)
	{
		if (GetSkillRank(nSKILL, oPC, TRUE) < 1) SetBaseSkillRank(oPC, nSKILL, 1, FALSE);
		nSKILL = nSKILL + 1;
	}
	DelayCommand(0.1, FixStuck(oPC, oESSENCE));
}

int CheckCDKey(object oPC)
{
	int nRETURN = FALSE;
	string sKEY = GetPCPublicCDKey(oPC);
	string sPLAYER = GetPCPlayerName(oPC);
	string sMSG = "Player Account: " + sPLAYER + " - Public CD Key: " + sKEY;
	string sDATA = "cd_keys";
	string sVAR = GetCampaignString(sDATA, sPLAYER);
	if (sVAR == sKEY) sMSG = sMSG + " - Welcome back.";
	else if (sVAR == "")
	{
		sMSG = sMSG + " - This account has just been associated to its unique CD key to protect you from account theft.";
		SetCampaignString(sDATA, sPLAYER, sKEY);
	}
	else
	{
		sMSG = sMSG + " - This account has already been registered under another CD key. You will be booted from server in 10 seconds. If you believe that this is a mistake (or if you recently changed the CD key and wish to resume playing this account), please contact the server admin.";
		nRETURN = TRUE;
	}
	SendMessageToPC(oPC, sMSG);
	return nRETURN;
}

void main()
{
	SetGlobalInt("HPBARSSTATE", 1);
	object oPC = GetEnteringObject();
	if (CheckCDKey(oPC) == TRUE)
	{
		DelayCommand(5.0, BootPC(oPC));
		return;
	}
	object oINVALID = OBJECT_INVALID;
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	if (oESSENCE == oINVALID) CreateEssence(oPC);
	else UpdateQuests(oPC, oESSENCE);
	object oTHIEF = GetItemPossessedBy(oPC, "thieftools");
	if (oTHIEF == oINVALID) CreateItemOnObject("thieftools", oPC);
	DelayCommand(0.1, UpdateSkills(oPC, oESSENCE));
}