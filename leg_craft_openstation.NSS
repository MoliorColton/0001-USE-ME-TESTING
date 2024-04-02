/*

    Script:			Placed in the OnUsed event of a crafting station, this script will check the PC
					has skill and will open up the GUI for crafting items via this station.  It will
					see what recipes the PC knows and populate everything appropriately.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					01/25/2014 - 1.1 MV - Fixed bug caused by colored user names
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
	
	// Get the skill ID this station uses
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");	

	// Does the PC have any skill in this?
	if (!LEG_CRAFT_GetPCSkill(oPC, iSkill))
	{
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(oPC, "YOU LACK THE SKILL TO USE THIS");
		else
	        FloatingTextStringOnCreature("!! YOU LACK THE SKILL TO USE THIS !!", oPC, FALSE);
		return;
	}

	// Is the PC in the middle of crafting already?
	if (GetLocalInt(oPC, "SkillInUse"))
		return;
			
	// Store the Crafting Station with the PC.
	SetLocalObject(oPC, "CNPC", OBJECT_SELF);

	// Get the name of the Skill
	string sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_skills` WHERE `SkillID` = '" + IntToString(iSkill) + "';";
	SQLExecDirect(sSQL);
	SQLFetch();
	string sSkillName = SQLGetData(2);
	
	// Display GUI in all its broken glory.
	DisplayGuiScreen(oPC, "crafting", FALSE, "craftstation.xml");
	SetGUIObjectText(oPC, "crafting", "MAINTITLE", -1, "CRAFTING");
	SetGUIObjectText(oPC, "crafting", "counttitle", -1, "Known " + sSkillName + " Recipes");
	
	// Next, we lookup the PC's table of known recipes for this skill and populate the GUI with them.
	string sTable = LEG_COMMON_GetPCTable(oPC, "knownrecipes");
	sSQL = "SELECT * FROM " + sTable + " WHERE `SkillID` = '" + IntToString(iSkill) + "' ORDER BY `RecipeID`;";
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{

		// Grab the first element of the Names Array.
		int iCounter = 0;
		string sID = SQLGetData(1);
		int iID = StringToInt(sID);
		string sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iID);
		string sIcon = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeIcon", iID);
	
		// Add the known recipe to the GUI.	
		iCounter++;
		AddListBoxRow(oPC, "crafting", "RECIPE_LISTBOX", "ROW_" + IntToString(iCounter), "LISTBOX_ITEM_TEXT=" + sRecipeName, "LISTBOX_ITEM_ICON=" + sIcon, "1=" + sID, "");
	}	
}