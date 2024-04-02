#include "nw_i0_spells"
#include "shop_include"


void CloseInterface(object oPC)
{

	DeleteLocalString(oPC, "OUTPUT_TAG");
	DeleteLocalString(oPC, "INPUT_TAG_A");
	DeleteLocalString(oPC, "INPUT_TAG_B");
	DeleteLocalInt(oPC, "INPUT_QTY_A");
	DeleteLocalInt(oPC, "INPUT_QTY_B");
	DeleteLocalInt(oPC, "OUTPUT_QTY");
	DeleteLocalInt(oPC, "OUTPUT_MULT");
	DeleteLocalInt(oPC, "OUTPUT_REQ");
	DeleteLocalInt(oPC, "OUTPUT_STOP");


	DeleteLocalFloat(oPC, "PROF_TIME");
	DeleteLocalFloat(oPC, "PROF_LOOP");
	RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oPC);
	CloseGUIScreen(oPC, "SCREEN_SHOP_LOOP");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));
}

void RespawnNode(int nPOOL, string sPOOL, location lPOOL)
{
	object oNODE = CreateObject(nPOOL, sPOOL, lPOOL, TRUE);
}

void GatherResource(object oPC)
{
	if (GetInventoryNum(oPC) > 127)
	{
		SendMessageToPC(oPC, "Your inventory is full.");
		CloseInterface(oPC);
		return;
	}
	
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
    int nQTY_A = GetLocalInt(oPC, "INPUT_QTY_A");
    string sFAIL = GetLocalString(oPC, "FAIL_TAG");
    string sOUTPUT = GetLocalString(oPC, "OUTPUT_TAG");
    int nMULT = GetLocalInt(oPC, "OUTPUT_MULT");
    int nGOLD = GetLocalInt(oPC, "INPUT_QTY_A");
	int nGoldOnHand = GetGold(oPC);
    //
    if (nGoldOnHand < nGOLD)
    {
        SendMessageToPC(oPC, "You don't have enough currency for this transaction");
        CloseInterface(oPC);
        return;
    }
		else
    //		TakeGoldFromCreature(nQTY_A, oPC, TRUE); //
    {
        int nQTY = GetLocalInt(oPC, "OUTPUT_QTY");
        if (nQTY < 1) nQTY = 1;
	 	CreateItemOnObject(sOUTPUT, oPC, nQTY); 
		
	}	

	{
  		RemoveItems(oPC, sINPUT_A, nQTY_A);
		TakeGoldFromCreature(nQTY_A, oPC, TRUE);
		SetLocalInt(oPC, "OUTPUT_MULT", nMULT - 1);
		if (nMULT <= 1) CloseInterface(oPC);
		
    
	}

}

void UpdateInterface(object oPC)
{
	int nSKILL = GetLocalInt(oPC, "PROF_SKILL");
	object oPOOL = OBJECT_SELF;
	string sTEXT = "Buying...";
	float fLOOP = 2.0;
		
	
	SetGUIObjectText(oPC, "SCREEN_PROF_LOOP", "LOOP_TEXT", -1, sTEXT);
	float fTIME = GetLocalFloat(oPC, "PROF_TIME") + 0.1;
	float fBAR = fTIME / fLOOP;
	if (fBAR >= 2.0)
	{
		fBAR = 2.0;
		fTIME = 2.0;
		switch (nSKILL)
		{
			case SKILL_FISHING:
			case SKILL_WOODCUTTING:
			case SKILL_MINING:
				GatherResource(oPC);
				break;
			default: ProduceItem(oPC);
		}
	}
	SetGUIProgressBarPosition(oPC, "SCREEN_SHOP_LOOP", "GATHER_PROGRESS", fBAR);
	SetLocalFloat(oPC, "PROF_TIME", fTIME);
}

void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;

	if (sCOMMAND == "UPDATE") UpdateInterface(oPC);
	else CloseInterface(oPC);
}