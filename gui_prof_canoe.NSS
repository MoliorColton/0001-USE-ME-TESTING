#include "nw_i0_spells"
#include "profession_include"

void CanoeTeleport(object oPC, string sINPUT)
{
	string sTXT;
	object oAREA = GetArea(oPC);
	if (GetLocalInt(oAREA, "PREVENT_CANOE") == TRUE)
	{
		sTXT = "You cannot use a canoe in this zone.";
		DisplayMessageBox(oPC, 0, sTXT);
		return;
	}
	int nXP;
	int nREQ;
	string sLOC;
	int nINPUT = StringToInt(sINPUT);
	switch (nINPUT)
	{
		case 1: nXP = 0; nREQ = 11; sLOC = "Lumbridge-South"; break;
		case 2: nXP = 0; nREQ = 11; sLOC = "Lumbridge-North";  break;
		case 3: nXP = 0; nREQ = 11; sLOC = "Lumbridge-Swamp";  break;	
		case 4: nXP = 0; nREQ = 11; sLOC = "Draynor";  break;	
		case 5: nXP = 0; nREQ = 25; sLOC = "Varrock";  break;
		case 6: nXP = 0; nREQ = 34; sLOC = "Edgeville";  break;
		case 7: nXP = 0; nREQ = 43; sLOC = "Kharidian";  break;
		case 8: nXP = 0; nREQ = 53; sLOC = "Wilderness";  break;
		case 9: nXP = 0; nREQ = 66; sLOC = "Menaphose";  break;	
					
		default: return;
	}
	int nRANK = GetSkillRank(SKILL_WOODCUTTING, oPC);
	if (nRANK < nREQ)
	{
		sTXT = "You need " + IntToString(nREQ) + " levels in Woodcutting to be able to build a canoe that strong!";
		SendMessageToPC(oPC, sTXT);
		return;
	}
	





	
////	
	if (sLOC == "Ardougne")
	{
		int nQUEST = GetJournalEntry("105", oPC);
		if ((nQUEST !=105) && (nQUEST != 105))
		{
			SendMessageToPC(oPC, "You need to complete the quest 'Plague City' before you can use this Teleport Spell.");
			return;
		}
	}
////



	SetLocalInt(oPC, "CANOE_UI", 1);
	SetLocalInt(oPC, "CANOE_XP", nXP);
	SetLocalString(oPC, "CANOE_DEST", GetStringLowerCase(sLOC) + "canoespot");

	
	sTXT = "Taking a Canoe to " + sLOC +  ", are you sure about it?";
	DisplayMessageBox(oPC, 0, sTXT, "gui_prof_canoe", "", TRUE);
}
void CanoeExecute(object oPC)
{

	int nTYPE = GetLocalInt(oPC, "CANOE_UI");
	if (nTYPE == 1) //Canoeing
	{
		
		int nXP = GetLocalInt(oPC, "CANOE_XP");
		string sDEST = GetLocalString(oPC, "CANOE_DEST");
		GiveCraftXP(oPC, SKILL_WOODCUTTING, nXP);
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
	if (sCOMMAND == "CANOETO") CanoeTeleport(oPC, sINPUT);
	else CanoeExecute(oPC);
}