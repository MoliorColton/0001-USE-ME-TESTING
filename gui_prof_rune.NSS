#include "nw_i0_spells"
#include "profession_include"

void RuneTeleport(object oPC, string sINPUT)
{
	string sTXT;
	object oAREA = GetArea(oPC);
	if (GetLocalInt(oAREA, "PREVENT_TELEPORT") == TRUE)
	{
		sTXT = "You cannot use teleport in this zone.";
		DisplayMessageBox(oPC, 0, sTXT);
		return;
	}
	int nXP;
	int nREQ;
	string sRUNE;
	string sLOC;
	int nINPUT = StringToInt(sINPUT);
	switch (nINPUT)
	{
		case 1: nXP = 35; nREQ = 25; sLOC = "Varrock"; sRUNE = "Fire"; break;
		case 2: nXP = 41; nREQ = 31; sLOC = "Lumbridge"; sRUNE = "Earth"; break;
		case 3: nXP = 48; nREQ = 37; sLOC = "Falador"; sRUNE = "Water"; break;
		case 4: nXP = 0; nREQ = 1; sLOC = "Lumbridge"; sRUNE = ""; break;  //unused
		case 5: nXP = 55; nREQ = 45; sLOC = "Camelot"; sRUNE = "Fire"; break;
		case 6: nXP = 61; nREQ = 51; sLOC = "Ardougne"; sRUNE = "Water"; break;
		case 7: nXP = 68; nREQ = 58; sLOC = "Watchtower"; sRUNE = "Earth"; break;
		case 8: nXP = 68; nREQ = 61; sLOC = "Trollheim"; sRUNE = "Fire"; break;
		default: return;
	}
	int nRANK = GetSkillRank(SKILL_RUNECRAFTING, oPC);
	if (nRANK < nREQ)
	{
		sTXT = "You need " + IntToString(nREQ) + " ranks in Runecrafting to be able to teleport to that location";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	




	location lPC = GetLocation(oPC);
	object oINVALID = OBJECT_INVALID;
	object oPLAYER = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lPC);
	while (oPLAYER != oINVALID)
	{
		if ((GetIsPC(oPLAYER) == TRUE) && (GetIsEnemy(oPLAYER, oPC) == TRUE))
		{
			sTXT = "You may not teleport while a hostile player is nearby.";
			SendMessageToPC(oPC, sTXT);
			return;
		}
		oPLAYER = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lPC);
	}
	
////////	
	if (sLOC == "Ardougne")
	{
		int nQUEST = GetJournalEntry("69", oPC);
		if (nQUEST !=8) 
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Elena's Lament' before you can use this Teleport Spell.");
			return;
		}
	}
	else if (sLOC == "Watchtower")
	{
		int nQUEST = GetJournalEntry("76", oPC);
		if (nQUEST !=29)
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Watchtower' before you can use this Teleport Spell.");
			return;
		}
	}
	else if (sLOC == "Trollheim")
	{
		int nQUEST = GetJournalEntry("85", oPC);
		if (nQUEST !=14)
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Edgar's Ruse' before you can use this Teleport Spell.");
			return;
		}
	}
/////////////
	SetLocalInt(oPC, "RUNE_UI", 1);
	SetLocalInt(oPC, "TELEPORT_XP", nXP);
	SetLocalString(oPC, "TELEPORT_DEST", GetStringLowerCase(sLOC) + "loderc");
	SetLocalString(oPC, "TELEPORT_COST", GetStringLowerCase(sRUNE) + "rune");
	
	sTXT = "Teleporting to " + sLOC + " will cost you 1 Law Rune, 3 Air Runes and 1 " + sRUNE + " Rune. Are you sure about it?";
	DisplayMessageBox(oPC, 0, sTXT, "gui_prof_rune", "", TRUE);
}

void RuneEnchant(object oPC, string sINPUT)
{
	object oITEM = GetPlayerCurrentTarget(oPC);
	string sTXT;
	if (GetItemPossessor(oITEM) != oPC)
	{
		sTXT = "You may only enchant items in your inventory (select by targeting item with right click).";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	effect eVFX;
	int nXP;
	int nREQ;
	int nRUNE_A;
	int nRUNE_B;
	string sRUNE_A;
	string sRUNE_B;
	string sMAT;
	int nINPUT = StringToInt(sINPUT);
	switch (nINPUT)
	{
		case 1: nXP = 17; nREQ = 30; sMAT = "Sapphire"; sRUNE_A = "Water"; sRUNE_B = ""; nRUNE_A = 1; nRUNE_B = 0; break;
		case 2: nXP = 37; nREQ = 40; sMAT = "Emerald"; sRUNE_A = "Air"; sRUNE_B = ""; nRUNE_A = 3; nRUNE_B = 0; break;
		case 3: nXP = 59; nREQ = 50; sMAT = "Ruby"; sRUNE_A = "Fire"; sRUNE_B = ""; nRUNE_A = 5; nRUNE_B = 0; break;
		case 4: nXP = 67; nREQ = 60; sMAT = "Diamond"; sRUNE_A = "Earth"; sRUNE_B = ""; nRUNE_A = 10; nRUNE_B = 0; break;
		case 5: nXP = 78; nREQ = 70; sMAT = "Dragonstone"; sRUNE_A = "Earth"; sRUNE_B = "Water"; nRUNE_A = 15; nRUNE_B = 15; break;
		case 6: nXP = 78; nREQ = 80; sMAT = "Onyx"; sRUNE_A = "Earth"; sRUNE_B = "Fire"; nRUNE_A = 20; nRUNE_B = 20; break;
		default: return;
	}
	int nRANK = GetSkillRank(SKILL_RUNECRAFTING, oPC);
	if (nRANK < nREQ)
	{
		sTXT = "You need " + IntToString(nREQ) + " ranks in Runecrafting to be able to perform that type of enchantment";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	if ((GetLocalInt(oITEM, "ENCHANTABLE") != 1))
	{
		sTXT = "This item cannot be enchanted.";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	if (GetStringLeft(GetTag(oITEM), GetStringLength(sMAT)) != GetStringLowerCase(sMAT))
	{
		sTXT = "You can only enchant items of the corresponding material (Sapphire on Sapphire, Emerald on Emerald, ecc...)";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	string sCOST = IntToString(nRUNE_A) + " " + sRUNE_A + " runes and 1 Cosmic Rune.";
	if (GetBaseItemType(oITEM) == BASE_ITEM_BOLT) sCOST = IntToString(nRUNE_B) + " " + sRUNE_B + " runes, " + sCOST;
	sTXT = "Enchanting " + GetName(oITEM) + " will cost you " + sCOST + " Are you sure about it?";
	SetLocalObject(oPC, "ENCHANT_INPUT", oITEM);
	SetLocalString(oPC, "ENCHANT_RUNEA_TAG", GetStringLowerCase(sRUNE_A) + "rune");
	SetLocalString(oPC, "ENCHANT_RUNEB_TAG", GetStringLowerCase(sRUNE_B) + "rune");
	SetLocalInt(oPC, "ENCHANT_RUNEA_QTY", nRUNE_A);
	SetLocalInt(oPC, "ENCHANT_RUNEB_QTY", nRUNE_B);
	SetLocalInt(oPC, "RUNE_UI", 2);
	DisplayMessageBox(oPC, 0, sTXT, "gui_prof_rune", "", TRUE);
	eVFX = EffectNWN2SpecialEffectFile("fx_runecrafting");
	//test for enchating issues caused players to obtain XP without losing runes.
	GiveCraftXP(oPC, SKILL_RUNECRAFTING, nXP);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
	
}

void RuneExecute(object oPC)
{
	int nFAIL;
	effect eVFX;
	int nTOT = 1;
	int nTYPE = GetLocalInt(oPC, "RUNE_UI");
	if (nTYPE == 1) //Teleporting
	{
		string sCOST = GetLocalString(oPC, "TELEPORT_COST");
		if (GetItemQuantity(oPC, sCOST) < 1) nFAIL = TRUE;
		else if (GetItemQuantity(oPC, "lawrune") < 1) nFAIL = TRUE;
		else if (GetItemQuantity(oPC, "airrune") < 3) nFAIL = TRUE;
		if (nFAIL == TRUE)
		{
			SendMessageToPC(oPC, "You do not possess the required runes.");
			return;
		}
		int nXP = GetLocalInt(oPC, "TELEPORT_XP");
		string sDEST = GetLocalString(oPC, "TELEPORT_DEST");
		RemoveItems(oPC, sCOST, 1);
		RemoveItems(oPC, "lawrune", 1);
		RemoveItems(oPC, "airrune", 3);
		DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag(sDEST))));
	}
	else if (nTYPE == 2) //Enchanting
	{
		if (GetInventoryNum(oPC) >= 128)
		{
			SendMessageToPC(oPC, "Your inventory is full.");
			return;
		}
		string sRUNE_A = GetLocalString(oPC, "ENCHANT_RUNEA_TAG");
		string sRUNE_B = GetLocalString(oPC, "ENCHANT_RUNEB_TAG");
		int nRUNE_A = GetLocalInt(oPC, "ENCHANT_RUNEA_QTY");
		int nRUNE_B = GetLocalInt(oPC, "ENCHANT_RUNEB_QTY");
		
		
		object oINPUT = GetLocalObject(oPC, "ENCHANT_INPUT");
		if (GetBaseItemType(oINPUT) == BASE_ITEM_BOLT) nTOT = 15;
		if (GetItemQuantity(oPC, "cosmicrune") < 1) nFAIL = TRUE;
		else if (GetItemQuantity(oPC, sRUNE_A) < nRUNE_A) nFAIL = TRUE;
		else if ((nTOT == 15) && (GetItemQuantity(oPC, sRUNE_B) < nRUNE_B)) nFAIL = TRUE;
		if (nFAIL == TRUE)
		{
			SendMessageToPC(oPC, "You do not possess the required runes.");
			return;
		}
		string sOUTPUT = GetTag(oINPUT) + "e"; // to create a new item to enchant, just add "d" at the end. rubyringe vs rubyring
		if (nTOT == 1) DestroyObject(oINPUT);
		else
		{
			int nSTACK = GetItemStackSize(oINPUT);
			if (nSTACK > 15) SetItemStackSize(oINPUT, nSTACK - 15);
			else if (nSTACK == 15) DestroyObject(oINPUT);
			else
			{
				SendMessageToPC(oPC, "You need at least 15 bolts in a single stack to enchant them.");
				return;
			}
		}			
		RemoveItems(oPC, "cosmicrune", 1);
		RemoveItems(oPC, sRUNE_A, nRUNE_A);
		if (nTOT == 15) RemoveItems(oPC, sRUNE_B, nRUNE_B);
		CreateItemOnObject(sOUTPUT, oPC, nTOT);
		eVFX = EffectNWN2SpecialEffectFile("fx_runecrafting");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
	}
}

void main(string sCOMMAND, string sINPUT)
{
	object oPC = OBJECT_SELF;
	effect eFX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eFX) == TRUE)
	{
		if (GetEffectType(eFX) == EFFECT_TYPE_CUTSCENEIMMOBILIZE) return;
		eFX = GetNextEffect(oPC);
	}
	if (sCOMMAND == "TELEPORT") RuneTeleport(oPC, sINPUT);
	else if (sCOMMAND == "ENCHANT") RuneEnchant(oPC, sINPUT);
	else RuneExecute(oPC);
}