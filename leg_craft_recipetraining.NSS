/*

    Script:			Usually called by a Training Placeable object.  This script will fire up the recipe
					training GUI as long as the PC knows the skill.  It will check and see what recipes
					the placeable can train, and show the ones the PC does not already know.
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/17/2013 - 1.1 MV - Fixed bug that caused players with colors or dashes in names to fail database
					08/11/2015 - 1.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation	
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
	// Get the PC
	object oPC = GetLastUsedBy();
	if (!GetIsObjectValid(oPC))
		oPC = GetPCSpeaker();
	
	// Get the skill ID this station uses
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");	

	// Does the PC have any skill in this?
	int iPCSkill = LEG_CRAFT_GetPCSkill(oPC, iSkill);
	if (!iPCSkill)
	{
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(oPC, "YOU CANNOT LEARN THESE RECIPIES");
		else
	        FloatingTextStringOnCreature("!! YOU CANNOT LEARN THESE RECIPIES !!", oPC, FALSE);
		return;
	}

	// Store the Object or NPC with the PC.
	SetLocalObject(oPC, "CNPC", OBJECT_SELF);
	
	// Get the name of the Skill
	string sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_skills` WHERE `SkillID` = '" + IntToString(iSkill) + "';";
	SQLExecDirect(sSQL);
	SQLFetch();
	string sSkillName = SQLGetData(2);
	
	// Display GUI in all its broken glory.
	DisplayGuiScreen(oPC, "recipetraining", FALSE, "recipetraining.xml");
	SetGUIObjectText(oPC, "recipetraining", "MAINTITLE", -1, "RECIPES");
	SetGUIObjectText(oPC, "recipetraining", "counttitle", -1, "Available " + sSkillName + " Recipes to Train");
	
	// Next we create a loop of the available recipes this object can train.
	int iRecipeCount = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_RecipeCount");
	int iCounter = 0, iRecipeID, iMinSkill;
	string SQL, sRecipeName, sIcon;
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
		
	while (iCounter < iRecipeCount)
	{
		// Advance the Count
		iCounter++;
		
		// Let's get the first recipe
		iRecipeID = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Recipe" + IntToString(iCounter));
		
		// Ok, let's first see if the PC knows the recipe
		SQL = "SELECT COUNT(*) FROM " + sTableID + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` = 'Recipe_" + IntToString(iRecipeID) + "';";
		SQLExecDirect(SQL);
		SQLFetch();
		if (SQLGetData(1) == "0")
		{
			// The PC does not have this recipe so next we check and see if the PC has enough skill.
			iMinSkill = StringToInt(LEG_COMMON_GetArrayElement(GetModule(), "arRecipeMin", iRecipeID));
			sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iRecipeID);
			sIcon = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeIcon", iRecipeID);

			if (iPCSkill >= iMinSkill)
			{
				// PC has enough skill
				AddListBoxRow(oPC, "recipetraining", "RECIPE_LISTBOX", "ROW_" + IntToString(iCounter), "LISTBOX_ITEM_TEXT=" + sRecipeName, "LISTBOX_ITEM_ICON=" + sIcon, "1=" + IntToString(iRecipeID), "");
			}
			else
			{
				// PC does not have enough skill
				AddListBoxRow(oPC, "recipetraining", "RECIPE_LISTBOX", "ROW_" + IntToString(iCounter), "LISTBOX_ITEM_TEXT=<color=#C0C0C0>" + sRecipeName + "</color>", "LISTBOX_ITEM_ICON=" + sIcon, "1=" + IntToString(iRecipeID), "");
			}	
		}
	}
}