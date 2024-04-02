int StartingConditional()
{
	int nBAG = 0;
	int nITEM = 0;
	object oBAG;
	object oPC = GetPCSpeaker();
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != OBJECT_INVALID)
	{
		if (nBAG > 0) nBAG = nBAG - 1;
		else
		{
			nITEM = nITEM + 1;
			if (GetHasInventory(oITEM) == TRUE)
			{
				oBAG = GetFirstItemInInventory(oITEM);
				while (oBAG != OBJECT_INVALID)
				{
					nBAG = nBAG + 1;
					oBAG = GetNextItemInInventory(oITEM);
				}
			}
		}
		oITEM = GetNextItemInInventory(oPC);
	}
	if (nITEM > 127) return TRUE;
	return FALSE;
}