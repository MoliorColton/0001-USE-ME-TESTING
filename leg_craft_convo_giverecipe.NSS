/*

    Script:			Used in the Action node of a conversation to give a PC a recipe ID passed.  The skill and
					recipe ID are both required for this script.  Note that this script does not check
					to see if the PC is allowed to learn it or not.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iRecipeID, int iSkill)
{
	// First we have to see if the PC already knows it.
	object oPC = GetPCSpeaker();
	string sTableID = LEG_COMMON_GetPCTable(oPC, "knownrecipes");
	
	string SQL = "SELECT COUNT(*) FROM " + sTableID + " WHERE `RecipeID` = '" + IntToString(iRecipeID) + "';";

	SQLExecDirect(SQL);
	SQLFetch();
	if (SQLGetData(1) == "0")
	{
		// The PC does not have this recipe so we add it.
		SQL = "INSERT INTO " + sTableID + " (`RecipeID`, `SkillID`) VALUES ('" + IntToString(iRecipeID) + "', '" + IntToString(iSkill) + "');";
		SQLExecDirect(SQL);
	}
}