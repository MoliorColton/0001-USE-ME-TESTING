/*

    Script:			A basic conversation "Check" script to see if the PC is at Legendary skill
					level.  Useful in training conversations to ensure the PC isn't already at the
					maximum value and if they are, speak accordingly.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/26/2011 - 1.00 MV - Initial Release
	
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

	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
	
	// Get PC's current skill
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	if (iPCSkill == 0)
	{
		string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}	
	
	// If the PC has more than 294 skill points, then they are at Legendary level.
	if (iPCSkill >= 294)
		return TRUE;
	else
		return FALSE;
}