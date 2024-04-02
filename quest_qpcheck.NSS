/*
	Use this script to check quest points thresholds during a conversation or an event.
	The script will return TRUE if quest points of the character that calls the script is equal to or greather than nQP, unless nEXACT is set to TRUE.
	nQP: The ID of the journal entry that has to be checked.
	nEXACT: Default Value 0 (FALSE). Set to 1 (TRUE) if QP have to be the exactly the same as the specified amount to return TRUE.
	nCONV: Default Value 0 (FALSE). Set to 1 (TRUE) if this is called from a conversation.
*/

int StartingConditional(int nQP, int nEXACT = FALSE, int nCONV = FALSE)
{
	object oPC = OBJECT_SELF;
	if (nCONV == TRUE) oPC = GetPCSpeaker();
	object oITEM = GetItemPossessedBy(oPC, "player_essence");
	int nPOINTS = GetLocalInt(oITEM, "QUEST_POINTS");
	if (nEXACT == TRUE)
	{
		if (nPOINTS == nQP) return TRUE;
		else return FALSE;
	}
	else
	{
		if (nPOINTS >= nQP) return TRUE;
		else return FALSE;
	}
}