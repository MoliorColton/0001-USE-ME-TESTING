#include "nw_i0_spells"
#include "profession_include"

void GliderTeleport(object oPC, string sINPUT)
{
	string sTXT;
	object oAREA = GetArea(oPC);
	if (GetLocalInt(oAREA, "PREVENT_GLIDER") == TRUE)
	{
		sTXT = "You cannot use a Glider in this zone.";
		DisplayMessageBox(oPC, 0, sTXT);
		return;
	}
	string sLOC;
	int nINPUT = StringToInt(sINPUT);
	switch (nINPUT)
	{
		case 1: sLOC = "Tree-Gnome-Village"; break;
		case 2: sLOC = "Tree-Gnome-Stronghold";  break;
		case 3: sLOC = "Khazard-Battlefield";  break;	
		case 4: sLOC = "North-West-Varrock";  break;	

					
		default: return;
	}



//sloppy, bunch of if statements for making sure the grand tree has been completed on each button press.	
	if (sLOC == "Tree-Gnome-Village")
	{
		int nQUEST = GetJournalEntry("11", oPC);
		if ((nQUEST !=11) && (nQUEST != 11))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Tree Gnome Village' before you can use this.");
			return;
		}
	}
	if (sLOC == "Tree-Gnome-Stronghold")
	{
		int nQUEST = GetJournalEntry("11", oPC);
		if ((nQUEST !=11) && (nQUEST != 11))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Tree Gnome Village' before you can use this.");
			return;
		}
	}
	if (sLOC == "Khazard-Battlefield")
	{
		int nQUEST = GetJournalEntry("11", oPC);
		if ((nQUEST !=11) && (nQUEST != 11))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Tree Gnome Village' before you can use this.");
			return;
		}
	}
	if (sLOC == "North-West-Varrock")
	{
		int nQUEST = GetJournalEntry("11", oPC);
		if ((nQUEST !=11) && (nQUEST != 11))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Tree Gnome Village' before you can use this.");
			return;
		}
	}



	SetLocalInt(oPC, "GLIDER_UI", 1);
	SetLocalString(oPC, "GLIDER_DEST", GetStringLowerCase(sLOC) + "tree");

	
	sTXT = "Travel to " + sLOC +  "?";
	DisplayMessageBox(oPC, 0, sTXT, "gui_prof_spirittree", "", TRUE);
}
void GliderExecute(object oPC)
{

	int nTYPE = GetLocalInt(oPC, "GLIDER_UI");
	if (nTYPE == 1) //Gliding
	{
		
		string sDEST = GetLocalString(oPC, "GLIDER_DEST");
		DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag(sDEST))));
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
	if (sCOMMAND == "GLIDERTO") GliderTeleport(oPC, sINPUT);
	else GliderExecute(oPC);
}