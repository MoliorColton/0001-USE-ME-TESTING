/*

    Script:			This script us placed on a placeable object that is useable that will act as a site
					for player location binding.  Once bound, a standard teleporter object can then 
					return a player to this site.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/18/2012 - 1.0 MV - Initial Release
					12/27/2013 - 1.1 MV - Added support to display bind location when examining bind fragment.
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oPC = GetPlaceableLastClickedBy();
	if (!GetIsObjectValid(oPC))
		oPC = GetLastUsedBy();
		
	// Bind the player
	SetPersistentLocation(oPC, "BindLocation", GetLocation(oPC), 0, TELEPREFIX + "_campsite");
	
	// Set the description of the players bind stone to the location.
	object oArea = GetArea(oPC);
	object oBindFrag = LEG_COMMON_GetInventoryItemByTag(oPC, "bindstone");
	SetDescription(oBindFrag, "<color=red>Currently Bound: " + GetName(oArea) + "This stone is used to recall to an adventurers bind point.  It can be used once every 30 minutes.");
	
	// Bind Effect
	effect eEffect = EffectVisualEffect(VFX_IMP_RESTORATION);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);
	DelayCommand(1.0, ExecuteScript("leg_tele_savecampsite", oPC));
	LEG_COMMON_DisplayInfoBox(oPC, "You are now bound to this location");
}