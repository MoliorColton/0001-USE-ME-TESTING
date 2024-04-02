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
		case 1: sLOC = "Ta-Quir-Priw"; break;
		case 2: sLOC = "Gandius";  break;
		case 3: sLOC = "Kar-Hewo";  break;	
		case 4: sLOC = "Sindaris";  break;	
		case 5: sLOC = "Lemanto-Andra";  break;
		case 6: sLOC = "Lemantolly-Undri";  break;
		case 7: sLOC = "Ookookolly-Undri";  break;	
					
		default: return;
	}



//sloppy, bunch of if statements for making sure the grand tree has been completed on each button press.	
	if (sLOC == "Ta-Quir-Priw")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
	if (sLOC == "Gandius")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
	if (sLOC == "Kar-Hewo")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
	if (sLOC == "Sindaris")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
		if (sLOC == "Lemanto-Andra")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
		if (sLOC == "Lemantolly-Undri")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}
		if (sLOC == "Ookookolly-Undri")
	{
		int nQUEST = GetJournalEntry("18", oPC);
		if ((nQUEST !=73) && (nQUEST != 73))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'The Grand Tree' before you can use the Gnome Glider.");
			return;
		}
	}

	//disables the ape atoll glider, with a message of why it is disabled.	
	if (sLOC == "Ookookolly-Undri")
	{

			SendMessageToPC(oPC, "The Monkey Madness quest has not been added, the Glider cannot reach Ape Atoll yet.");
			return;
	}
	if (sLOC == "Lemantolly-Undr")
	{

			SendMessageToPC(oPC, "The One Small Favour quest has not been added, the Glider cannot reach the Feldip Hills yet.");
			return;
	}


	SetLocalInt(oPC, "GLIDER_UI", 1);
	SetLocalString(oPC, "GLIDER_DEST", GetStringLowerCase(sLOC) + "gliderspot");

	
	sTXT = "Taking a Gnome Glider to " + sLOC +  ", are you sure about it?";
	DisplayMessageBox(oPC, 0, sTXT, "gui_prof_glider", "", TRUE);
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