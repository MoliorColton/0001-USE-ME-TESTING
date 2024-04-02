int GetHasPolymorph(object oPC)
{
	if (GetPolymorphLocked(oPC) == 1) return TRUE;
	effect eFX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eFX) == TRUE)
	{
		if (GetEffectType(eFX) == EFFECT_TYPE_POLYMORPH) return TRUE;
		eFX = GetNextEffect(oPC);
	}
	return FALSE;
}


void main()
{
	object oMOD = OBJECT_SELF;
	float fTIME = GetLocalFloat(oMOD, "SAVE_TIMER");
	if (fTIME < 300.0)
	{
		SetLocalFloat(oMOD, "SAVE_TIMER", fTIME + 6.0);
		return;
	}
	object oINVALID = OBJECT_INVALID;
	object oPC = GetFirstPC();
	while (oPC != oINVALID)
	{
		if (GetHasPolymorph(oPC) == FALSE) 
		{
			SendMessageToPC(oPC, "Character Saved.");
			ExportSingleCharacter(oPC);
		}
		oPC = GetNextPC();
	}
	DeleteLocalFloat(oMOD, "SAVE_TIMER");
	// Call the CheckEquippedItems function in the module heartbeat
}