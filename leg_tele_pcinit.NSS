/*

    Script:			The Initialization script for the TELE system for each individual
					player.  Pretty much just initializes their DB table.
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper

	Change Log:		1.0 - 10/08/2012 MV - Initial Version
					08/17/2013 - 1.1 MV - Fixed bug that caused players with colors or dashes in names to fail database
					08/11/2015 - 1.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
					
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// If the PC is brand new, we create an instance table for them.  We also go through their skill set and load them up
	// as local variables for performance.
	object oPC = OBJECT_SELF;
	string sOldTableID = LEG_COMMON_GetPCTable(oPC, "instances");
	string sOldTableIDNoQuotes = LEG_COMMON_GetPCTable(oPC, "instances", TRUE);
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	SQLExecDirect("CREATE TABLE IF NOT EXISTS `" + DBNAME + "`." + sTableID + " (`player` varchar( 64 ) NOT NULL default '~',`tag` varchar( 64 ) NOT NULL default '~',`name` varchar( 64 ) NOT NULL default '~',`val` text,`expire` int( 11 ) default NULL ,`last` timestamp NOT NULL default CURRENT_TIMESTAMP ,`questtype` tinyint(4) NOT NULL default '0' ,PRIMARY KEY ( `player` , `tag` , `name` ) ) ENGINE = MYISAM DEFAULT CHARSET = latin1;");

	// v2.0 Check for v1.0 table and migrate data
	// Check "instances" tables
	SQLExecDirect("SELECT COUNT(*) FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = '" + DBNAME + "' AND `TABLE_NAME` = '" + sOldTableIDNoQuotes + "';");
	SQLFetch();
	int iExists = StringToInt(SQLGetData(1));
	if (iExists)
	{
		SQLExecDirect("INSERT INTO " + sTableID + " SELECT * FROM `" + DBNAME + "`." + sOldTableID + ";");
		SQLExecDirect("DROP TABLE" + sOldTableID + ";");
	}
	
}