/*

    Script:			Used in a conversation file, this "Check" will see if the PC has a tradeskill based
					upon an NPC's "LEG_CRAFT_Skill" variable.  If the PC has the tradeskill, the script
					will return TRUE, otherwise, FALSE.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
int StartingConditional()
{
	// Get the PC
	object oPC = GetPCSpeaker();
	
	// Get the Skill in Question
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");	

	// Do a lookup to see if the PC has it.
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	if (GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTableID))
		return TRUE;
	else
		return FALSE;	

}