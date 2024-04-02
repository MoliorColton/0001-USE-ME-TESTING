//-----------------------------------------------------------------------
// <copyright file="gui_leg_craft_learnrecipe.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			Script that is fired when a PC hits the "Learn" button at a recipe learning GUI.  It
					checks to ensure the PC has enough money to learn, then adds the recipe to their
					known recipes table.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/17/2013 - 1.1 MV - Fixed bug that caused players with colors or dashes in names to fail database	
					01/25/2014 - 1.2 MV - Fixed secondary bug that caused players with colors or dashes in names to fail database	
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iRecipeID)
{
	// First let's make sure a recipe was selected.
	if (iRecipeID == 0)
	{
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Choose a Recipe");
		else
			FloatingTextStringOnCreature("Choose a Recipe", OBJECT_SELF, FALSE);
		return;
	}	
	
	// Find out if the PC has the caaaaaasssshhhhhh...
	int iRecipeCost = StringToInt(LEG_COMMON_GetArrayElement(GetModule(), "arRecipeCost", iRecipeID));	
	if (GetGold() < iRecipeCost)
	{
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Not Enough Gold");
		else
			FloatingTextStringOnCreature("Not Enough Gold", OBJECT_SELF, FALSE);
		return;
	}
	else
		TakeGoldFromCreature(iRecipeCost, OBJECT_SELF, TRUE);
	
	// If a recipe has been selected then let's go crafting!
	CloseGUIScreen(OBJECT_SELF, "recipetraining");

	// Get the crafting station.
	object oStation = GetLocalObject(OBJECT_SELF, "CNPC");	
	
	// Get the skill
	int iSkill = GetLocalInt(oStation, "LEG_CRAFT_Skill");
	
	// Learn!
	string sTableID = LEG_COMMON_GetPCTable(OBJECT_SELF, "knownrecipes");
	string SQL = "INSERT INTO " + sTableID + " (`RecipeID`, `SkillID`) VALUES ('" + IntToString(iRecipeID) + "', '" + IntToString(iSkill) + "');";
	SQLExecDirect(SQL);	
	
	// Send some info to the PC
	string sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iRecipeID);
	if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
		LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Learned to Craft " + sRecipeName);
	else
		FloatingTextStringOnCreature("Learned to Craft " + sRecipeName, OBJECT_SELF, FALSE);
	return;
}