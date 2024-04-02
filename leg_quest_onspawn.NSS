/*

    Script:			What happens when we're using the quest plugin and something spawns!
	Version:		1.0
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		07/26/2015 - 1.0 MV - Initial Release
					
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
	// I just spawned!  Is there any Special Effect flags I should turn on?
	int iMyOffFlagID = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "OffSpawn");
	LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "Spawn"));
	LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, 1);
	
	object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
	LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyOffFlagID);
	ExecuteScript("leg_quest_se_hb", oSEMan);
}