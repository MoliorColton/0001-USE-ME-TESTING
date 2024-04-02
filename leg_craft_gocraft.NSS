/*

    Script:			Our player has been delayed, and animated.  Now it's time to cut to the chase and
					actually perform some checks.  This is being called by the crafting station.  
					The only problem with ProgBar is figuring out who clicked the placeable object.  
					But it works LOL.  This script will call the Include Function for performing the craft.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					09/13/2012 - 1.1 MV - Added support for Craft All button to re-call ProgBar					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Cross fingers and hope this works.  What happens when 2 PC's are involved in crafting at this station
	// and one starts a progbar, and the other afterward.
	object oPC = GetLastUsedBy();

	// Let's pick up the chosen recipe index.
	int iRecipeIndex = GetLocalInt(oPC, "LEG_CRAFT_CURRENTRECIPE");
	
	// Ok, now we can pull up all the relevant information for this recipe.  There is an order
	// of operations here.  First, check for ingredients, then perform standard skill and durability
	// functions, then remove ingredients.  Or maybe remove ingredients first?  Hell I don't know
	// I just write this stuff up.
	LEG_CRAFT_Craft(oPC, OBJECT_SELF, iRecipeIndex);

    // Reduce the durabilities of the resource and the tool.
    string sTool = GetLocalString(OBJECT_SELF, "LEG_CRAFT_Skill_Tool");
	if (sTool != "")
	{
	    object oWeaponOnPlayer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	    LEG_CRAFT_ToolDurabilities(oPC, oWeaponOnPlayer);
	}
	
	// Free up the PC
    SetLocalInt(oPC, "SkillInUse", FALSE);
	SetLocalInt(OBJECT_SELF, "SkillInUse", FALSE);
}