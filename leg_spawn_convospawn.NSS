/*

    Script:			This script is fired when a Spawn Conversation calls it from an action node.
					It is a feature	that allows for a creature to speak to a player then activate 
					spawn points that are preconfigured on it.  Usually those spawn points are 
					set to one shot only.  The conversation mob can have multiple sets of spawn
					points and can fire a particular set depending on the conversation and the
					integer that is passed to this script.
	Version:		1.4
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		1.0 - MV - Initial Version
					11/02/2012 - 1.1 MV - Added catch to prevent multiple CheckSpawns from running simultaneously.
					11/09/2012 - 1.3 MV - Fixed bug that could cause double spawns.
					11/22/2012 - 1.4 MV - Don't bother running a spawn check if we're de-activating
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iSpawnID, int iActive)
{
	if (iActive == 0)
		iActive = 1;
	else
		iActive = 0;
		
	object oWP;
	int iSpawnMobs, iMobCount;
	int iCounter = 0;
	string sCounter;
	string sMobSpawn = GetLocalString(OBJECT_SELF, "LEG_SPAWN_MobSpawnName_" + IntToString(iSpawnID));
	if (sMobSpawn != "")
	{
		iSpawnMobs = 1;
		iMobCount = GetLocalInt(OBJECT_SELF, "LEG_SPAWN_MobSpawnCount_" + IntToString(iSpawnID));
		if (iMobCount == 0)
			iMobCount = 1;
			
		while (iCounter < iMobCount)
		{
			iCounter++;
			sCounter = IntToString(iCounter);
			if (iCounter < 10)
				sCounter = "0" + sCounter;
				
			oWP = GetWaypointByTag(sMobSpawn + "_" + sCounter);
			SetLocalInt(oWP, "LEG_SPAWN_TriggerSpawn", iActive);
		}
	}
	
	if (iSpawnMobs && iActive == FALSE)
	{
		object oArea = GetArea(OBJECT_SELF);
		object oHBMan = GetObjectByTag(GetTag(oArea) + "_legspawnheartbeat");
		LEG_SPAWN_CheckSpawns(oArea);
		DelayCommand(3.0, SetLocalInt(oHBMan, "SPAWN_BUSY", 0));
	}

}