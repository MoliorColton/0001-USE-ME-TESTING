/*

    Script:			Used in a conversation file as a "Check", this script accepts a value passed to it
					in the form of a Recipe ID number.  The database is checked for the PC to see if they
					already know the recipe or not.  If they do, the script returns TRUE. 
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/26/2011 - 1.00 MV - Initial Release
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
int StartingConditional(int iRecipeID)
{
	// Setup some variable values.
	string SQL;
	string sTableID = LEG_COMMON_GetPCTable(GetPCSpeaker(), "knownrecipes");
	
	// Ok, let's first see if the PC knows the recipe based on the Recipe ID passed into the script.
	SQL = "SELECT COUNT(*) FROM " + sTableID + " WHERE `RecipeID` = '" + IntToString(iRecipeID) + "';";
	SQLExecDirect(SQL);
	SQLFetch();
	if (SQLGetData(1) == "0")
		return FALSE;	
	else
		return TRUE;
}