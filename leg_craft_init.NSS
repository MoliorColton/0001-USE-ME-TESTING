/*

    Script:			This is the main initialization script for crafting.  It is called by the MASTER on
					client enter script when the plugin is active.  Essentially it is run only once
					on server reset and takes all the values it needs from the database and stores them
					into arrays in memory for performance reasons.  The recipe database is a large read-only
					database when the server is running so there is no need to keep checking the 
					database during uptime.
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
	// When you initialize the skills, you are reading from the database and putting them
	// into local arrays.  They will perform better than reading from database this way.
	// This section is for initializing the system.
	int iIndex = 0;
	object oModule = GetModule();

	// Get the Skill configuration from the table and store it in a local array.	
	string sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_skills`";
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{
		LEG_COMMON_AddArrayElement(oModule, "arSkillIDs", SQLGetData(1));
		LEG_COMMON_AddArrayElement(oModule, "arSkillName", SQLGetData(2));
		LEG_COMMON_AddArrayElement(oModule, "arSkillMap", SQLGetData(3));
		LEG_COMMON_AddArrayElement(oModule, "arSkillAbility", SQLGetData(4));
	}

	// Get all the class bonuses and store them in an array.
	sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_classbonuses`";
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{
		LEG_COMMON_AddArrayElement(oModule, "arSkillClassBonusIDs", SQLGetData(1));
		LEG_COMMON_AddArrayElement(oModule, "arSkillClassBonus", SQLGetData(2));
		LEG_COMMON_AddArrayElement(oModule, "arSkillClassBonusValue", SQLGetData(3));
	}

	// Get all the race bonuses and store them in an array.
	sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_racebonuses`";
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{
		LEG_COMMON_AddArrayElement(oModule, "arSkillRaceBonusIDs", SQLGetData(1));
		LEG_COMMON_AddArrayElement(oModule, "arSkillRaceBonus", SQLGetData(2));
		LEG_COMMON_AddArrayElement(oModule, "arSkillRaceBonusValue", SQLGetData(3));
	}

	// Get all the feat bonuses and store them in an array.
	sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_featbonuses`";
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{
		LEG_COMMON_AddArrayElement(oModule, "arSkillFeatBonusIDs", SQLGetData(1));
		LEG_COMMON_AddArrayElement(oModule, "arSkillFeatBonus", SQLGetData(2));
		LEG_COMMON_AddArrayElement(oModule, "arSkillFeatBonusValue", SQLGetData(3));
	}
	
	// Get all the recipes and store them in an array including ingredients and everything else
	// that goes along with a recipe.
	sSQL = "SELECT * FROM `" + CRAFTTABLEPREFIX + "_recipes` ORDER BY CAST(`RecipeID` AS DECIMAL(5))";
	SQLExecDirect(sSQL);
	string sName;
	while(SQLFetch())
	{
		sName = SQLGetData(2);
		LEG_COMMON_AddArrayElement(oModule, "arRecipeID", SQLGetData(1));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeName", sName);
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSkill", SQLGetData(3));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeMin", SQLGetData(4));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeMax", SQLGetData(5));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng1Name", SQLGetData(6));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng1", SQLGetData(7));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng1Qty", SQLGetData(8));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng2Name", SQLGetData(9));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng2", SQLGetData(10));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng2Qty", SQLGetData(11));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng3Name", SQLGetData(12));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng3", SQLGetData(13));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng3Qty", SQLGetData(14));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng4Name", SQLGetData(15));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng4", SQLGetData(16));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng4Qty", SQLGetData(17));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng5Name", SQLGetData(18));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng5", SQLGetData(19));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng5Qty", SQLGetData(20));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng6Name", SQLGetData(21));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng6", SQLGetData(22));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng6Qty", SQLGetData(23));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng7Name", SQLGetData(24));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng7", SQLGetData(25));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng7Qty", SQLGetData(26));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng8Name", SQLGetData(27));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng8", SQLGetData(28));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIng8Qty", SQLGetData(29));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeMinQty", SQLGetData(30));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeMaxQty", SQLGetData(31));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeRef", SQLGetData(32));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeIcon", SQLGetData(33));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeFailMin", SQLGetData(34));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeFailMax", SQLGetData(35));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeFailItem", SQLGetData(36));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeFailChance", SQLGetData(37));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeExcepMin", SQLGetData(38));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeExcepMax", SQLGetData(39));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeExcepItem", SQLGetData(40));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeExcepChance", SQLGetData(41));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeExcepBonus", SQLGetData(42));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeCost", SQLGetData(43));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeGold", SQLGetData(44));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSpellIng", SQLGetData(45));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSpellName", SQLGetData(46));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSpellIng2", SQLGetData(47));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSpellName2", SQLGetData(48));
		LEG_COMMON_AddArrayElement(oModule, "arRecipeSpellGate", SQLGetData(49));		
	}
}