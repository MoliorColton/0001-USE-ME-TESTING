/*

    Script:			This script allows other plugins to force a Check Spawn immediately rather than wait for the 
					HBMAN to fire which can take up to one minute.  Handy for when Quest Based Spawns need to appear
					as soon as a PC accepts a quest.
	Version:		1.3
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		12/16/2010 - Initial Release
					10/14/2012 - Added support for new spawning Range Based system
					11/02/2012 - 1.2 MV - Added catch to prevent multiple CheckSpawns from running simultaneously.					
					11/09/2012 - 1.3 MV - Fixed bug that could cause double spawns.
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
	// Get the Area of the Caller if we need to spawn this in this area.  Otherwise, nothing will
	// happen and the spawn will activate when the PC enters the appropriate area.
	object oArea = GetArea(OBJECT_SELF); 

	// Now we should see about spawning new stuff.  If Mr. HBMan is processing spawns every round
	// then we don't need to call this (it could cause double mob spawn).  If however he has
	// completed the whole area and is settled back into processing per minute, then lets call this.
	if (!GetLocalInt(oArea, "SPAWN_Incomplete"))
	{
		object oHBMan = GetObjectByTag(GetTag(oArea) + "_legspawnheartbeat");
		LEG_SPAWN_CheckSpawns(oArea);
		DelayCommand(3.0, SetLocalInt(oHBMan, "SPAWN_BUSY", 0));
	}
}