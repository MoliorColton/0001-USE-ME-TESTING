/*

    Script:			Script that allows a player to travel through a placeable object to it's 
					destination waypoint when clicked on.
	Version:		1.0
	Plugin Version: 1.92
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.0 MV - Initial Release
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, string sWPName)
{
	// Just exit if the plugin is not active.
	if (!GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
		return;

	if (sWPName == "")
		return;

	// Get the destination
	object oChildWP = GetObjectByTag(sWPName);
		
	// Transport the PC to the location.
	if (GetIsObjectValid(oChildWP))
	{
		float fDelay = 0.1;
		DelayCommand(fDelay + 0.2, AssignCommand(oPC, ActionJumpToObject(oChildWP, FALSE)));
		// Transport any critters that's along for the ride with the PC.
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC)))
	    {
	        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC), JumpToObject(oChildWP, FALSE)));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC)))
	    {
	        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC), JumpToObject(oChildWP, FALSE)));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC)))
	    {
	        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC), JumpToObject(oChildWP, FALSE)));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC)))
	    {
	        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC), JumpToObject(oChildWP, FALSE)));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC)))
	    {
	        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC), JumpToObject(oChildWP, FALSE)));
	    }
	}
}