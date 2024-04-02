#include "ginc_param_const"

void InitializeKolodion(object oBOSS, object oPC)
{
	SetPlotFlag(oBOSS, FALSE);
	SetLocalObject(oBOSS, "PC", oPC);
	AssignCommand(oBOSS, ActionSpeakString("You must prove yourself... now!"));
}

void main()
{
	object oPC = GetPCSpeaker();
	object oBOSS = GetObjectByTag("kolodionboss");
	if (oBOSS != OBJECT_INVALID)
	{
		FloatingTextStringOnCreature("It appears someone is already dueling Kolodion, please wait until they're done.", oPC, FALSE);
		return;
	}
	object oWAY = GetTarget("magearenaround1");
	oBOSS = CreateObject(OBJECT_TYPE_CREATURE, GetTag(OBJECT_SELF), GetLocation(oWAY), TRUE, "kolodionboss");
	AssignCommand(oPC, JumpToObject(oWAY));
	ChangeToStandardFaction(oBOSS, STANDARD_FACTION_HOSTILE);
	DelayCommand(0.0f, InitializeKolodion(oBOSS, oPC));
}