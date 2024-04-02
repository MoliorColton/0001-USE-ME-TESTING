#include "profession_include"

//Used for converting rune essences at rune altars.
//nRUNE: The type of altar used.
//	1 = Air, 2 = Mind, 3 = Water, 4 = Earth, 5 = Fire, 6 = Body 7 = Cosmic
//	8 = Chaos, 9 = Astral, 10 = Nature, 11 = Law, 12 = Death, 13 = Blood
//nQTY: The amount of rune essences you wish to convert to rune.

void main(int nQTY)
{
	object oPC = GetLastUsedBy();
	string sALTAR = GetTag(OBJECT_SELF);
	sALTAR = GetStringRight(sALTAR, 2);
	int nALTAR = StringToInt(sALTAR);
	SetLocalInt(oPC, "RUNE_ALTAR", nALTAR);
	DelayCommand(0.0f, AssignCommand(oPC, ActionStartConversation(oPC, "rune_altar", TRUE, FALSE)));
}