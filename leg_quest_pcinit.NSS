/*

    Script:			Initializes players after each server reset.  Sets up their Quest Vars and feats from Lore Books
	Version:		1.6
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/01/2012 - 1.1 MV - Update to verify inventory counts
					10/06/2012 - 1.2 MV - Fixed bug where sometimes DB tables would not be created.
					11/22/2012 - 1.3 MV - Added support for new Objective Rules
					08/17/2013 - 1.4 MV - Fixed bug that caused players with colors or dashes in names to fail database
					12/22/2013 - 1.5 MV - Fixed bug with missing ` in create table SQL
					08/11/2015 - 1.6 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// The VERY VERY first thing we need to do is find out if this PC has ever been here before.  If they haven't
	// they'll need their quest tables set up.
	// Ever been here before Mr PC?
	object oPC = OBJECT_SELF;
	string sTableID;
		
	// Create a table for this players quests.  Each player has their own table
	// for performance - 1000 quests leads to 5000 entries.  Times that by each
	// character and you quickly have a table in the hundreds of thousands.  Great for
	// high end, high performance database, but we don't have that and we don't mind
	// having a table for each player - would only be a couple hundred.  Suck it up princess!
	// At least their organized.
	string sOldTableID = LEG_COMMON_GetPCTable(oPC, "quests");
	string sOldTableIDNoQuotes = LEG_COMMON_GetPCTable(oPC, "quests", TRUE);
	sTableID = LEG_COMMON_GetPC2Table(oPC);
	SQLExecDirect("CREATE TABLE IF NOT EXISTS `" + DBNAME + "`." + sTableID + " (`player` varchar( 64 ) NOT NULL default '~',`tag` varchar( 64 ) NOT NULL default '~',`name` varchar( 64 ) NOT NULL default '~',`val` text,`expire` int( 11 ) default NULL ,`last` timestamp NOT NULL default CURRENT_TIMESTAMP ,`questtype` tinyint(4) NOT NULL default '0' ,PRIMARY KEY ( `player` , `tag` , `name` ) ) ENGINE = MYISAM DEFAULT CHARSET = latin1;");

	// v2.0 Check for v1.0 table and migrate data
	// Check "quests" tables
	SQLExecDirect("SELECT COUNT(*) FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = '" + DBNAME + "' AND `TABLE_NAME` = '" + sOldTableIDNoQuotes + "';");
	SQLFetch();
	int iExists = StringToInt(SQLGetData(1));
	if (iExists)
	{
		SQLExecDirect("INSERT INTO " + sTableID + " (`player`,`tag`,`name`,`val`,`expire`,`last`,`questtype`) SELECT `player`,`tag`, `name`, `val`, `expire`, `last`, `questtype` FROM `" + DBNAME + "`." + sOldTableID + ";");
		SQLExecDirect("DROP TABLE" + sOldTableID + ";");
	}
		
	
	sOldTableID = LEG_COMMON_GetPCTable(oPC, "placeables");
	sOldTableIDNoQuotes = LEG_COMMON_GetPCTable(oPC, "placeables", TRUE);
	
	// v2.0 Check for v1.0 table and migrate data
	// Check "placeables" tables
	SQLExecDirect("SELECT COUNT(*) FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = '" + DBNAME + "' AND `TABLE_NAME` = '" + sOldTableIDNoQuotes + "';");
	SQLFetch();
	iExists = StringToInt(SQLGetData(1));
	if (iExists)
	{
		SQLExecDirect("INSERT INTO " + sTableID + " (`player`,`tag`,`name`,`val`,`expire`,`last`,`questtype`) SELECT `player`,`tag`,`name`,`val`,`expire`,`last`,0 FROM `" + DBNAME + "`." + sOldTableID + ";");
		SQLExecDirect("DROP TABLE" + sOldTableID + ";");
	}
	
	// If the quest journal system is setup to use the item...
	LEG_COMMON_DestroyItems(oPC, "leg_quest_journal", -1);
	if (!JOURNAL_OVERRIDE)
	{
		// Give the PC the journal tool.
		CreateItemOnObject("leg_quest_journal", oPC, 1);	
	}
		
	// First thing we do is grab all the quests in our table.
	sTableID = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));	
	string sQuestID, sQuestIDFull;
	int iNPCPos, iActiveQuests, iCounter;
	
	// Fire off the SQL for this.
	SQLExecDirect("SELECT * FROM " + sTableID + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%NPC%'");
	while(SQLFetch())
	{
		// Grab the QuestID and the NPC step we are on.
		sQuestIDFull = SQLGetData(3);
		iNPCPos = StringToInt(SQLGetData(4));
		
		// Parse out the string from the table to get the 4 digit Quest ID.
		sQuestID = GetStringRight(GetStringLeft(sQuestIDFull, 12), 4);
		
		// Save this position on the PC.
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC", iNPCPos);
		
		// If the quest is not finished then we increment our quest counter.
		if (iNPCPos != 999 && iNPCPos != 998)
		{
			iActiveQuests++;
			SetLocalString(oPC, "QuestCounter_" + IntToString(iActiveQuests), sQuestID);
		}
	}
	
	// Now go through our active quests and setup local variables for each objective we are on.
	while (iCounter < iActiveQuests)
	{
		iCounter++;
		sQuestID = GetLocalString(oPC, "QuestCounter_" + IntToString(iCounter));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_NPC", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_Type", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_Type", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ1", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ1", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ2", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ2", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ3", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ3", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ4", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ4", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ5", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ5", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ6", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ6", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ7", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ7", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ8", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ8", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ9", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ9", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ10", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ10", sTableID));
				
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_1_ReluctantPassed", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_1_ReluctantPassed", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_2_ReluctantPassed", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_2_ReluctantPassed", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_3_ReluctantPassed", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_3_ReluctantPassed", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_4_ReluctantPassed", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_4_ReluctantPassed", sTableID));
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_5_ReluctantPassed", GetPersistentInt(oPC, "QuestID_" + sQuestID + "_5_ReluctantPassed", sTableID));		
		
		// Setup and follow Objective Rules
		int iNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
		string sNPC = IntToString(iNPC);

		// Initialize any Objective Rules for quests the PC has already started.
		LEG_QUEST_InitializeOBJRule(oPC, sQuestID, sNPC, -1);
		
		// Apply any Rules.
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 1, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 2, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 3, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 4, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 5, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 6, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 7, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 8, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 9, 0, TRUE);
		LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPC, 10, 0, TRUE);
	}

	// If a player logs out during a timer quest after the fail script has fired, they need to have those objectives deactivated.  Because this script
	// fires AFTER the client enter (for the module) fires, we need to do that here instead of there.  
	// If the naughty player has already had their timer bar expire and the fail script run, but decided to just thow in the towel,
	// that's all fine EXCEPT in the event of a server reset.  If a server reset occurs before they finish then the quest objectives
	// for the NPC they were on will re-activate.  We deactivate them on a fail so the player can't just keep doing them.  BUT it
	// is not persistent.  So, we deactivate them again here if required.  If it was an objective that started the timer we don't de-activate objectives
	// because they are already set the way they should be by the fail script.
	SQLExecDirect("SELECT * FROM " + sTableID + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%MOBOBJTIMERFAIL%'");
	SQLFetch();
	string sTimerID = SQLGetData(3);
	if (sTimerID != "")
	{
		// We failed our timer (the fail script already ran) but it was an objective given timer, not an NPC.  So let's just warn.
		LEG_COMMON_DisplayInfoBox(oPC, "NOTICE: The last time you logged out, you were perfoming a quest that had a timer.  The timer expired before you completed your task.  In order to complete the objectives for that quest, you will need to re-do the objective that gave you the timer to restart it.", 1, 0, 2);
	}	
	else
	{
		// There was no timer failure for an objective, but there still could have been one for an NPC
		SQLExecDirect("SELECT * FROM " + sTableID + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%MOBTIMERFAIL%'");
		SQLFetch();
		sTimerID = SQLGetData(3);
		if (sTimerID != "")
		{
			string sQuestID = GetStringRight(GetStringLeft(sTimerID, 12), 4);
			int iNPC = StringToInt(GetStringRight(sTimerID, 1));
	
			string sNPC = IntToString(iNPC);
			LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJID");
			LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJInactive");
		
			int iCount;	
			for (iCount=1; iCount <= 10; iCount++)
			{
				LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJID", IntToString(iCount));
				LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJInactive", "1");
			}
			
			LEG_COMMON_DisplayInfoBox(oPC, "NOTICE: The last time you logged out, you were perfoming a quest that had a timer.  The timer expired before you completed your task.  In order to complete the objectives for that quest, you will need to talk to the NPC again to restart the timer.", 1, 0, 2);
		}
	}
		
	// Apply feats that we typically don't have after a server reset.
	ExecuteScript("leg_quest_applyfeats", oPC);
}