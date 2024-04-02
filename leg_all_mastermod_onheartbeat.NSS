/*

    Script:			This is the MASTER on heartbeat script.  It is primarily used for the Time Plugin and dungeon instances but
					can be used for other things if we ever come up with something to use for it.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		10/08/2012 - 1.0 MV - Initial Release
					05/11/2015 - 1.0 MV - Update for World Plugin heartbeats.
					05/13/2015 - 1.0 MV - Update for Time Plugin heartbeats.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oMODULE = GetModule();
	
	int nCLEAN = GetLocalInt(oMODULE, "MODULE_CLEANUP");
	if (nCLEAN < 20) SetLocalInt(oMODULE, "MODULE_CLEANUP", nCLEAN + 1);
	else
	{
		object oITEM;
		object oINVALID = OBJECT_INVALID;
		object oAREA = GetFirstArea();
		while (oAREA != oINVALID)
		{
			oITEM = GetFirstObjectInArea(oAREA);
			while (oITEM != oINVALID)
			{
				if (GetObjectType(oITEM) == OBJECT_TYPE_ITEM)
				{
					if (GetItemPossessor(oITEM) == oINVALID)
					{
						if (GetLocalInt(oITEM, "MODULE_CLEANUP") == TRUE) DestroyObject(oITEM);
						else SetLocalInt(oITEM, "MODULE_CLEANUP", TRUE);
					}
				}
				oITEM = GetNextObjectInArea(oAREA);
			}
			oAREA = GetNextArea();
		}
		DeleteLocalInt(oMODULE, "MODULE_CLEANUP");
	}
	
	/*
	// Check for the Time Plugin and fire its script if it is.
	if (GetLocalInt(GetModule(), "LEG_TIME_ACTIVE")) ExecuteScriptEnhanced("leg_time_modheartbeat", oMODULE);
	
	// Check for the Tele Plugin and fire its script if it is.
	if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE")) ExecuteScriptEnhanced("leg_tele_modheartbeat", oMODULE);
	
	// Check for the Tele Plugin and fire its script if it is.
	if (GetLocalInt(GetModule(), "LEG_WORLD_ACTIVE")) ExecuteScriptEnhanced("leg_world_modheartbeat", oMODULE);		
	*/
	
}