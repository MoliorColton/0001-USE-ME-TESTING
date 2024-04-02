/*

    Script:			Called by the Master on client enter script of an area, checks to see if the PC
					entering has had their tables created for use with crafting.  If not, creates the PC
					specific tables for them.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/06/2012 - 1.1 MV - Fixed bug where sometimes DB tables would not be created.	
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database	
					01/25/2014 - 1.3 MV - Cleanup
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
	
	// If the PC is brand new, we create a crafting table for them.  We also go through their skill set and load them up
	// as local variables for performance.
	object oPC = OBJECT_SELF;
	
	// Create a table for this players skill levels.
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	SQLExecDirect("CREATE TABLE IF NOT EXISTS `" + DBNAME + "`." + sTableID + " (`player` varchar( 64 ) NOT NULL default '~',`tag` varchar( 64 ) NOT NULL default '~',`name` varchar( 64 ) NOT NULL default '~',`val` text,`expire` int( 11 ) default NULL ,`last` timestamp NOT NULL default CURRENT_TIMESTAMP ,`questtype` tinyint(4) NOT NULL default '0' ,PRIMARY KEY ( `player` , `tag` , `name` ) ) ENGINE = MYISAM DEFAULT CHARSET = latin1;");
		
	// Create a table for this players known recipes.
	sTableID = LEG_COMMON_GetPCTable(oPC, "knownrecipes");
	SQLExecDirect("CREATE TABLE IF NOT EXISTS `" + DBNAME + "`." + sTableID + " (`RecipeID` VARCHAR( 3 ) NOT NULL ,`SkillID` VARCHAR( 3 ) NOT NULL) ENGINE = MYISAM ;");
}