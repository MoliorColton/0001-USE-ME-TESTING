#include "clangeddin_library"

const string DATABASE_UI = "Clangeddin_Interface";

void StartupInterface(object oSELF, string sPLAYER, int nSTART)
{
	if (nSTART == TRUE) CloseGUIScreen(oSELF, "SCREEN_PARTY_BAR");
	else
	{
		CloseGUIScreen(oSELF, "SCREEN_PARTYBAR_newright");
		CloseGUIScreen(oSELF, "SCREEN_PARTYBAR_oldright");
		CloseGUIScreen(oSELF, "SCREEN_PARTYBAR_newleft");
		CloseGUIScreen(oSELF, "SCREEN_PARTYBAR_oldleft");
	}
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_OBJECT", "TARGETSTYLE_new", TRUE);
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_OBJECT", "TARGETSTYLE_old", TRUE);
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_ENEMY", "TARGETSTYLE_new", TRUE);
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_ENEMY", "TARGETSTYLE_old", TRUE);
	int nSTYLE = GetCampaignInt(DATABASE_UI, sPLAYER);
	string sSTY = "new";
	string sDIR = "left";
	switch (nSTYLE)
	{
		case 1: sDIR = "right"; break;
		case 2: sSTY = "old"; break;
		case 3: sDIR = "right"; sSTY = "old"; break;
	}
	
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_OBJECT", "TARGETSTYLE_" + sSTY, FALSE);
	SetGUIObjectHidden(oSELF, "SCREEN_TARGETED_ENEMY", "TARGETSTYLE_" + sSTY, FALSE);
	DisplayGuiScreen(oSELF, "SCREEN_PARTYBAR_" + sSTY + sDIR, FALSE, "partybar_" + sSTY + sDIR + ".xml");
}

void UIOptions(object oSELF, string sPLAYER, string sINPUT)
{
	int nINPUT = StringToInt(sINPUT);
	SetCampaignInt(DATABASE_UI, sPLAYER, nINPUT - 1);
	DelayCommand(0.0f, StartupInterface(oSELF, sPLAYER, FALSE));
}



void UpdateScreens(object oSELF, object oPC, string sINPUT, string sPARAM)
{
	if (sINPUT == "CHAR")
	{
		object oARMOR = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		if (sPARAM == "CREATUREEXAMINE")
		{
			object oNPC = GetPlayerCreatureExamineTarget(oPC);
			oARMOR = GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC);
		}
		string sARMOR = "Armor: " + GetName(oARMOR);
		SetGUIObjectText(oPC, "SCREEN_" + sPARAM, "ARMOR_TEXT", -1, sARMOR);
	}
	else if (sINPUT == "TARGET")
	{
		if (CLANG_UI_DISABLE_HPNUMBERS == TRUE) return;
		object oTARGET = GetPlayerCurrentTarget(oPC);
		int nMIN = GetCurrentHitPoints(oTARGET);
		int nMAX = GetMaxHitPoints(oTARGET);
		SetGUIObjectText(oPC, "SCREEN_TARGETED_" + sPARAM, "HP_TEXT", -1, IntToString(nMIN) + "/" + IntToString(nMAX));
	}
}

void main(string sCOMMAND, string sINPUT, string sPARAM)
{
	object oSELF = OBJECT_SELF;
	object oPC = GetControlledCharacter(oSELF);
	if (sCOMMAND == "UPDATE")
	{
		UpdateScreens(oSELF, oPC, sINPUT, sPARAM); 
		return;
	}
	
	string sPLAYER = GetPCPlayerName(oSELF);
	int nCOMMAND = StringToInt(sCOMMAND);
	switch (nCOMMAND)
	{
		case 1: StartupInterface(oSELF, sPLAYER, TRUE); break;
		case 2: UIOptions(oSELF, sPLAYER, sINPUT); break;
		case 3: DisplayGuiScreen(oSELF, "SCREEN_CLANGUI_OPTIONS", FALSE, "clangui_options.xml"); break;

	}
}