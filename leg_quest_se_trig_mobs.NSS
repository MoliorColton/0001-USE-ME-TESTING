/*

    Script:			Called from a placeables On-Used Event for setting an area Flag based on the variables the 
					placeable object has configured on it.  This is a more advanced version allowing the 
					placeable object to behave like a toggle as well.  Cool for using with level combination
					lock type setups.  This is identical to leg_quest_se_trig however that one only fires 
					when a player triggers it.  This one can fire for mobs as well.  Useful for when a mob
					reaches a WP etc.
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/07/2015 - 1.0 MV - Initial Release
					07/26/2015 - 1.1 MV - Added support for OFF Flags
					08/15/2015 - 1.2 MV - Added support for PreReq Flags
	
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
	object oPC = GetLastKiller();
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
	
		int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
		int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag");
		int iMyOffFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyOffFlag");
		int iMyPreReqFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyPreReqFlag");
		
		object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
		
		// Check if PreReq flags are set ON.  No, I'm not going there...
		if ((iCurrentFlags & iMyPreReqFlagID) || iMyPreReqFlagID == 0)
		{
			// All is good, pre-reqs are on.	
		}
		else
			return;
		
			
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
				LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyOffFlagID);
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