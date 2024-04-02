/*
	Use this script to check quest progression during a conversation or an event.
	The script will return TRUE if the quest's stage of the character that calls the script is equal to or greather than nSTEP, unless nEXACT is set to TRUE.
	sQUEST: The ID of the journal entry that has to be checked.
	nSTEP: The state of the quest you wish for it to compared to.
	nEXACT: Default Value 0 (FALSE). Set to 1 (TRUE) if the quest's stage has to be exactly the same as nSTEP to return TRUE.
*/

int StartingConditional(string sQUEST, int nSTEP, int nEXACT = FALSE, int nCONV = FALSE)
{
	object oPC = OBJECT_SELF;
	if (nCONV == TRUE) oPC = GetPCSpeaker();
	int nQUEST = GetJournalEntry(sQUEST, oPC);
	if (nEXACT == TRUE)
	{
		if (nQUEST == nSTEP) return TRUE;
		else return FALSE;
	}
	else
	{
		if (nQUEST >= nSTEP) return TRUE;
		else return FALSE;
	}
}