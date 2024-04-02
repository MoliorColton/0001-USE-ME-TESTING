/*

    Script:			Called from a placeables On-Used Event for setting an area Flag based on the variables the 
					placeable object has configured on it.  This is a more advanced version allowing the 
					placeable object to behave like a toggle as well.  Cool for using with level combination
					lock type setups.
	Version:		1.5
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/04/2012 - 1.00 MV - Initial Release
					06/07/2015 - 1.1 MV - Only fire if used/crossed by a player
					07/20/2015 - 1.4 MV - When toggle switches are turned off, allow re-run of flag parameters it matches.
					07/26/2015 - 1.5 MV - Added support for OFF Flags
					
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
	int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag");
	int iMyOffFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyOffFlag");
	int iMyPreReqFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyPreReqFlag");
	object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
	
	object oPC = GetLastUsedBy();
	if (!GetIsObjectValid(oPC))
		oPC = GetEnteringObject();
	
	// Only run for players
	if (!GetIsPC(oPC))
		return;

	// Check if PreReq flags are set ON.  No, I'm not going there...
	if ((iCurrentFlags & iMyPreReqFlagID) || iMyPreReqFlagID == 0)
	{
		// All is good, pre-reqs are on.	
	}
	else
		return;

	// Get Pre-Reqs
	int	iHasReqs = LEG_QUEST_REQ_HasReqs(oPC, OBJECT_SELF);
	if (iHasReqs)
	{
		
		// Am I a lever?
		if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Lever"))
		{
			PlaySound("as_sw_lever1");
			int nActive = GetLocalInt(OBJECT_SELF,"SE_LeverState");
			if (!nActive)
			{
				ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
			}
			else
			{
				ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
			}
			SetLocalInt(OBJECT_SELF,"SE_LeverState",!nActive);
			
		}	
			
		if ((iCurrentFlags & iMyFlagID) && (iCurrentFlags ^ iMyOffFlagID))
		{
			if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_AllowToggle"))
			{
				// Just toggled this off so remove it from the oSEMan
				int iIndex = LEG_COMMON_SearchArrayElement(oSEMan, "SE_OBJECT_STATES", GetTag(OBJECT_SELF));
				LEG_COMMON_DeleteArrayElement(oSEMan, "SE_OBJECT_STATES", iIndex);
			
				// Flag is ON Currently.
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlagID, TRUE);
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, FALSE);
				LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyFlagID);			
				ExecuteScript("leg_quest_se_hb", oSEMan);
			}
			return;
		}
		else
		{
			// Add this object so that we can turn its flags off forcibly.
			LEG_COMMON_AddArrayElement(oSEMan, "SE_OBJECT_STATES", GetTag(OBJECT_SELF));
		
			// Flag is OFF Currently.
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlagID);
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, 1);
			LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyOffFlagID);
			ExecuteScript("leg_quest_se_hb", oSEMan);
		}	
	}
}