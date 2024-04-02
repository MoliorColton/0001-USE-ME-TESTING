/*

    Script:			Used in the action node of a conversation, this script is usually placed on a
					Basic trainer to give the PC the configured Starting Points.  
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
void main()
{
	// Who are we acting on?
	object oPC = GetPCSpeaker();
	
	// What skill are we giving a point to?
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
	
	// Get PC's Table
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	
	// Get PC's current skill
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	if (iPCSkill == 0)
	{
		string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}	

		
	// If the PC is already skilled, then just exit.
	if (iPCSkill > 0)
		return;
	
	// Give 1 point to the PC.
	iPCSkill = SKILLSTARTPOINTS;
	
	// Save the PC's skill
    SetPersistentInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill, 0, sTableID); // This is a persistent.
    SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
}