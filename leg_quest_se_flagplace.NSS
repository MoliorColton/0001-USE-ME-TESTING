/*

    Script:			Called from a placeables On-Used Event for setting an area Flag based on the variables the 
					placeable object has configured on it.  If the flags are already set, don't do anything.
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
void main()
{
	// Get Pre-Reqs
	object oPC = GetLastUsedBy();
	int iHasReqs = 1;
	if (GetIsPC(oPC) || GetIsPC(GetOwnedCharacter(oPC)))
	{
		if (GetIsOwnedByPlayer(oPC))
			oPC = GetOwnedCharacter(oPC);
		
		// Check Requirements of the PC for this trigger.
		iHasReqs = LEG_QUEST_REQ_HasReqs(oPC, OBJECT_SELF);
	}
	
	if (iHasReqs)
	{

		// Get the current flags for the area.
		int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
		
		// Get the flags configured on myself.
		int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag");
		int iMyOffFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyOffFlag");
		
		// If the flags are already set on and off flags are already set off do nothing.
		if  ((iCurrentFlags & iMyFlagID) && (iCurrentFlags ^ iMyOffFlagID))
			return;
		else
		{
			// Set the flags and fire the SE Man's heartbeat event rather than wait 6 seconds.
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlagID);
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, 1);
			object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
			LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyOffFlagID);
			ExecuteScript("leg_quest_se_hb", oSEMan);
		}
	}
}