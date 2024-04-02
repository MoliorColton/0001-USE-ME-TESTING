/*

    Script:			This script is called on placeable secret door to animate it's movement and reveal the 
					collision box that acts as a doorway.
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
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{ 
	object oBox = GetNearestObjectByTag("leg_spawn_secretbox");
	object oArea = GetArea(OBJECT_SELF);
	string sMyTag = GetTag(OBJECT_SELF);
	object oSpawner = GetObjectByTag(GetStringLeft(sMyTag, GetStringLength(sMyTag) - 3));
	float fFacing = GetFacing(OBJECT_SELF);
	float fSpawnerFacing = GetFacing(oSpawner);
	string sDirection = GetLocalString(oSpawner, "LEG_SPAWN_SECRET_Dir");
	int iDirection = 0;
	vector vCurrentPosition = GetPosition(OBJECT_SELF);
	vector vNewPosition = LEG_SPAWN_GetXY(fSpawnerFacing, sDirection, vCurrentPosition, FALSE);
	location lOriginalLocation = GetLocation(OBJECT_SELF);
	location lNewLocation = Location(GetArea(OBJECT_SELF), vNewPosition, fFacing);

	SetCollision(OBJECT_SELF, 0);
	SetUseableFlag(oBox, TRUE);

	SetLocalLocation(oArea, "LEG_SPAWN_DOORID" + sMyTag, lOriginalLocation);
	AddScriptParameterString(sMyTag);
	AddScriptParameterObject(oBox);
	AddScriptParameterObject(oSpawner);
	ExecuteScriptEnhanced("leg_spawn_secretdoor_reset", oArea);
	DelayCommand(1.0, AssignCommand(oBox, PlaySound("pl_grindstne_idle01")));
	LEG_COMMON_MovePlaceableToLocation(OBJECT_SELF, lNewLocation, 64, 0.5, 4.0, OBJECT_INVALID);
	

}