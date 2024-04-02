/*

    Script:			This script is called on the area by the leg_spawn_secretdoor_open script.  Due to the nature of the placeable movement functions, the
					original door is destroyed and so can't run code so prior to its destruction, we run this script on the Area the door is in which contains
					the code to re-close the door.
	Version:		1.0
	Plugin Version: 1.94
	Author:			Marshall Vyper

	Change Log:		11/26/2010 - 1.0 MV - Initial Release
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// LOCAL FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// Wrapper for finding secret doors so we can use a DelayCommand on it.
// string sDoorID			- TAG of the Secret Door we need to find
// object oDoorway			- Invisible collision box Doorway
//	Returns: N/A
void LEG_SPAWN_SECRET_GetSecretDoor(string sDoorID, object oDoorway, object oSpawner)
{
	object oSecretDoor = GetObjectByTag(sDoorID);
	vector vCurrentPosition = GetPosition(oSecretDoor);
	string sDirection = GetLocalString(oSpawner, "LEG_SPAWN_SECRET_Dir");
	float fSpawnerFacing = GetFacing(oSpawner);
	vector vNewPosition = LEG_SPAWN_GetXY(fSpawnerFacing, sDirection, vCurrentPosition, TRUE);
	float fFacing = GetFacing(oSecretDoor);
	location lNewLocation = Location(GetArea(oSecretDoor), vNewPosition, fFacing);
	
	DelayCommand(1.0, AssignCommand(oDoorway, PlaySound("pl_grindstne_idle01")));
	DelayCommand(0.5, SetUseableFlag(oDoorway, FALSE));
	LEG_COMMON_MovePlaceableToLocation(oSecretDoor, lNewLocation, 64, 0.5, 4.0, OBJECT_INVALID);	
}



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(string sDoorID, object oDoorway, object oSpawner)
{
	float fReset = 60.0 * IntToFloat(GetLocalInt(oSpawner, "LEG_SPAWN_DeSpawnMins"));
	DelayCommand(fReset, LEG_SPAWN_SECRET_GetSecretDoor(sDoorID, oDoorway, oSpawner));	
}