/*

    Script:			This script initializes a players database table should they not have one ready.  
					It is called from the leg_all_masterenter script placed in each area's On Client
					Enter event.
	Version:		1.3
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		12/20/2010 - 1.00 MV - Initial Release
					10/09/2011 - 1.01 MV - Fixed bug with table name
					10/06/2012 - 1.1 MV - Fixed bug where sometimes DB tables would not be created.					
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database
					08/11/2015 - 1.3 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Get our PC and see if they need a table created for Info Triggers
	object oPC = OBJECT_SELF;
	string sOldTableID = LEG_COMMON_GetPCTable(oPC, "infoboxes");
	string sOldTableIDNoQuotes = LEG_COMMON_GetPCTable(oPC, "infoboxes", TRUE);
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	SQLExecDirect("CREATE TABLE IF NOT EXISTS `" + DBNAME + "`." + sTableID + " (`player` varchar( 64 ) NOT NULL default '~',`tag` varchar( 64 ) NOT NULL default '~',`name` varchar( 64 ) NOT NULL default '~',`val` text,`expire` int( 11 ) default NULL ,`last` timestamp NOT NULL default CURRENT_TIMESTAMP ,`questtype` tinyint(4) NOT NULL default '0' ,PRIMARY KEY ( `player` , `tag` , `name` ) ) ENGINE = MYISAM DEFAULT CHARSET = latin1;");

	// v2.0 Check for v1.0 table and migrate data
	// Check "infoboxes" tables
	SQLExecDirect("SELECT COUNT(*) FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = '" + DBNAME + "' AND `TABLE_NAME` = '" + sOldTableIDNoQuotes + "';");
	SQLFetch();
	int iExists = StringToInt(SQLGetData(1));
	if (iExists)
	{
		SQLExecDirect("INSERT INTO " + sTableID + " (`player`,`tag`,`name`,`val`,`expire`,`last`) SELECT `player`,`tag`, CONCAT('Info_',`name`), `val`, `expire`, `last` FROM `" + DBNAME + "`." + sOldTableID + ";");
		SQLExecDirect("DROP TABLE" + sOldTableID + ";");
	}		
}