/*

    Script:			For extra value in a conversation file, this "Check" will examine all the levels the
					NPC will teach.  If the PC has enough skill level that is higher than all the levels
					the NPC can teach, then the script returns TRUE.  This means that the NPC can tell the PC
					that they must seek out a higher level trainer.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		08/26/2011 - 1.00 MV - Initial Release
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
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
		string sTable = LEG_COMMON_GetPC2Table(oPC);
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}	

	// Get the 9 variables of skill
	int iLevel2 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel2");
	int iLevel3 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel3");
	int iLevel4 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel4");
	int iLevel5 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel5");
	int iLevel6 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel6");
	int iLevel7 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel7");
	int iLevel8 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel8");
	int iLevel9 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel9");
	int iLevel10 = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainerLevel10");
	
	// Check the PC's skill level against each training level this NPC knows.  If the PC 
	// level is higher than the values in each of these variables, then this NPC can no
	// longer teach this player anything. 
	if (iPCSkill > 	iLevel2 && iPCSkill > iLevel3 && iPCSkill > iLevel4 && iPCSkill > iLevel5 && iPCSkill > iLevel6 && iPCSkill > iLevel7 && iPCSkill > iLevel8 && iPCSkill > iLevel9)
		return TRUE;
	else
		return FALSE;
		

}