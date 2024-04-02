/*

    Script:			Called by the SE Man's heartbeat.  The SE man is the controller for nearby special effects.
					He is an invisible placeable object that is spawned when needed and manages special effects
					that are configured on it's waypoint.  This is his heartbeat where he checks area flags
					and causes reactions according to the configuration on his waypoint.
	Version:		1.3
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/04/2012 - 1.00 MV - Initial Release
					05/31/2015 - 1.1 MV - Added support to set a flag based on time of day for the area.
					07/24/2015 - 1.2 MV - Added ability to change SE Man to it's spawning WP Name for AOE Effects
					07/26/2015 - 1.3 MV - Added support for OFF Flags
					
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
	// New HB script.	
	object oSelf = OBJECT_SELF;
	object oSE = GetLocalObject(oSelf, "SPAWN_Parent");
		
	// If something goes wrong, exit.
	if (!GetIsObjectValid(oSE))
		return;
	
	// Sanity check
	if (GetLocalInt(oSelf, "BUSY"))
		return;
		
	// I am now busy.
	SetLocalInt(oSelf, "BUSY", TRUE);
	
	// Make sure my name is correct
	SetFirstName(OBJECT_SELF, GetFirstName(oSE));
	
	// See if we can set a flag based on time of day for this area.  This manager can hold multiple times.
	int iTotalTimes = GetLocalInt(oSE, "LEG_QUEST_SE_TotalTimes");
	if (iTotalTimes > 0)
	{
		// Looks like we have one or more times to check.
		string sTimeID;
		int iIndex = 0, iFlags = 0, iOffFlags = 0, iCurrentFlags = 0, iTimeOfDayStart = 0, iTimeOfDayEnd = 0, iSetFlagOn = 0;
		for (iIndex = 1; iIndex <= iTotalTimes; iIndex++)
		{
			// Get the ID Counter setup
			sTimeID = IntToString(iIndex);
			
			iFlags = GetLocalInt(oSE, "LEG_QUEST_SE_MyFlag_" + sTimeID);
			iOffFlags = GetLocalInt(oSE, "LEG_QUEST_SE_MyOffFlag_" + sTimeID);
			
			// Get Current Flags
			iCurrentFlags = GetLocalInt(GetArea(oSelf), "QUEST_SE_Flags1");

			
			// Get time of day I'm supposed to set this flag.
			iTimeOfDayStart = GetLocalInt(oSE, "LEG_QUEST_SE_MyFlagTime_" + sTimeID);
			iTimeOfDayEnd = GetLocalInt(oSE, "LEG_QUEST_SE_MyFlagTimeEnd_" + sTimeID);
			iSetFlagOn = LEG_QUEST_SER_CheckTOD(IntToString(iTimeOfDayStart), IntToString(iTimeOfDayEnd));
			
			if (iSetFlagOn)
			{
				// It's the right time of day.  But are our flags already on?
				if ((iCurrentFlags & iFlags) && (iCurrentFlags ^ iOffFlags))
				{
					// Do nothing.	
				}
				else
				{
					// Set the flags and fire the SE Man's heartbeat event rather than wait 6 seconds.
					LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlags);
					LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iOffFlags, 1);
					LEG_QUEST_SE_DeactivateActiveFlag(oSelf, iOffFlags);
				}
			}
			else
			{
				// We're outside of our window to set this flag on.  We can do nothing, or we can check to see
				// if we're supposed to turn these flags off.
				int iTurnFlagsOffOutside = GetLocalInt(oSE, "LEG_QUEST_SE_MyFlagTimeOffOutside_" + sTimeID);
				if (iTurnFlagsOffOutside)
				{
					LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iOffFlags);
					LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlags, 1);
					LEG_QUEST_SE_DeactivateActiveFlag(oSelf, iFlags);
				}
			}
		}
	}
	
	// Fire the Reactions
	LEG_QUEST_SE_GoReactions(oSE);
	
	// Clean up
	SetLocalInt(oSelf, "BUSY", FALSE);	
}