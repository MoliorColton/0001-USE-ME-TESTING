/*
	Use this script to check skill progression during a conversation or an event.
	The script will return TRUE if the character that calls the script is equal to or greather than nLEVEL, unless nEXACT is set to TRUE.
	nSKILL: The ID (row from skill.2da) of the skill checked.
	nLEVEL: The level of the skill you wish for it to compared to.
	nEXACT: Default Value 0 (FALSE). Set to 1 (TRUE) if the skill level has to be exactly the same as nLEVEL to return TRUE.
	nCONV: Default Value 0 (FALSE). Set to 1 (TRUE) if this script has to be run from a conversation.
*/

int StartingConditional(int nSKILL, int nLEVEL, int nEXACT = FALSE, int nCONV = FALSE)
{
	object oPC = OBJECT_SELF;
	if (nCONV == TRUE) oPC = GetPCSpeaker();
	int nBASE = GetSkillRank(nSKILL, oPC);
	if (nBASE < nLEVEL) return FALSE;
	if ((nEXACT == TRUE)&&(nBASE > nLEVEL)) return FALSE;
	return TRUE;
}