/*

    Script:			This is the QUEST on end of round script.  It's called by the AI plugin's end of round
					script which in turn calls the master end of round script.  If the quest plugin is 
					installed and active, this fires.  It's used for things like setting an SE flag for the
					SE plugin.
	Version:		1.2
	Plugin Version: 1.94
	Author:			Marshall Vyper
	
	Change Log:		05/30/2015 - MV - Initial Version
					07/26/2015 - 1.2 MV - Added support for OFF Flags
	
	
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
	object oNearest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF);
	
	if(GetCurrentHitPoints() <= 1 && !IsMarkedAsDone())
	{
		int iTotalNearDeaths = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_TotalNearDeaths");
		if (iTotalNearDeaths > 0)
		{
			// Looks like we have one or more times to check.
			string sNearDeathID;
			int iIndex = 0, iFlags = 0, iOffFlags = 0, iCurrentFlags = 0, iMyPreReqFlagID = 0;
			for (iIndex = 1; iIndex <= iTotalNearDeaths; iIndex++)
			{
				// Get the ID Counter setup
				sNearDeathID = IntToString(iIndex);
				
				iFlags = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_NDMyFlag_" + sNearDeathID);
				iOffFlags = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_NDMyOffFlag_" + sNearDeathID);
				iMyPreReqFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_NDMyPreReqFlag_" + sNearDeathID);
				
				// Get Current Flags
				iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	
				// Check if PreReq flags are set ON.  No, I'm not going there...
				if ((iCurrentFlags & iMyPreReqFlagID) || iMyPreReqFlagID == 0)
				{
					// All is good, pre-reqs are on.	
				}
				else
					return;
				
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
					object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
					LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iOffFlags);
					ExecuteScript("leg_quest_se_hb", oSEMan);

					// In rare situations, I've seen the end of round fire and the mob was still at 1 HP.  The first EOR, the first flag is set,
					// Then before HP's are restored, a second EOR occured.  This caused the second near death flag to fire because they were still
					// at 1 HP.  Add a couple HP here to prevent this.
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() - GetCurrentHitPoints()), OBJECT_SELF);

					// We don't allow multiples right away so we abort out of this script once we fire one.
					return;
				}
			}
		}
		else
		{
			// For Legacy Pre 2.0 versions.
			int iFlags = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "NearDeath");
			int iOffFlags = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "OffNearDeath");
			if (iFlags > 0 || iOffFlags > 0)
			{
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlags);
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iOffFlags, 1);
				object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
				ExecuteScript("leg_quest_se_hb", oSEMan);		
			}
		}
	}
}