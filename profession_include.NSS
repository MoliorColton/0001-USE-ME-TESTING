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
const int SKILL_PRODUCTION = 49;



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




void ReallyPlaySound(location lSOUND, string sSOUND, int n2D = FALSE)//I don't this does anything anymore, it wouldn't work and I'm too afraid to remove it because it's been so long since it was added.
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
	DisplayGuiScreen(oPC, "SCREEN_PROF_LOOP", FALSE, "prof_loop.xml");
	effect eFX = EffectCutsceneImmobilize();
	eFX = SupernaturalEffect(eFX);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);	
	AssignCommand(oPC, ClearAllActions());
	if (oPOOL != OBJECT_INVALID) AssignCommand(oPC, SetFacingPoint(GetPosition(oPOOL)));
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, sANIM, TRUE));
	ReallyPlaySound(GetLocation(oPC), sSOUND, TRUE); 
}



void UpdateCraftLevel(object oPC, int nSKILL, string sPROF, int nTOTXP, int nBASE, int nOVER)



{
	

	int nNEW = nBASE;
	string sTEXT0 = "ERROR PLEASE REPORT ME AS A BUG!";
	string sTEXT1 = "If you are seeing this, the devs forgot to add a case for this skill!";
	//
	//This is where the player's current skilling action is playing.
	string sPROF = ConvertProfIDToName(nSKILL);
	
	//
	//
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
	if (nNEW != nBASE)//this is where the level-up notification GUI is triggered

	{

	sTEXT0 = "Congratulations, you just advanced a " + sPROF + " level.";
	sTEXT1 = "Your " + sPROF + " level is now " + IntToString(nNEW);
	
		
		DisplayGuiScreen(oPC, "LEVELUPBACKGROUND", FALSE, "levelupbackgroundgui.xml");	
		SetGUIObjectText(oPC, "LEVELUPBACKGROUND", "LEVELUP_TEXT0", -1, sTEXT0);
		SetGUIObjectText(oPC, "LEVELUPBACKGROUND", "LEVELUP_TEXT1", -1, sTEXT1);
		SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "levelupbackground.tga");
		


	}
	switch (nSKILL)//each skill has a case, this is done so that each skill can have its own graphics appear on the level-up notification GUI
		{	
		case SKILL_THIEVING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "thievinglvlup.tga"); break; //Thieving Skill
		case SKILL_WOODCUTTING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "woodcuttinglvlup.tga"); break;//Woodcuting Skill
		case SKILL_COOKING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "cookinglvlup.tga"); break;//Cooking Skill
		case SKILL_CRAFTING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "craftinglvlup.tga"); break;
		case SKILL_RUNECRAFTING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "runecraftinglvlup.tga"); break;
		case SKILL_PRAYER: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "prayerlvlup.tga"); break;
		case SKILL_FISHING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "fishinglvlup.tga"); break;
		case SKILL_MINING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "mininglvlup.tga"); break;
		case SKILL_SMITHING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "smithinglvlup.tga"); break;
		case SKILL_HERBLORE: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "herblorelvlup.tga"); break;
		case SKILL_FARMING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "farminglvlup.tga"); break;
		case SKILL_SLAYER: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "slayerlvlup.tga"); break;
		case SKILL_FLETCHING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "fletchinglvlup.tga"); break;
		case SKILL_FIREMAKING: SetGUITexture(oPC, "LEVELUPBACKGROUND", "SKILL_ICON", "firemakinglvlup.tga"); break;

		

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