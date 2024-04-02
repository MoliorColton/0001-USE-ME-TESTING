#include "profession_include"

//Used for producing items related to professions via conversation.
//sOUTPUT = the tag of the item that should be made.
//nMULT = the amount of production loops that should be made (generally 1, 5 or 200)
//nSKILL = the row ID of the skill.2da to which this product is related (for example SKILL_CRAFTING = 37)
//nXP = The amount of crafting XP received on successful crafting per item
//sTAG_A = the tag of the required first input
//nQTY_A = the amount of INPUT A required to make one OUTPUT.
//sTAG_B = the tag of the required second input. By default this is an empty string (which means there's no second input required).
//nQTY_B = the amount of INPUT B required to make one OUTPUT. By default this is zero.
//nFAIL = The % chance that a recipe might succeed, between 0 (guaranteed failure) and 100 (guaranteed success).
//sFAIL = The tag of the item obtained on failure. By default this is an empty string (nothing).
//nQTY_O = The amount of OUTPUT items produced per loop. If it's lower than 1, it will count as 1.

void main (object oPC, int nSKILL)
{
	object oPC = GetPCSpeaker();
	object oPOOL = OBJECT_SELF;
	effect eVFX;
	switch (nSKILL)
	{

		case SKILL_COOKING: eVFX = EffectNWN2SpecialEffectFile("fx_pthickskin"); break;

	}
	if (GetTag(oPOOL) == "furnace") eVFX = EffectNWN2SpecialEffectFile("fx_pmysticmight");


}