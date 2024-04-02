/*

    Script:			This script figures out what trainer skill this trainer performs and sets the custom 
					conversation token for it as well as a gold piece value (typically for training costs).
					This is an action node of the BasicTraining and Advance converstaion of the first line.
	Version:		1.01
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/26/2011 - 1.01 MV - Added support for variable gold values.
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Get the Name of this skill and price.
	string sSkill = GetLocalString(OBJECT_SELF, "LEG_CRAFT_SkillTrain");
	int iPrice = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainingPrice");
	
	// Set the Custom Token.
	SetCustomToken(3000, sSkill);		
	SetCustomToken(3001, IntToString(iPrice));		
}