/*

    Script:			Called from other scripts for setting an area Flag based on the passed value
					If the flags are already set, don't do anything.
	Version:		1.1
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/04/2012 - 1.00 MV - Initial Release
					07/26/2015 - 1.1 MV - Added support for OFF Flags
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_se_include"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iFlags, int iFlagOff)
{
	// Get the current flags for the area.
	int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	int iOffFlags = 0;
	
	// Get the flags configured on myself.
	if (iFlags == 0)
	{
		iFlags = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag");
		iOffFlags = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyOffFlag");
	}
	else
	{
		// We need to change the state of the passed flag if it needs changing.
		if (iFlagOff == 1)
		{
			// We've been asked to turn this flag off
			iOffFlags = iFlags;
			iFlags = 0;	
		}	
	}
	
	// If the flags are already set do nothing.
	if ((iCurrentFlags & iFlags) && (iCurrentFlags ^ iOffFlags))
	{
		return;
	}
	else
	{
		// Set the flags and fire the SE Man's heartbeat event rather than wait 6 seconds.
		LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlags);
		LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iOffFlags, 1);
		object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
		LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iOffFlags);
		ExecuteScript("leg_quest_se_hb", oSEMan);
	}	
}