/*

    Script:			This script is the HBMan's heartbeat.  He controls what goes on in an area with respect to spawns.
					Note, he only exists if players are in an area.  If the area is empty, he does not exist.  Think
					of him like a spawned wandering Orc that you can't interact with and is only around when players
					are near.
	Version:		2.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		11/26/2010 - Initial Release
					10/16/2011 - 1.60 MV - Fixed major bug in area despawn routines.
					09/19/2012 - 1.7 MV - Added SetClockOnForAllPlayers (perhaps will fix report of clock hang)
					09/26/2012 - 1.8 MV - Removed SetClock / Time system to Stand Alone plugin.
					11/02/2012 - 1.9 MV - Added catch to prevent multiple CheckSpawns from running simultaneously.
					11/09/2012 - 2.0 MV - Fixed bug that could cause double spawns.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oArea = GetArea(OBJECT_SELF); 

	// Run this only once every minute.
	int iCurrentTime = LEG_COMMON_TimeStamp();
	int iLastTime = GetLocalInt(OBJECT_SELF, "LastTime");

	if (iCurrentTime >= iLastTime + REAL_MINUTES)
	{
		if (!GetLocalInt(OBJECT_SELF, "STOP"))
		{
			// Now we should see about spawning new stuff.
			LEG_SPAWN_CheckSpawns(oArea);
			DelayCommand(3.0, SetLocalInt(OBJECT_SELF, "SPAWN_BUSY", 0));
			SetLocalInt(OBJECT_SELF, "LastTime", iCurrentTime);
		}
	}
	else
	{
		// Check for incomplete spawns due to PC range
		if (GetLocalInt(oArea, "SPAWN_Incomplete"))
		{
			SetLocalInt(oArea, "SPAWN_Incomplete", FALSE);
			LEG_SPAWN_CheckSpawns(oArea);
			DelayCommand(3.0, SetLocalInt(OBJECT_SELF, "SPAWN_BUSY", 0));
		}
	}
}