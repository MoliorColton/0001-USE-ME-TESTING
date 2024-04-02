/*

    Script:			In the Crafting Plugin configuration, we can set the TOTAL number of Skills
					a PC is allowed to learn.  This script, used in a conversation, will check to see how
					many levels a PC has from all their tradeskills (the Harvest skill count flag is accounted
					for).  If the PC has the Maximum skill levels, the script will return TRUE, otherwise
					the script returns FALSE signifying the PC can continue to learn more levels.  NOTE: This
					script is identical to the leg_craft_convo_checkmaxlevels script however it ALSO includes a
					check to see if the TOTAL NUMBER of skills allowed has been reached.  This is an additional
					configuration option to not only limit the number of total levels, but limit the number
					of total skills as well.
	Version:		1.3
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/24/2011 - 1.00 MV - Initial Release
					10/06/2012 - 1.1 MV - Fixed bug where Harvest Skills SQL statement was completely wrong	
					10/25/2012 - 1.2 MV - Fixed bug where if PC had max skills and tried to gain a harvest skill while
										  configured to not count them, player was denied.
					08/17/2013 - 1.3 MV - Fixed bug that caused players with colors or dashes in names to fail database
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
	
	// Count the skills the PC has.
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	string sSQL, sSQLMax;
	if (HARVESTSKILLCOUNT)
	{
		sSQL = "SELECT COUNT(*) FROM " + sTableID + ";";
		sSQLMax = "SELECT * FROM " + sTableID + ";";
	}
	else
	{
	
		// Is the skill we are about to get a Harvest Skill?
		int iSkillID = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
		sSQL = "SELECT `HarvestSkill` FROM `" + CRAFTTABLEPREFIX + "_skills` WHERE `SkillID` = '" + IntToString(iSkillID) + "';";
		SQLExecDirect(sSQL);
		SQLFetch();
		int iHarvestSkill = StringToInt(SQLGetData(1));
		if (iHarvestSkill)
		{
			return FALSE;
		}
		else
		{
			sSQL = "SELECT COUNT(*) FROM `" + CRAFTTABLEPREFIX + "_skills` AS t2 INNER JOIN " + sTableID + " AS t1 ON t2.SkillID = RIGHT(t1.name, LENGTH(t1.name) - 6) WHERE t2.HarvestSkill = '0';";
			sSQLMax = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_skills` AS t2 INNER JOIN " + sTableID + " AS t1 ON t2.SkillID = RIGHT(t1.name, LENGTH(t1.name) - 6) WHERE t2.HarvestSkill = '0';";
		}
	}
	SQLExecDirect(sSQL);
	SQLFetch();
	int iSkillCount = StringToInt(SQLGetData(1));
	int iSkill;
	
	// Compare and return the result.
	if (iSkillCount >= SKILLCOUNTPERPC)
		return TRUE;
	else
	{
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
			
			if (iTotalSkillLevels >= MAXSKILLLEVELS)
				return TRUE;	
			else
				return FALSE;
		}
		return FALSE;
	}
	return FALSE;	
}