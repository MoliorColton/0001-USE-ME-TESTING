#include "nw_i0_spells"
#include "profession_include"

void CanoeTeleport(object oPC, string sINPUT)

{
	string sTXT;
	int nREQ;
	string sLOC;
	int nINPUT = StringToInt(sINPUT);
	switch (nINPUT)

	{
		case 1: nREQ = 1; sLOC = "lumbridge"; break;	
		case 2: nREQ = 1; sLOC = "varrock"; break;
		case 3: nREQ = 2; sLOC = "falador"; break;
		default: return;
	}
	int nRANK = GetSkillRank(SKILL_WOODCUTTING, oPC);
	if (nRANK < nREQ)
	{
		sTXT = "You need a woodcutting level of " + IntToString(nREQ) + " .";
		SendMessageToPC(oPC, sTXT);
		return;
	}
		SetLocalInt(oPC, "CANOE_UI", 1);
		SetLocalString(oPC, "CANOE_DEST", GetStringLowerCase(sLOC) + "canoe");
		sTXT = "Are you sure you want to take a canoe to " + sLOC + "?";
		DisplayMessageBox(oPC, 0, sTXT, "gui_prof_canoe", "", TRUE);
		SendMessageToPC(oPC, "DEBUG00");
		
}


void CanoeExecute(object oPC)
{
int nFAIL;
	int nTYPE = GetLocalInt(oPC, "CANOE_UI");
	if (nTYPE == 1) //Teleporting
	SendMessageToPC(oPC, "DEBUG01");
	{
		string sCOST = GetLocalString(oPC, "TELEPORT_COST");
		if (nFAIL == TRUE)
		{
			SendMessageToPC(oPC, "You do not possess the required runes.");
			return;
		}
		string sDEST = GetLocalString(oPC, "CANOE_DEST");
		DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag(sDEST))));
	}
	}
void main(string sCOMMAND, string sINPUT)
{
	object oPC = OBJECT_SELF;
	if (sCOMMAND == "TELEPORT") CanoeTeleport(oPC, sINPUT);
	else CanoeExecute(oPC);
}
	