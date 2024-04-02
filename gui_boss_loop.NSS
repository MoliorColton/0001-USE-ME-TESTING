#include "nw_i0_spells"
#include "bosschest_include"

void CloseInterface(object oPC)
{
	DeleteLocalObject(oPC, "PROF_POOL");
	DeleteLocalString(oPC, "PROF_SOUND");
	DeleteLocalString(oPC, "FAIL_TAG");
	DeleteLocalString(oPC, "OUTPUT_TAG_A");
	DeleteLocalString(oPC, "OUTPUT_TAG_B");
	DeleteLocalString(oPC, "OUTPUT_TAG_C");
	DeleteLocalString(oPC, "INPUT_TAG_A");
	DeleteLocalString(oPC, "INPUT_TAG_B");
	DeleteLocalInt(oPC, "INPUT_QTY_A");
	DeleteLocalInt(oPC, "INPUT_QTY_B");
	DeleteLocalInt(oPC, "OUTPUT_QTY");
	DeleteLocalInt(oPC, "OUTPUT_MULT");
	DeleteLocalInt(oPC, "OUTPUT_REQ");
	DeleteLocalInt(oPC, "OUTPUT_STOP");
	DeleteLocalInt(oPC, "OUTPUT_XP");
	DeleteLocalInt(oPC, "PROF_SKILL");
	DeleteLocalInt(oPC, "SUCCESS_CHANCE");
	DeleteLocalInt(oPC, "SUCCESS_CHANCE_A");
	DeleteLocalFloat(oPC, "PROF_TIME");
	DeleteLocalFloat(oPC, "PROF_LOOP");
	RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oPC);
	CloseGUIScreen(oPC, "SCREEN_BOSSCHEST_LOOP");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));
}



void ProduceItem(object oPC)
{
	if (GetInventoryNum(oPC) >= 128)
	{
		SendMessageToPC(oPC, "Your inventory is full.");
		CloseInterface(oPC);
		return;
	}
	string sINPUT_A = GetLocalString(oPC, "INPUT_TAG_A");
	string sINPUT_B = GetLocalString(oPC, "INPUT_TAG_B");
	int nQTY_A = GetLocalInt(oPC, "INPUT_QTY_A");
	int nQTY_B = GetLocalInt(oPC, "INPUT_QTY_B");
	if (GetItemQuantity(oPC, sINPUT_A) < nQTY_A)
	{
		SendMessageToPC(oPC, "You are missing a key.");
		CloseInterface(oPC);
		return;
	}
	if (GetItemQuantity(oPC, sINPUT_B) < nQTY_B)
	{
		SendMessageToPC(oPC, "You are missing a key.");
		CloseInterface(oPC);
		return;
	}
	
	string sFAIL = GetLocalString(oPC, "FAIL_TAG");
	string sOUTPUT_A = GetLocalString(oPC, "OUTPUT_TAG_A");
	string sOUTPUT_B = GetLocalString(oPC, "OUTPUT_TAG_B");
	string sOUTPUT_C = GetLocalString(oPC, "OUTPUT_TAG_C");
	int nSKILL = GetLocalInt(oPC, "PROF_SKILL");
	int nFAIL = 970;
	int nMULT = GetLocalInt(oPC, "OUTPUT_MULT");
	int nXP = GetLocalInt(oPC, "OUTPUT_XP");
	string sTXT = "You found nothing this time...";
	GiveCraftXP(oPC, nSKILL, nXP);


	if (nFAIL < 1) nFAIL = 0;
	if (1 + Random(1000) > nFAIL)
	{
		int nQTY = GetLocalInt(oPC, "OUTPUT_QTY");
		if (nQTY < 1) nQTY = 1;
		CreateItemOnObject(sOUTPUT_A, oPC, nQTY);
	}
	
	
	else
	{
		string sBURN = IntToString(nFAIL);
		int nFIG = 3;
		if (nFAIL < 1000) nFIG = 2;
		if (nFAIL < 100) nFIG = 1;
		string sRATE = GetStringLeft(sBURN, nFIG);
		if (nFAIL < 10) sRATE = "0";
		sRATE = sRATE + "." + GetStringRight(sBURN, 1) + "%";
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sTXT);
		if (sFAIL != "") CreateItemOnObject(sFAIL, oPC, 1);
	}
	
	
	RemoveItems(oPC, sINPUT_A, nQTY_A);
	RemoveItems(oPC, sINPUT_B, nQTY_B);
	SetLocalInt(oPC, "OUTPUT_MULT", nMULT - 1);
	if (nMULT <= 1) CloseInterface(oPC);
	
}

void UpdateInterface(object oPC)
{
	int nSKILL = GetLocalInt(oPC, "PROF_SKILL");
	string sTEXT = "Unlocking";
	float fLOOP = 1.0;
	switch (nSKILL)
	{
		case SKILL_BARROWS:	sTEXT = "unlocking...";	break;
	}
	SetGUIObjectText(oPC, "SCREEN_BOSSCHEST_LOOP", "LOOP_TEXT", -1, sTEXT);
	float fTIME = GetLocalFloat(oPC, "PROF_TIME") + 0.1;
	float fBAR = fTIME / fLOOP;
	if (fBAR >= 1.00)
	{
		fBAR = 1.0;
		fTIME = 0.0;
		switch (nSKILL)
		{
	
			default: ProduceItem(oPC);
		}
	}
	SetGUIProgressBarPosition(oPC, "SCREEN_BOSSCHEST_LOOP", "GATHER_PROGRESS", fBAR);
	SetLocalFloat(oPC, "PROF_TIME", fTIME);
}

void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	if (sCOMMAND == "UPDATE") UpdateInterface(oPC);
	else CloseInterface(oPC);
}