/*
	1) Put it in the "On Death Script" slot of the intended creature.
	2) Set the following local variables on said creature:
     QUEST_ID (String) - The ID of the quest to progress
     QUEST_STEP (Int) - The step of the quest to progress to.
     QUEST_XP (Int) - Optional. The one-time XP bonus related to the quest.
     QUEST_QP (Int) - Optional. The one-time QP bonus related to the quest.
	 QUEST_WP (String) - Optional. The tag of destination waypoint (if any) after you have killed the creature.
*/

#include "profession_include"

void LootPluginStartup(object oPC, object oMOB)
{
	object oMODULE = GetModule();
	
	// If the LOOT Plugin is active.
	if (GetLocalInt(oMODULE, "LEG_LOOT_ACTIVE") != TRUE) return;	
	if (GetLocalInt(oMODULE, "LEG_LOOT_ONDEATH") != TRUE) return;
	
	object oParent = GetLocalObject(oMOB, "SPAWN_Parent");
	if (oParent == OBJECT_INVALID) oParent = oMOB;
	else if (GetLocalString(oParent, "LEG_LOOT_ID") == "") oParent = oMOB;
		
	// If the Spawn plugin says to not Drop Loot on Death, then we don't make loot at all here.
	// Of course if we are not using the spawn plugin at all, then go ahead and make loot.
	if (!GetLocalInt(oMODULE, "LEG_SPAWN_ACTIVE") || !GetLocalInt(GetLocalObject(oMOB, "SPAWN_Parent"),"LEG_SPAWN_DoNotDropMyLoot"))
	{
		AddScriptParameterObject(oPC);
		AddScriptParameterObject(oParent);
		ExecuteScriptEnhanced("leg_loot_makeloot", oMOB);
	}
}

void TeleportToDestination(object oPC, string sWP)
{
	object oWP = GetWaypointByTag(sWP);
	if (oWP == OBJECT_INVALID) oWP = GetObjectByTag(sWP);
	if (oWP == OBJECT_INVALID) FloatingTextStringOnCreature("ERROR: Waypoint not found.", oPC, FALSE); 
	else AssignCommand(oPC, JumpToObject(oWP));
}

void UpdateQuest(object oPC, object oESSENCE, string sQUEST, int nSTEP, int nXP, int nQP)
{
	int nSTATE = GetLocalInt(oESSENCE, "QUEST_" + sQUEST);
	if (nSTEP <= nSTATE) return;
	
	AddJournalQuestEntry(sQUEST, nSTEP, oPC, FALSE);
	int nPOINTS = GetLocalInt(oESSENCE, "QUEST_POINTS");
	SetLocalInt(oESSENCE, "QUEST_" + sQUEST, nSTEP);
	SetLocalInt(oESSENCE, "QUEST_POINTS", nPOINTS + nQP);
	if (nQP > 0) FloatingTextStringOnCreature("You gained " + IntToString(nQP) + " Quest Points.", oPC, FALSE);
	else if (nQP < 0) FloatingTextStringOnCreature("You lost " + IntToString(nQP) + " Quest Points.", oPC, FALSE);
	GiveXPToCreature(oPC, nXP);
}

void SlayerKill(object oPC, object oESSENCE, string sMOB, string sNAME)
{
    string sTXT;
    int iRow = GetLocalInt(oESSENCE, "SLAYER_ROW");
    int nTOTAL = GetLocalInt(oESSENCE, "SLAYER_TOTAL");
    int nKILLS = GetLocalInt(oESSENCE, "SLAYER_KILLS") + 1;
    int nXP = (5 * FloatToInt(GetChallengeRating(OBJECT_SELF))) + StringToInt(Get2DAString("slayertasks","RewardXP",iRow)); //GetLocalInt(oESSENCE, "SLAYER_EXP");
    string sMobs = Get2DAString("slayertasks","MonsterList",iRow);
    if(FindSubString(sMobs,sMOB) == -1)
    {
     return; // This monster is not eligible.
    }
    
    if (nKILLS < nTOTAL)
    {
        sTXT = sNAME + "(s) killed: " + IntToString(nKILLS) + "/" + IntToString(nTOTAL);
        SetLocalInt(oESSENCE, "SLAYER_KILLS", nKILLS);
    }
    else
    {    
        sTXT = "You have killed all the " + sNAME + "(s) required by the Slayer Master!";
        int nTOKENS;
        int nCR = StringToInt(Get2DAString("slayertasks","CR",iRow));
        switch (nCR)
        {
            case 4: nTOKENS = 1; break;
            case 6: nTOKENS = 2; break;
            case 10: nTOKENS = 4; break;
            case 14: nTOKENS = 10; break;
            case 20: nTOKENS = 12; break;
            case 26: nTOKENS = 15; break;
            default: return;
        }

        // Check if the player is wearing a Slayer Helmet
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
        if(GetTag(oHelmet) == "slayerhelmet")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.1;
            nTOKENS += FloatToInt(fBonusTokens);
        }
		     // Check if the player is wearing a Slayer Helmet

        if(GetTag(oHelmet) == "reslayerhelmet")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.2;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet

        if(GetTag(oHelmet) == "strslayerhelmet")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.3;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet

        if(GetTag(oHelmet) == "migslayerhelmet")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.4;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet

        if(GetTag(oHelmet) == "slayerhelmetabyssal")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.4;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet

        if(GetTag(oHelmet) == "slayerhelmetkq")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.4;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet
        if(GetTag(oHelmet) == "slayerhelmetkbd")
        {
            float fBonusTokens = nTOKENS * 0.4;
            nTOKENS += FloatToInt(fBonusTokens);
        }
			 // Check if the player is wearing a Slayer Helmet
        if(GetTag(oHelmet) == "slayerhelmettzhaar")
        {
            // Increase tokens by 10% if wearing Slayer Helmet
            float fBonusTokens = nTOKENS * 0.4;
            nTOKENS += FloatToInt(fBonusTokens);
        }
        int nSTREAK = GetLocalInt(oESSENCE, "SLAYER_STREAK");
        int nMULTI;
        switch (nSTREAK)
        {
            case 1: nMULTI = 0; break;
            case 2: nMULTI = 0; break;
            case 3: nMULTI = 0; break;
            case 4: nMULTI = 0; break;
            case 10: nMULTI = 5; break;
            case 50: nMULTI = 15; break;
            case 100: nMULTI = 25; break;
            case 250: nMULTI = 35; break;
            case 1000: nMULTI = 50; break;
            default: nMULTI = 1;
        }
        SetLocalInt(oESSENCE, "SLAYER_STREAK", nSTREAK+1);
        DeleteLocalInt(oESSENCE, "SLAYER_KILLS");
        DeleteLocalInt(oESSENCE, "SLAYER_TOTAL");
        DeleteLocalInt(oESSENCE, "SLAYER_ROW");
        if (nTOKENS > 0 ){
            object oITEM = CreateItemOnObject("slayertoken", oPC, nTOKENS);
        }
    }
    GiveCraftXP(oPC, SKILL_SLAYER, nXP);
    FloatingTextStringOnCreature(sTXT, oPC, FALSE);
}


void SlayerAndQuestCheck(object oPC, string sMOB, string sNAME, string sQUEST, string sWP, int nSTEP, int nXP, int nQP)
{
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	if (oESSENCE == OBJECT_INVALID) SendMessageToPC(oPC, "ERROR: Player Essence not found.");
	if (GetLocalInt(oESSENCE, "SLAYER_ROW") != 0){ 
		SlayerKill(oPC, oESSENCE, sMOB, sNAME);
	}
	if (sQUEST != "") UpdateQuest(oPC, oESSENCE, sQUEST, nSTEP, nXP, nQP);
	if (sWP != "") DelayCommand(0.1, TeleportToDestination(oPC, sWP));
}

void main()
{
	object oKILLER = GetLastKiller();
	object oMOB = OBJECT_SELF;
	string sMOB = GetTag(oMOB);
	string sNAME = GetName(oMOB);
	string sQUEST = GetLocalString(oMOB, "QUEST_ID");
	string sWP = GetLocalString(oMOB, "QUEST_WP");
	int nSTEP = GetLocalInt(oMOB, "QUEST_STEP");
	int nXP = GetLocalInt(oMOB, "QUEST_XP");
	int nQP = GetLocalInt(oMOB, "QUEST_QP");
	
	object oPC = GetFirstFactionMember(oKILLER, FALSE);
	while (oPC != OBJECT_INVALID)
	{
		if (GetIsOwnedByPlayer(oPC) == TRUE) SlayerAndQuestCheck(oPC, sMOB, sNAME, sQUEST, sWP, nSTEP, nXP, nQP);
		oPC = GetNextFactionMember(oKILLER, FALSE);
	}

	DelayCommand(0.0f, LootPluginStartup(oKILLER, oMOB));
}