/*

    Script:			As a player enters an area, we need to double check any Quest Based spawn encounters are labelled 
					active.  Sometimes, a server reset may deactivate a spawn encounter that was previously active 
					due to a Quest Acceptance.  We run this as players enter to re-enable these types of spawn encounters.
	Version:		1.4
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/11/2012 - 1.1 MV - Added support for cross server questing
					08/17/2013 - 1.2 MV - Fixed bug that caused players with colors or dashes in names to fail database
					01/04/2014 - 1.3 MV - Added code for quest refreshes on an entry server in a multi-server setup.
					08/11/2015 - 1.4 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
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
	// If the PC has entered an area with a special spawn, then check to see if its active.  If it is not,
	// then activate it.  This will persist across reboots etc.  Go through each WP in the area and see if the PC
	// needs it
	object oPC = OBJECT_SELF;
	object oSpawnPoint = GetFirstObjectInArea();
	while (GetIsObjectValid(oSpawnPoint))
	{
		if (GetObjectType(oSpawnPoint) == OBJECT_TYPE_WAYPOINT && GetLocalInt(oSpawnPoint, "LEG_SPAWN_QuestBased"))
		{
			string sWPTag = GetTag(oSpawnPoint);
			if(GetPersistentInt(oPC, sWPTag, QUESTPREFIX + "_questspawns"))
			{
				// Yep, PC needs this active so turn off the Trigger requirement.
				SetLocalInt(oSpawnPoint, "LEG_SPAWN_TriggerSpawn", 0);
				SetLocalInt(oPC, sWPTag, 1);
			}
		}
		
		// Move on to the next waypoint.
		oSpawnPoint = GetNextObjectInArea();
	}
	
	// If the PC that entered this area has quest objectives that had set flags then we need to read them and apply them.
	string sTableID = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(OBJECT_SELF));
	string sTableToon = SQLEncodeSpecialChars(GetName(OBJECT_SELF));	
	string sSQL = "SELECT * FROM " + sTableID + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE 'QuestID_%%%%_FLGAREA%'";
	string sFlagArea, sQuestIDFull, sQuestID;
	int iIndex, iFlag;
	SQLExecDirect(sSQL);
	while(SQLFetch())
	{
		// Grab the QuestID and the NPC step we are on.
		sQuestIDFull = SQLGetData(3);	
		
		// Parse out the string from the table to get the 4 digit Quest ID.
		sQuestID = GetStringRight(GetStringLeft(sQuestIDFull, 12), 4);
		
		// Get the area of the flags
		for (iIndex = 1; iIndex <= 10; iIndex++)
		{
			sFlagArea = GetPersistentString(oPC, "QuestID_" + sQuestID + "_FLGAREA" + IntToString(iIndex), sTableID);			
			if (sFlagArea == GetTag(GetArea(OBJECT_SELF)))
			{
				// We have a flag state set in the current area.  Let's reset it.	
				iFlag = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_FLG" + IntToString(iIndex), sTableID);
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlag);
			}
		}
	}
	
	// Call the crossover script if we have a special variable flag set for an area.  This is used on an entry module in a multi-server world.
	if (GetIsObjectValid(oPC) && GetIsPC(oPC) && GetLocalInt(oPC, "LEG_PLAYER_INIT") && GetLocalInt(GetArea(OBJECT_SELF), "LEG_QUEST_CROSS"))
	{
		ExecuteScript("leg_quest_crossserver", oPC);	
	}
}