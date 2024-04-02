//-----------------------------------------------------------------------
// <copyright file="gui_leg_craft_startcraft.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			Script that is called when the PC clicks the "Craft" button at a tradeskill station.
					It will ensure the PC has a craft item chosen, then fire the progress bar if the info
					plugin is active which in turn will call the GO Craft script or direct to the GO 
					Craft script if it is not.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					09/13/2012 - 1.1 MV - Added support for Craft All button on stations
										- Perform Ingredient and Skill check PRIOR to progbar
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iRecipeIndex, int iCraftAll, string sNoExceptionals)
{
	// Set the PC
	object oPC = OBJECT_SELF;
	
	// First let's make sure a recipe was selected.
	// Ensure the PC has selected one of the available rewards if there are any.
	if (iRecipeIndex == 0)
	{
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(oPC, "Choose a Recipe");
		else
			FloatingTextStringOnCreature("Choose a Recipe", oPC, FALSE);
		return;
	}

	// If a recipe has been selected then let's go crafting!
	CloseGUIScreen(oPC, "crafting");

	// Clean up just in case we were stuck in a Craft All loop
	SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
	SetLocalInt(oPC, "LEG_INFO_PROGBARCANCEL", FALSE);

	// Get the crafting station.
	object oStation = GetLocalObject(oPC, "CNPC");
	
	// Now if we have the Info Plugin in active, we want to do a ProgBar, otherwise, let's do a delay and then
	// fire off the leg_craft_gocraft script which is the script that does the checks and all that good stuff.
	// Only issue we have to deal with is by launching a new script, we lose our chosen recipie so we have
	// to temporarily store that on the PC.
	SetLocalInt(oPC, "LEG_CRAFT_CURRENTRECIPE", iRecipeIndex);		
	
	// New in 1.8 - Before we continue, let's see if the PC has the skill to actually
	// craft the recipe BEFORE we fire the progress bar.
    // See if the PC has the skill and at least has minimum score.  If the BASE skill is 0, the

	// See if the Info plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");

	// Get the Module Object
	object oModule = GetModule();

    // Look up the main stats for the resource.
    int iSkill = GetLocalInt(oStation, "LEG_CRAFT_Skill");
    int iMin = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMin", iRecipeIndex));
	int iMax = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMax", iRecipeIndex));
	
	// Calulate Chances for PC to succeed.  Here, we find out the chance PER skill point
	// in the category.  There are 10 difficulty categories.
    float fChancePer = 1.0 / IntToFloat((iMax - iMin + 1));
    int iTrivial = FALSE;
    int iChance = 0;
    int iQty = 0;
	
	// Find out what the player's skill is with bonuses.
    int iPCSkill = LEG_CRAFT_GetPCSkill(oPC, iSkill);
	
	// GetPCSkill function above will return a 0.
	iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
    if (!iChance)
    {
        // PC does not have enough skill points, well, let them know.
		if (iInfoActive)
			LEG_COMMON_DisplayInfoBox(oPC, "YOU LACK THE SKILLS TO CRAFT THIS");
		else
	        FloatingTextStringOnCreature("YOU LACK THE SKILLS TO CRAFT THIS", oPC, FALSE);
        return;	
	}

	// Get the recipe ingredients and ensure PC has them all.
	string sIng1 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1", iRecipeIndex);
	string sIng1Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1Qty", iRecipeIndex);
	string sIng2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2", iRecipeIndex);
	string sIng2Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2Qty", iRecipeIndex);
	string sIng3 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3", iRecipeIndex);
	string sIng3Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3Qty", iRecipeIndex);
	string sIng4 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4", iRecipeIndex);
	string sIng4Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4Qty", iRecipeIndex);
	string sIng5 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5", iRecipeIndex);
	string sIng5Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5Qty", iRecipeIndex);	
	string sIng6 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6", iRecipeIndex);
	string sIng6Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6Qty", iRecipeIndex);	
	string sIng7 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7", iRecipeIndex);
	string sIng7Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7Qty", iRecipeIndex);	
	string sIng8 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8", iRecipeIndex);
	string sIng8Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8Qty", iRecipeIndex);	

	// Get the Spell Ingredient. 
	string sSpellID = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng", iRecipeIndex);	
	string sSpellID2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng2", iRecipeIndex);		
	string sSpellGate = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellGate", iRecipeIndex);		

	// Get the gold ingredient
	string sGold = LEG_COMMON_GetArrayElement(oModule, "arRecipeGold", iRecipeIndex);	

	// Here we are performing a check to see if we have all the required ingredients.  If
	// we do, then we can move on, otherwise, we exit.
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng1, sIng1Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng2, sIng2Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng3, sIng3Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng4, sIng4Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng5, sIng5Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng6, sIng6Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng7, sIng7Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng8, sIng8Qty))
		return;
		
	// Check to see if the PC has the required spell(s)
	if (sSpellGate != "")
	{
		if (!LEG_CRAFT_CheckSpellIngredient(oPC, sSpellID, sSpellID2, sSpellGate))
			return;
	}
	else
	{
		if (!LEG_CRAFT_CheckSpellIngredient(oPC, sSpellID))
			return;
	}
		
	// Check to see if the PC has the required gold.
	if (sGold != "")
	{
		if (GetGold(oPC) < StringToInt(sGold))
		{
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE THE REQUIRED GOLD");
			else
				FloatingTextStringOnCreature("YOU DON'T HAVE THE REQUIRED GOLD", oPC, FALSE);
			return;		
		}
	}

	// Next we see if the optional Tool is required
    // Gets the weapon in the right hand slot of the player.  We only do this
	// if the INFO plugin is not active, because if it is, the progbar script will
	// handle this check.
    string sTool = GetLocalString(oStation, "LEG_CRAFT_Skill_Tool");
	if (sTool != "" && !iInfoActive)
	{
	    object oWeaponOnPlayer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	    if (GetTag(oWeaponOnPlayer) != sTool)
	    {
			if (iInfoActive)
				LEG_COMMON_DisplayInfoBox(oPC, "YOU MUST EQUIP THE PROPER TOOL FIRST");
			else
		        FloatingTextStringOnCreature("YOU MUST EQUIP THE PROPER TOOL", oPC, FALSE);
		}
	}
	
	// Set the Craft All variables if this is a Craft All button press.	
	if (iCraftAll)
	{
	 	SetLocalInt(oStation, "LEG_INFO_CanCancel", TRUE);
		SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", TRUE);
		SetLocalInt(oPC, "LEG_INFO_PROGBARCANCEL", FALSE);
	}
	else
	{
	 	SetLocalInt(oStation, "LEG_INFO_CanCancel", FALSE);
	}	
	
	// End 1.8 Additions
	
	if (iInfoActive)
	{
		// Call the Progbar.  This will require variables on the Station for it, and will need
		// some testing.
		ExecuteScript("leg_info_progbar", oStation);
	}
	else
	{
		// No Progbar, we're going old school!
		// When we go Old School, the only other variable we want on the Station is the animation
		// method we should use or spell effect if there is an ingredient for it.
		string sSpellID = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeSpellIng", iRecipeIndex);	
		if (sSpellID == "#OUTOFBOUNDS#" || sSpellID == "#EOA#" || sSpellID == "")
		{
			string sMethod = GetLocalString(oStation, "LEG_CRAFT_Method");
	        if (sMethod == "Bash")
	            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SHOVELING, 1.0, 5.0));
	        else if (sMethod == "Bend")
	            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
		}
		else
		{
	            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 5.0));
		}
			
		// Now let's call the go script.
        DelayCommand(0.5, ExecuteScript("leg_craft_gocraft", oStation));
	}
}