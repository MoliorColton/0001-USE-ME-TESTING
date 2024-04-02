const int MAX_SKILL_LEVEL = 99;

const int SKILL_FISHING = 30;
const int SKILL_COOKING = 31;
const int SKILL_FIREMAKING = 32;
const int SKILL_SMITHING = 33;
const int SKILL_WOODCUTTING = 34;
const int SKILL_MINING = 35;
const int SKILL_RUNECRAFTING = 36;
const int SKILL_CRAFTING = 37;
const int SKILL_PRAYER = 38;
const int SKILL_CONSTRUCTION = 39;
const int SKILL_AGILITY = 40;
const int SKILL_HERBLORE = 41;
const int SKILL_THIEVING = 42;
const int SKILL_FLETCHING = 43;
const int SKILL_SLAYER = 44;
const int SKILL_HUNTER = 45;
const int SKILL_FARMING = 46;
const int SKILL_BARROWS = 47;
const int SKILL_BUYING = 48;


const string HSS_FEEDBACK_COLOUR = "<color=white>";

string ConvertProfIDToName(int nSKILL)
{
	string s2DA = "skills";
	int nCACHE = GetNum2DARows(s2DA);
	int nNAME = StringToInt(Get2DAString(s2DA, "Name", nSKILL));
	string sPROF = GetStringByStrRef(nNAME);
	return sPROF;
}

void RemoveItems(object oPC, string sTAG, int nQTY, int nFEED = TRUE)
{
	if (sTAG == "") return;
	if (nQTY <= 0) return;
	int nCOUNT = nQTY;
	int nSTACK;
	string sITEM;
	object oINVALID = OBJECT_INVALID;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != oINVALID)
	{
		sITEM = GetTag(oITEM);
		if (sITEM == sTAG)
		{
			nSTACK = GetItemStackSize(oITEM);
			if (nSTACK > nCOUNT) SetItemStackSize(oITEM, nSTACK - nCOUNT, nFEED);
			else DestroyObject(oITEM, 0.0f, nFEED);
			nCOUNT = nCOUNT - nSTACK;
			if (nCOUNT <= 0) return;
		}
		oITEM = GetNextItemInInventory(oPC);
	}
}

int GetItemQuantity(object oPC, string sTAG)
{
	object oINVALID = OBJECT_INVALID;
	if (GetItemPossessedBy(oPC, sTAG) == oINVALID) return 0;
	int nTOT;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != oINVALID)
	{
		if (GetTag(oITEM) == sTAG) nTOT = nTOT + GetItemStackSize(oITEM);
		oITEM = GetNextItemInInventory(oPC);
	}
	return nTOT;
}

int GetInventoryNum(object oPC)
{
	int nITEM;
	int nBAG;
	object oBAG;
	object oIN;
	object oINVALID = OBJECT_INVALID;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != oINVALID)
	{
		if (nBAG > 0) nBAG = nBAG - 1;
		else nITEM = nITEM + 1;
		if (GetHasInventory(oITEM) == TRUE)
		{
			oBAG = oITEM;
			oIN = GetFirstItemInInventory(oBAG);
			while (oIN != oINVALID)
			{
				nBAG = nBAG + 1;
				oIN = GetNextItemInInventory(oBAG);	
			}
		}
		oITEM = GetNextItemInInventory(oPC);
	}
	return nITEM;
}

int GetSkillXPNeeded(int nLVL)
{
	float fLVL = IntToFloat(nLVL);
	float fXP = 1. / 8. * fLVL * (fLVL - 1.) + 75. * (pow(2., (fLVL - 1.)/7.) - 1.) / (1. - pow(2., -1./7.));
	int nXP = FloatToInt(fXP);
	if (nXP < 0) nXP = 0;
	return nXP;
}

void ReallyPlaySound(location lSOUND, string sSOUND, int n2D = FALSE)
{
	string sREF = "soundplayer";
	if (n2D == TRUE) sREF = sREF + "_2d";
	object oSOUND = CreateObject(OBJECT_TYPE_CREATURE, sREF, lSOUND, FALSE, sSOUND);
}

void ReallyPlayCustomAnimation(object oPC, string sANIM, int nLOOP = FALSE, float fSPEED = 1.0)
{
	PlayCustomAnimation(oPC, sANIM, nLOOP, fSPEED);
}

void BeginProfessionLoop(object oPC, object oPOOL, string sSOUND, string sANIM)
{
	SetLocalObject(oPC, "PROF_POOL", oPOOL);
	DisplayGuiScreen(oPC, "SCREEN_CHEAT_LOOP", FALSE, "cheat_loop.xml");
	SendMessageToPC(oPC, "CHEAT INCLUDE1");
	effect eFX = EffectCutsceneImmobilize();
	SendMessageToPC(oPC, "CHEAT INCLUDE2");
	eFX = SupernaturalEffect(eFX);
	SendMessageToPC(oPC, "CHEAT INCLUDE3");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
	SendMessageToPC(oPC, "CHEAT INCLUDE4");
	AssignCommand(oPC, ClearAllActions());
	SendMessageToPC(oPC, "CHEAT INCLUDE5");
	if (oPOOL != OBJECT_INVALID) AssignCommand(oPC, SetFacingPoint(GetPosition(oPOOL)));
	SendMessageToPC(oPC, "CHEAT INCLUDE6");
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, sANIM, TRUE));
	SendMessageToPC(oPC, "CHEAT INCLUDE7");
	ReallyPlaySound(GetLocation(oPC), sSOUND, TRUE);

}

void UpdateCraftLevel(object oPC, int nSKILL, string sPROF, int nTOTXP, int nBASE, int nOVER)
{
	int nNEW = nBASE;
	if (nOVER == TRUE)
	{
		while (GetSkillXPNeeded(nNEW) > nTOTXP)
		{
			SetBaseSkillRank(oPC, nSKILL, nNEW - 1, FALSE);
			nNEW = nNEW - 1;
		}
	}
	if ((nNEW <= MAX_SKILL_LEVEL)&&(nNEW == nBASE)) //Max Level
	{
		while (GetSkillXPNeeded(nNEW + 1) <= nTOTXP)
		{
			SetBaseSkillRank(oPC, nSKILL, nNEW + 1, FALSE);
			nNEW = nNEW + 1;
		}
	}
	if (nNEW != nBASE)
	{
		FloatingTextStringOnCreature("Your " + sPROF + " level is now DEBUG " + IntToString(nNEW) +"!", oPC, FALSE);
		ReallyPlaySound(GetLocation(oPC), sPROF + "_lvlup");
	}
}

void GiveCraftXP(object oPC, int nSKILL, int nXP, int nOVER = FALSE)
{
	object oITEM = GetItemPossessedBy(oPC, "player_essence");
	string sVAR = "SKILLXP_" + IntToString(nSKILL);
	string sPROF = ConvertProfIDToName(nSKILL);
	int nTOTXP = GetLocalInt(oITEM, sVAR) + nXP;
	int nBASE = GetSkillRank(nSKILL, oPC, TRUE);
	int nNEED = GetSkillXPNeeded(nBASE + 1);
	string sSIGN;
	if (nXP > 0) sSIGN = "+"; 
	SetLocalInt(oITEM, sVAR, nTOTXP);
	SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sPROF + " skill XP: " + IntToString(nTOTXP) + "/" + IntToString(nNEED) + " (" + sSIGN + IntToString(nXP) + ")");
	DelayCommand(0.0f, UpdateCraftLevel(oPC, nSKILL, sPROF, nTOTXP, nBASE, nOVER));
}