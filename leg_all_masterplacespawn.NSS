/*

    Script:			This is the MASTER on spawn script for placeables.  There is no built in on Spawn event for
					placeable objects however the Legends Spawn plugin CAN spawn placeables.  As such, the Legends
					SPAWN plugin will call this script to handle any spawn in events desired by other plugins for
					placeable objects.
	Version:		1.0
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		N/A

	Change Log:		07/26/2015 - MV 1.0 - Initial Revision
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oTarget = OBJECT_SELF;

	// If the QUEST plugin is active, we have things to do when mobs die!
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
	{
		ExecuteScript("leg_quest_onspawn", oTarget);
	}	
}