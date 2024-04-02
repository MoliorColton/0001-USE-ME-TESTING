/*

    Script:			This script is called to set a flag on a mob or placeable death.
	Version:		1.1
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		07/17/2015 - 1.0 MV - Initial Release
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
	object oPC = GetLastKiller();
	int iHasReqs = 1;
	int iFlags = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "Death");
	int iOffFlags = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "OffDeath");
	
	if (iFlags > 0 || iOffFlags > 0)
	{
		if (GetIsPC(oPC) || GetIsPC(GetOwnedCharacter(oPC)))
		{
			if (GetIsOwnedByPlayer(oPC))
				oPC = GetOwnedCharacter(oPC);
			
			// Check Requirements of the PC for this trigger.
			iHasReqs = LEG_QUEST_REQ_HasReqs(oPC, OBJECT_SELF);
		}
		
		if (iHasReqs)
		{
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlags);
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iOffFlags, 1);
			object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
			LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iOffFlags);
			ExecuteScript("leg_quest_se_hb", oSEMan);
		}
	}
}