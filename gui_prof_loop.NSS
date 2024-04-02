#include "nw_i0_spells"
#include "profession_include"


// Define a global variable to keep track of the number of times the function has been called
int g_timesCalled = 0;


void CloseInterface(object oPC)
{
	DeleteLocalObject(oPC, "PROF_POOL");
	DeleteLocalString(oPC, "PROF_SOUND");
	DeleteLocalString(oPC, "FAIL_TAG");
	DeleteLocalString(oPC, "OUTPUT_TAG");
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
	DeleteLocalFloat(oPC, "PROF_TIME");
	DeleteLocalFloat(oPC, "PROF_LOOP");
	RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oPC);
	CloseGUIScreen(oPC, "SCREEN_PROF_LOOP");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));
}

void RespawnNode(int nPOOL, string sPOOL, location lPOOL)
{
    object oNODE = CreateObject(nPOOL, sPOOL, lPOOL, TRUE);
    SetLocalInt(oNODE, "TIMES_CALLED", 0);
}



void RespawnNodeMaxCalls(int nPOOL, string sPOOL, location lPOOL, int minCalls, int maxCalls)
{
    object oNODE = CreateObject(nPOOL, sPOOL, lPOOL, TRUE);
    SetLocalInt(oNODE, "TIMES_CALLED", 0);
    SetLocalInt(oNODE, "MAX_CALLS", maxCalls); 
    SetLocalInt(oNODE, "MIN_CALLS", minCalls); // Set the minimum number of calls

	// Get a random number between MIN_CALLS and MAX_CALLS
	int nResources = Random(maxCalls - minCalls + 1) + minCalls;

    // Store nResources in the object
    SetLocalInt(oNODE, "RESOURCES", nResources);
}


void HandleConcentratedResource(object oPC, object oPOOL, int nSKILL, int nXP, string sDROP, int nCHANCE)
{
	
    int nTimesCalled = GetLocalInt(oPOOL, "TIMES_CALLED");
    int maxCalls = GetLocalInt(oPOOL, "MAX_CALLS"); 
    int minCalls = GetLocalInt(oPOOL, "MIN_CALLS");
    int nResources = GetLocalInt(oPOOL, "RESOURCES");
	
    string sResourceName = GetName(oPOOL);
	
	if (nResources == 0)
    {
		if (nTimesCalled < 1)
		{
    		if (GetSkillRank(SKILL_MINING, oPC) >= 62)
    			{
       				 SendMessageToPC(oPC, "You prospect that this vein contains " + IntToString(maxCalls) + " ore.");
    			}
				else
				{
       				 SendMessageToPC(oPC, "You need level 62 Mining to prospect how much ore is in this " + sResourceName + ".");
    			}
		}


        // Check if half of the maximum calls are met
		if (nTimesCalled == (maxCalls + 1) / 2)
		{
    	SendMessageToPC(oPC, "It looks like roughly half of this " + sResourceName + " ore remains...");
		}

        // Check if the function has been called the maximum number of times
        if (nTimesCalled == maxCalls -1)
        {
            CloseInterface(oPC);
            float fRESPAWN = GetLocalFloat(oPOOL, "RESPAWN");
            SendMessageToPC(oPC, "The " + sResourceName + " has been depleted.");
            int nPOOL = GetObjectType(oPOOL);
            string sPOOL = GetTag(oPOOL);
            location lPOOL = GetLocation(oPOOL);

            // Respawn a new node with a random maxCalls value
            DelayCommand(fRESPAWN, RespawnNodeMaxCalls(nPOOL, sPOOL, lPOOL, minCalls, maxCalls));
            DestroyObject(oPOOL);
			int nTimesCalled = 0;  // Reset nTimesCalled to 0
        }
    }
    else
    {
		if (nTimesCalled < 1)
		{
    		if (GetSkillRank(SKILL_MINING, oPC) >= 62)
    			{
       				 SendMessageToPC(oPC, "You prospect that this vein contains " + IntToString(nResources) + " ore.");
    			}
				else
				{
       				 SendMessageToPC(oPC, "You need level 62 Mining to prospect how much ore is in this " + sResourceName + ".");
    			}
		}

        // Check if half of the maximum calls are met
		if (nTimesCalled == (nResources + 1) / 2)
		{
    	SendMessageToPC(oPC, "It looks like roughly  half of this " + sResourceName + " ore remains...");
		}

        // Check if the function has been called the maximum number of times
        if (nTimesCalled == (nResources - 1))
        {
            CloseInterface(oPC);
            float fRESPAWN = GetLocalFloat(oPOOL, "RESPAWN");
            SendMessageToPC(oPC, "The " + sResourceName + " has been depleted.");
            int nPOOL = GetObjectType(oPOOL);
            string sPOOL = GetTag(oPOOL);
            location lPOOL = GetLocation(oPOOL);

            // Respawn a new node with a random maxCalls value
            DelayCommand(fRESPAWN, RespawnNodeMaxCalls(nPOOL, sPOOL, lPOOL, minCalls, maxCalls));
            DestroyObject(oPOOL);
			int nTimesCalled = 0;  // Reset nTimesCalled to 0
        }
    }

    // Increment the counter and store it back in the local variable
    nTimesCalled++;
    SetLocalInt(oPOOL, "TIMES_CALLED", nTimesCalled);

    // Rest of your existing code goes here...
    ReallyPlaySound(GetLocation(oPC), GetLocalString(oPC, "PROF_SOUND"));
    GiveCraftXP(oPC, nSKILL, nXP);
    CreateItemOnObject(sDROP, oPC);
}






void GatherResource(object oPC)

{
	if (GetInventoryNum(oPC) > 127)
	{
		SendMessageToPC(oPC, "Your inventory is full.");
		CloseInterface(oPC);
		return;
	}
	object oPOOL = GetLocalObject(oPC, "PROF_POOL");
	// concentrated tag fetch
	string sPOOLTag = GetTag(oPOOL);
	string sADD = GetLocalString(oPOOL, "ADD");
	object oADD = GetItemPossessedBy(oPC, sADD);
	if ((sADD != "") && (oADD == OBJECT_INVALID))
	{
		SendMessageToPC(oPC, "You ran out of bait.");
		CloseInterface(oPC);
		return;
	}	
	string sDROP = GetLocalString(oPOOL, "DROP");
	string sDROPB = GetLocalString(oPOOL, "DROPB"); // second drop
	string sJAIL = GetLocalString(oPOOL, "JAIL");
	int nJAIL = GetLocalInt(oPOOL, "JAIL_CHANCE");
	int nCHANCE = GetLocalInt(oPOOL, "CHANCE");
	





	string sPROF = GetLocalString(oPOOL, "PROF_SKILL");
	int nXP = GetLocalInt(oPOOL, "XP");
	int nXP_B = GetLocalInt(oPOOL, "XP_B");
	int nSKILL = GetLocalInt(oPOOL, "SKILL");
	int nSKILLRANK = GetSkillRank(nSKILL, oPC);
	
	
		int nLVL = GetLocalInt(oPOOL, "LEVEL");
		int nLEVELB  = GetLocalInt(oPOOL, "LEVEL2");
	
	
	string sANIM = GetLocalString(oPOOL, "ANIMATION");
	string sItemTag1 = "opalnecklacee";
	ReallyPlaySound(GetLocation(oPC), GetLocalString(oPC, "PROF_SOUND"));
	if (sADD != "")
	{
		int nADD = GetItemStackSize(oADD);
		if (nADD > 1) SetItemStackSize(oADD, nADD - 1);
		else DestroyObject(oADD);
	}		
	
	
	    if (GetStringLeft(sPOOLTag, 12) == "concentrated")
    {

        HandleConcentratedResource(oPC, oPOOL, nSKILL, nXP, GetLocalString(oPOOL, "DROP"), GetLocalInt(oPOOL, "CHANCE"));
		return; // Exit the function here
    }

	
	
	else if (nSKILL == 42 && Random(100) < nCHANCE)
	{
	//  GiveCraftXP(oPC, nSKILL, nXP);
	//	CreateItemOnObject(sDROP, oPC);
		CloseInterface(oPC);
		float fRESPAWN = GetLocalFloat(oPOOL, "RESPAWN");
		SendMessageToPC(oPC, "You steal the item.");


	}

	else if (nSKILL == 42 && Random(100) < nJAIL)
	{
   		object oDodgyNecklace = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
    	if (GetTag(oDodgyNecklace) == sItemTag1)
    {
        // GiveCraftXP(oPC, nSKILL, nXP);
        DestroyObject(oDodgyNecklace, 0.0f);
        CloseInterface(oPC);
        float fRESPAWN = GetLocalFloat(oPOOL, "RESPAWN");
        SendMessageToPC(oPC, "Your Dodgy Necklace spared you before crumbling to dust, that was close!");
        DestroyObject(oPOOL);
    }
    else
    {
        CloseInterface(oPC);
        DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag(sJAIL))));
        SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You have been caught!");


        // Failure: Player takes 100 physical damage and is teleported
        int nDMG = 10;
        effect eDAMAGE = EffectDamage(nDMG, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDAMAGE, oPC);
        FloatingTextStringOnCreature("", oPC);
        FloatingTextStringOnCreature("Ow! My Head!", oPC);

        DestroyObject(oPOOL);  // Add this line to destroy oPOOL after the thieving attempt
    }

}


	
	






if (nSKILLRANK >= nLEVELB && nSKILL == 30)
{

    int nRandomDrop = Random(2); // Generates a random number, either 0 or 1

    if (nRandomDrop == 0) // 50% chance for DROPB (Item B)
    {
        CreateItemOnObject(sDROPB, oPC);
        GiveCraftXP(oPC, nSKILL, nXP_B); // Add this line to give XP if DROPB is obtained
    }
    else // 50% chance for DROP (Item A)
    {
        CreateItemOnObject(sDROP, oPC);
        GiveCraftXP(oPC, nSKILL, nXP); // Add this line to give XP if DROP is obtained
    }
}
else // 50% chance for DROP (Item A)
{

    CreateItemOnObject(sDROP, oPC);
    GiveCraftXP(oPC, nSKILL, nXP); // Add this line to give XP if DROP is obtained
}







if (sADD != "")
{
    int nADD = GetItemStackSize(oADD);
    if (nADD > 1) SetItemStackSize(oADD, nADD - 1);
    else DestroyObject(oADD);
}

// Chance for the resource node to despawn
if (Random(100) < nCHANCE)
{
    CloseInterface(oPC);
    float fRESPAWN = GetLocalFloat(oPOOL, "RESPAWN");
    int nPOOL = GetObjectType(oPOOL);
    string sPOOL = GetTag(oPOOL);
    location lPOOL = GetLocation(oPOOL);
    DelayCommand(fRESPAWN, RespawnNode(nPOOL, sPOOL, lPOOL));
    DestroyObject(oPOOL);
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
	string sINPUT_B = GetLocalString(oPC, "INPUT_TAG_B");
	int nQTY_A = GetLocalInt(oPC, "INPUT_QTY_A");
	int nQTY_B = GetLocalInt(oPC, "INPUT_QTY_B");
	if (GetItemQuantity(oPC, sINPUT_A) < nQTY_A)
	{
		SendMessageToPC(oPC, "You are missing some of the required items.");
		CloseInterface(oPC);
		return;
	}
	if (GetItemQuantity(oPC, sINPUT_B) < nQTY_B)
	{
		SendMessageToPC(oPC, "You are missing some of the required items.");
		CloseInterface(oPC);
		return;
	}
	
	string sFAIL = GetLocalString(oPC, "FAIL_TAG");
	string sOUTPUT = GetLocalString(oPC, "OUTPUT_TAG");
	int nSKILL = GetLocalInt(oPC, "PROF_SKILL");
	int nFAIL = 10 * (100 - GetLocalInt(oPC, "SUCCESS_CHANCE"));
	if (sOUTPUT == "ironbar")
	{
		if (GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC)) == "rubyringe") nFAIL = 0;
		else if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC)) == "rubyringe") nFAIL = 0;
	}
	int nMULT = GetLocalInt(oPC, "OUTPUT_MULT");
	int nXP = GetLocalInt(oPC, "OUTPUT_XP");
	string sTXT = "Recipe failed.";
	if (nSKILL == SKILL_COOKING)
	{
	
	}
	if (nFAIL < 0) nFAIL = 0;
	if (1 + Random(1000) > nFAIL)
	{
		int nQTY = GetLocalInt(oPC, "OUTPUT_QTY");
		if (nQTY < 1) nQTY = 1;
		CreateItemOnObject(sOUTPUT, oPC, nQTY);
		GiveCraftXP(oPC, nSKILL, nXP);
	}
	else
	{
		string sBURN = IntToString(nFAIL);
		int nFIG = 3;
		if (nFAIL < 1000) nFIG = 2;
		if (nFAIL < 100) nFIG = 1;
		string sRATE = GetStringLeft(sBURN, nFIG);
		if (nFAIL < 10) sRATE = "0";
		sRATE = sRATE + "," + GetStringRight(sBURN, 1) + "%";
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sTXT + " (" + sRATE + " chance.)");
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
	object oPOOL = OBJECT_SELF;
	effect eVFX;
	string sTEXT = "Crafting...";
	float fLOOP = 1.5;
	switch (nSKILL)

	{
		case SKILL_FISHING: 
		sTEXT = "Fishing...";
		fLOOP = GetLocalFloat(oPC, "PROF_LOOP"); 
		eVFX = EffectNWN2SpecialEffectFile("fx_fishing");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_WOODCUTTING:
		sTEXT = "Woodcutting...";
		fLOOP = GetLocalFloat(oPC, "PROF_LOOP"); 
		eVFX = EffectNWN2SpecialEffectFile("fx_woodcutting");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_MINING: 
		sTEXT = "Mining..."; 
		fLOOP = GetLocalFloat(oPC, "PROF_LOOP"); 
		eVFX = EffectNWN2SpecialEffectFile("fx_mining");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_COOKING: 
		sTEXT = "Cooking..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_cooking");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_SMITHING: 
		sTEXT = "Smithing..."; 
		fLOOP = 1.5; 
		eVFX = EffectNWN2SpecialEffectFile("fx_smithing");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_HERBLORE: 
		sTEXT = "Mixing Potion..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_herblore");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_FIREMAKING: 
		sTEXT = "Firemaking..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_firemaking");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_FLETCHING: 
		sTEXT = "Fletching..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_fletching");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_THIEVING: 
		sTEXT = "Thieving..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_thieving");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_CRAFTING: 
		sTEXT = "Crafting..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_crafting");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		
		case SKILL_PRAYER: 
		sTEXT = "Praying..."; 
		eVFX = EffectNWN2SpecialEffectFile("fx_prayer");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
		break;
		

		
		case SKILL_BUYING: sTEXT = "Buying..."; fLOOP = 2.0; break;
	}
		
	
	SetGUIObjectText(oPC, "SCREEN_PROF_LOOP", "LOOP_TEXT", -1, sTEXT);
	
	
	float fTIME = GetLocalFloat(oPC, "PROF_TIME") + 0.1;
	float fBAR = fTIME / fLOOP;
	if (fBAR >= 1.00)
	{
		fBAR = 1.0;		
		fTIME = 0.0;
		switch (nSKILL)
		{
			case SKILL_FISHING:
			case SKILL_WOODCUTTING:
			case SKILL_MINING:
			case SKILL_THIEVING:
			GatherResource(oPC);
			break;
			default: ProduceItem(oPC);
		}
	}
	SetGUIProgressBarPosition(oPC, "SCREEN_PROF_LOOP", "GATHER_PROGRESS", fBAR);
	SetLocalFloat(oPC, "PROF_TIME", fTIME);
}


void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	if (sCOMMAND == "UPDATE") UpdateInterface(oPC);
	else CloseInterface(oPC);
}