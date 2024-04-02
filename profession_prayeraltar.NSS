#include "profession_include"

void main()
{
	object oPC = GetLastUsedBy();
	string sDEITY = GetStringLeft(GetStringLowerCase(GetDeity(oPC)), 4);
	string sALTAR = GetStringLeft(GetTag(OBJECT_SELF), 4);
	effect eVFX;
	object oESSENCE = GetLocalObject(oPC, "PLAYER_ESSENCE");
	if (oESSENCE == OBJECT_INVALID)
	{
		oESSENCE = GetItemPossessedBy(oPC, "player_essence");
		SetLocalObject(oPC, "PLAYER_ESSENCE", oESSENCE);
	}
	int nMAX = GetSkillRank(SKILL_PRAYER, oPC, TRUE);
	SetLocalInt(oESSENCE, "PRAYER_POINTS", nMAX);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUNBEAM), GetLocation(oPC));
	eVFX = EffectNWN2SpecialEffectFile("fx_ppfull");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
	SendMessageToPC(oPC, "Praying at the altar has restored your PP to full.");
}