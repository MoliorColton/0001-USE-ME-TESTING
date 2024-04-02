/*

    Script:			Called from a placeables On-Used Event for setting an area Flag based on the variables the 
					placeable object has configured on it when the passed angle is met.  Each click of the placeable
					rotates the object in a certain direction.  Once the angle has passed, the flags are reversed if
					the Toggle is allowed.
	Version:		1.0
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		08/13/2015 - 1.1 MV - Initial Release
					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_se_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// LOCAL FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void LEG_QUEST_SE_ROTATE_SetFlags(int bAngleMet)
{
	// Flag activation and deactivation.  If Flags are already ON, do nothing unless we're allowed to toggle.  If that's the case, we de-activate.
	int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag");
	int iMyOffFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyOffFlag");
	int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");	
	object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
	
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
	else if (bAngleMet == TRUE)
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

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	int iMyPreReqFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyPreReqFlag");
	int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	
	// Vars specific to rotating placeables
	int iRemoveItem = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_RemoveItem");
	int iAngle = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Angle");
	int iRadials = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Radials");
	string sItemTag = GetLocalString(OBJECT_SELF, "LEG_QUEST_SE_ItemReq");
	
	object oPC = GetLastUsedBy();
	if (!GetIsObjectValid(oPC))
	{
		oPC = GetEnteringObject();
	}
	
	// Only run for players
	if (!GetIsPC(oPC))
	{
		return;
	}
	
	// If there is an item required, and the PC doesn't have it, let them know and exit.
	if (sItemTag != "")
	{
		if (LEG_COMMON_GetInventoryCount(oPC, sItemTag) > 0)
		{
			// Player has inventory item, potentially destroy it.
			if (iRemoveItem == 1)
				LEG_COMMON_DestroyItemsByTag(oPC, sItemTag, -1);
		}
		else
		{
			// Inform player they are missing an item.
			string sNoItemFeedBack = GetLocalString(OBJECT_SELF, "LEG_QUEST_SE_NoItemFeedBack");		
			if (sNoItemFeedBack != "")
				LEG_COMMON_DisplayInfoBox(oPC, sNoItemFeedBack);		
			else
				LEG_COMMON_DisplayInfoBox(oPC, "You appear to be missing something");	
			return;
		}
	
	}

	// Check standard pre-reqs
	int iHasReqs = LEG_QUEST_REQ_HasReqs(oPC, OBJECT_SELF);
	if (iHasReqs)
	{
	
		// Check if PreReq flags are set ON.  No, I'm not going there...
		if (iCurrentFlags & iMyPreReqFlagID || iMyPreReqFlagID == 0)
		{
			// All is good, pre-reqs are on.
		}
		else
		{
			string sPreReqFeedBack = GetLocalString(OBJECT_SELF, "LEG_QUEST_SE_PreReqFeedBack");
			if (sPreReqFeedBack != "")
				LEG_COMMON_DisplayInfoBox(oPC, sPreReqFeedBack);
			return;
		}
	
		
		// If we met our Angle, then go ahead and activate
		int bAngleMet = FALSE;
		
		// New Facing
		float fNewFacing = 0.0;
		
		// Am I a rotato?
		if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Rotato"))
		{
			int iFacing = FloatToInt(GetFacing(OBJECT_SELF));
			// What Direction
			int iClockwise = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Clockwise");
			
			
			// What is my current facing, and what WILL it be?
			int iRadialDegrees = 360 / iRadials;
			int iCounter = 0, iCurrentDegree, iMyNextRadial;
	
			for (iCounter = 0; iCounter <= iRadials; iCounter++)
			{
				iCurrentDegree = iCounter * iRadialDegrees;
				if (iClockwise == 1)
				{
					if (iFacing == 0)
						iFacing = 360;
					if (iFacing - iCurrentDegree <= iRadialDegrees)
					{
						iMyNextRadial = iCounter;
						break;
					}
				}
				else
				{
					if (iCurrentDegree - iFacing <= iRadialDegrees && iCurrentDegree - iFacing > 0)
					{
						iMyNextRadial = iCounter;
						break;
					}
				}
			}
			
			int iNewFacing = iMyNextRadial * iRadialDegrees;
			if (iNewFacing >= 360)
				iNewFacing = 0;
			fNewFacing = IntToFloat(iNewFacing);
	
			// If the new Facing matches what our Angle needs to be, then we'll be setting flags.
			if (fNewFacing == IntToFloat(iAngle))
				bAngleMet = TRUE;
				
			if (iAngle == -1)
				bAngleMet = TRUE;
				
			// SetFlags
			DelayCommand(4.0, LEG_QUEST_SE_ROTATE_SetFlags(bAngleMet));
		
			// At least make a delay
			LEG_COMMON_ProgBar(oPC, 4, "Moving " + GetName(OBJECT_SELF));
			PlaySound("pl_grindstne_idle01");
			SetUseableFlag(OBJECT_SELF, FALSE);
			
			//SetFacing(fNewFacing);
			DelayCommand(1.8, SetFacing(fNewFacing));
			DelayCommand(2.0, LEG_COMMON_ForceFacing(fNewFacing));
			DelayCommand(2.5, LEG_COMMON_ForceFacing(fNewFacing));	
			DelayCommand(5.5, SetUseableFlag(OBJECT_SELF, TRUE));
			
			// Feedback
			string sFeedBack = GetLocalString(OBJECT_SELF, "LEG_QUEST_SE_FeedBack");		
			if (sFeedBack != "")
				LEG_COMMON_DisplayInfoBox(oPC, sFeedBack);		
		}	
	}
}