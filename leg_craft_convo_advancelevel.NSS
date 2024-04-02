/*

    Script:			This script will check if the PC has reached the requirements to learn the next
					level of skill difficulty.  To advance in level, the PC has to have reach their skill cap.
					The CAP is the maximum skill value in a difficulty.  For example, difficulty 1 the skill range
					is 1-20.  The PC must have skill of 20 before they can advance.  Note that items that have
					a maximum skill of above 20, can skill be crafted if their minimum is below 20.  Note that this
					script does not do any checking to ensure the PC actually CAN advance.  This script is intended
					to be used in a coversation file in which other "CHECK" scripts would have been called prior to
					this one to check for such things.
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
	
	if (!GetIsObjectValid(oPC))
		oPC = GetLastUsedBy();
		
	// What skill are we giving a point to?
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
	
	// What level are we training?  When the PC reaches the max in a level, they train
	// at these trainers to learn the next level.  Use the table below for valid values:
	// 20 = Novice
	// 45 = Apprentice
	// 76 = Journeyman
	// 110 = Veteran
	// 139 = Expert
	// 169 = Adept
	// 204 = Master
	// 245 = Grand Master
	// 294 = Legendary
	int iLevel = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Level");
	
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
				
	// Give 1 point to the PC.
	iPCSkill++;
	
	// Save the PC's skill
    SetPersistentInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill, 0, sTableID); // This is a persistent.
    SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
}