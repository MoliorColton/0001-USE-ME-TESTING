void main()
{
	object oPET = OBJECT_SELF;
	string sID = GetRosterNameFromObject(oPET);
	object oPC = GetFirstPC(FALSE);
	while (oPC != OBJECT_INVALID)
	{
		if (sID == "Pet_" + GetPCPlayerName(oPC)) return;
		oPC = GetNextPC(FALSE);
	}
	RemoveRosterMember(sID);
	SetIsDestroyable(TRUE);
	DestroyObject(oPET, 1.0);
}