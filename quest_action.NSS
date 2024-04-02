/*
	Use this script to handle quest progression and make them persistent.
	sQUEST: The ID of the journal entry that has to be modified
	nSTEP: The state of the quest you wish for it to be set to. Set to 0 and nOVER to 1 (TRUE) if you wish to remove the journal entry.
	nXP: Default Value 0. How much XP is granted by the quest update.
	nQP: Default Value 0. How many Quest Points are awarded by the quest update. Negative values will remove Quest Points.
	nCONV: Default Value 0 (FALSE). Set to 1 (TRUE) if this is called from a conversation.
	nPARTY: Default Value 0 (FALSE). Set to 1 (TRUE) if you wish the quest to apply to all party members of the speaker
	nOVER: Default Value 0 (FALSE). Set to 1 (TRUE) if you wish to override the state of a quest lower than what it's currently on.
*/

void main(string sQUEST, int nSTEP, int nXP = 0, int nQP = 0, int nCONV = FALSE, int nPARTY = FALSE, int nOVER = FALSE)
{
	object oPC = OBJECT_SELF;
	if (nCONV == TRUE) oPC = GetPCSpeaker();
	object oITEM = GetItemPossessedBy(oPC, "player_essence");
	int nPOINTS;
	int nSTATE = GetLocalInt(oITEM, "QUEST_" + sQUEST);
	if (nSTEP > 0) AddJournalQuestEntry(sQUEST, nSTEP, oPC, nPARTY, FALSE, nOVER);
	else if (nOVER == TRUE) RemoveJournalQuestEntry(sQUEST, oPC, nPARTY);
	if ((nOVER == TRUE)||(nSTEP > nSTATE))
	{
		nPOINTS = GetLocalInt(oITEM, "QUEST_POINTS");
		SetLocalInt(oITEM, "QUEST_" + sQUEST, nSTEP);
		SetLocalInt(oITEM, "QUEST_POINTS", nPOINTS + nQP);
		if (nQP > 0) FloatingTextStringOnCreature("You gained " + IntToString(nQP) + " Quest Points.", oPC, FALSE);
		else if (nQP < 0) FloatingTextStringOnCreature("You lost " + IntToString(nQP) + " Quest Points.", oPC, FALSE);
		GiveXPToCreature(oPC, nXP);
	}
	if (nPARTY == TRUE)
	{
		object oPARTY = GetFirstFactionMember(oPC);
		while (oPARTY != OBJECT_INVALID)
		{
			if (oPARTY != oPC)
			{
				oITEM = GetItemPossessedBy(oPARTY, "player_essence");
				nSTATE = GetLocalInt(oITEM, "QUEST_" + sQUEST);
				if ((nOVER == TRUE)||(nSTEP > nSTATE))
				{
					nPOINTS = GetLocalInt(oITEM, "QUEST_POINTS");
					SetLocalInt(oITEM, "QUEST_" + sQUEST, nSTEP);
					SetLocalInt(oITEM, "QUEST_POINTS", nPOINTS + nQP);
					if (nQP > 0) FloatingTextStringOnCreature("You gained " + IntToString(nQP) + " Quest Points.", oPARTY, FALSE);
					else if (nQP < 0) FloatingTextStringOnCreature("You lost " + IntToString(nQP) + " Quest Points.", oPARTY, FALSE);
					GiveXPToCreature(oPARTY, nXP);
				}
			}
			oPARTY = GetNextFactionMember(oPC);
		}
	}	
}