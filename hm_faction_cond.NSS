int StartingConditional(int iNumber)
	{
	object oSource		= GetObjectByTag("hm_fr_"+IntToString(iNumber));
	string sFaction		= GetLocalString(oSource, "sFaction");	
	int iFactionToken 	= 2340 + iNumber;
		
	if (sFaction == "EMPTY")
		{
		return FALSE;
		}
	else
		{
		SetCustomToken(iFactionToken, sFaction);
		return TRUE;
		}
	}