/*

    Script:			Called by the Master On Item Activated script when the crafting plugin is active.
					This script checks an item variables to see if it is a recipe for a PC to learn.
					If so, it will let the PC learn the recipe assuming they have the tradeskill.
					The recipe will destroy after learning via this script so there we want to ensure
					the item is Unlimited Use so it can be kept should the PC already know the skill.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/22/2011 - 1.00 MV - Initial Release
					08/17/2013 - 1.1 MV - Fixed bug that caused players with colors or dashes in names to fail database
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oItem)
{
	// Find out if the item activated is a recipe item.
	int iRecipeID = GetLocalInt(oItem, "LEG_CRAFT_Recipe");
	if (iRecipeID > 0)
	{
		// Looks like this is a recipe so get the Skill.
		int iSkill = GetLocalInt(oItem, "LEG_CRAFT_Skill");

		// Find out if PC has the skill.
		string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
		if (!GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTableID))
		{
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "You are not skilled in this Trade.");
			else
				FloatingTextStringOnCreature("You are not skilled in this Trade.", OBJECT_SELF, FALSE);
			return;	
		}
				
		// Get the PC's table.
		sTableID = LEG_COMMON_GetPCTable(oPC, "knownrecipes");

		// Ok, let's first see if the PC knows the recipe
		string SQL = "SELECT COUNT(*) FROM " + sTableID + " WHERE `RecipeID` = '" + IntToString(iRecipeID) + "';";
		SQLExecDirect(SQL);
		SQLFetch();
		if (SQLGetData(1) == "0")
		{
			// Learn!
			SQL = "INSERT INTO " + sTableID + " (`RecipeID`, `SkillID`) VALUES ('" + IntToString(iRecipeID) + "', '" + IntToString(iSkill) + "');";
			SQLExecDirect(SQL);	
			
			// Send some info to the PC
			string sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iRecipeID);
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Learned to Craft " + sRecipeName);
			else
				FloatingTextStringOnCreature("Learned to Craft " + sRecipeName, OBJECT_SELF, FALSE);
			DestroyObject(oItem, 2.0);
			return;
		}
		else
		{
			// Send some info to the PC
			string sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iRecipeID);
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "You already know how to make " + sRecipeName);
			else
				FloatingTextStringOnCreature("You already know how to make " + sRecipeName, OBJECT_SELF, FALSE);
			return;
			
		}	
	}

}