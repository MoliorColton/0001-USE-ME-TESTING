/*

    Script:			In the Crafting Plugin configuration, we can set the TOTAL number of Skill Levels
					a PC is allowed to learn.  This script, used in a conversation, will check to see how
					many levels a PC has from all their tradeskills (the Harvest skill count flag is accounted
					for).  If the PC has the Maximum skill levels, the script will return TRUE, otherwise
					the script returns FALSE signifying the PC can continue to learn more levels.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/24/2011 - 1.00 MV - Initial Release
					10/06/2012 - 1.1 MV - Fixed bug where Harvest Skills SQL statement was completely wrong
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database
	
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

	// Count the skills the PC has.
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	string sSQLMax;
	if (HARVESTSKILLCOUNT)
		sSQLMax = "SELECT * FROM " + sTableID + ";";
	else
		sSQLMax = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_skills` AS t2 INNER JOIN " + sTableID + " AS t1 ON t2.SkillID = RIGHT(t1.name, LENGTH(t1.name) - 6) WHERE t2.HarvestSkill = '0';";

	
	// We can learn some more skills but are we at the MAX Levels?
	if (MAXSKILLLEVELS)
	{
			// We need to find out how many skill levels in TOTAL we have of all our skills.  So we need to look up
			// a list of skills we have (including the HARVEST flag on the SQL as well).  this SQL came from above
			// just cause the IF statement was already there LOL.
			int iTotalSkillLevels = 0;
			string sSkill;
			SQLExecDirect(sSQLMax);
			while (SQLFetch())
			{
				sSkill = SQLGetData(3);
				iSkill = StringToInt(GetStringRight(sSkill, GetStringLength(sSkill) - 6));
				iTotalSkillLevels = iTotalSkillLevels + LEG_CRAFT_GetSkillLevelByName(oPC, LEG_CRAFT_GetSkillLevelName(oPC, iSkill), iSkill);
			}
			
			// If the PC has more or equal to the MAXSKILLEVELS and if so, return TRUE.  We check "More" as well
			// in case the MAXSKILLEVELS is changed later on.
			if (iTotalSkillLevels >= MAXSKILLLEVELS)
				return TRUE;	
			else
				return FALSE;
	}
	return FALSE;
}