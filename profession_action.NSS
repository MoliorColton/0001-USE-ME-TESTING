/*
	Use this script to grant XP for professions.
	nSKILL: The ID (row from skills.2da) of the skill that you wish to give XP to. (ie. 30 = SKILL_FISHING)
	nXP: How much Skill XP is granted by the action. Negative values will remove XP.
	nOVER: Default Value 0 (FALSE). Set to 1 (TRUE) if you want the script to remove skill levels when the total exp is below the current level's threshold.
	nCONV: Default Value 0 (FALSE). Set to 1 (TRUE) if this is called from a conversation.
*/

#include "profession_include"


void main(int nSKILL, int nXP, int nOVER = FALSE, int nCONV = FALSE)
{
	object oPC = OBJECT_SELF;
	if (nCONV == TRUE) oPC = GetPCSpeaker();
	GiveCraftXP(oPC, nSKILL, nXP, nOVER);
}