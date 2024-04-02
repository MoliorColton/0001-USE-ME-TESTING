/*

    Script:			This script when used as a "Check" script in a conversation file, will ensure the PC
					has enough skill points to match the advancement of a level.  The NPC the PC is speaking
					with will have each level's advancement value requirement for each level they train.  If they
					do not train a specific level, their value for that level is 0.  If the PC should match any
					of the levels the NPC has configured, the script will return TRUE.
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
	int iLevel2 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel2");
	int iLevel3 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel3");
	int iLevel4 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel4");
	int iLevel5 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel5");
	int iLevel6 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel6");
	int iLevel7 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel7");
	int iLevel8 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel8");
	int iLevel9 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel9");
	int iLevel10 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel10");

	
	// Get PC's current skill
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	if (iPCSkill == 0)
	{
		string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}	
	
	// If the PC isn't trained at all
	if (iPCSkill == 0)
		return FALSE;
		
	// If the PC doesnt have a skill level that matches any of my training levels.
	if (iPCSkill != iLevel2 && iPCSkill != iLevel3 && iPCSkill != iLevel4 && iPCSkill != iLevel5 && iPCSkill != iLevel6 && iPCSkill != iLevel7 && iPCSkill != iLevel8 && iPCSkill != iLevel9 && iPCSkill != iLevel10)
		return FALSE;
	
	// Ok, the PC must have a match somewhere in one of my training levels.	
	return TRUE;
}