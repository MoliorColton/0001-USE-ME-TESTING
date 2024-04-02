/*

    Script:			This script was needed for cross server travel to have quests span across multiple mods
					In a normal PW, the builder will have to call this script when the player enters the
					next module.  This became an issue when a player got a quest in mod 1, finished objectives
					in mod 2 then returned to mod 1 to turn the quest in without any server resets.  Calling
					this when entering the new mod solves this issue.  
	Version:		1.4
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		10/11/2012 - 1.0 MV - Initial Release
					11/22/2012 - 1.1 MV - Added support for new Objective Rules
					03/10/2013 - 1.2 MV - Fixed bug where server crosses were not re-initalizing OBJ Rules correctly
					08/17/2013 - 1.3 MV - Fixed bug that caused players with colors or dashes in names to fail database
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
	// First thing we do is grab all the quests in our table.
	object oPC = OBJECT_SELF;
	
	// Because of the 2.0 consolidation effort, rather than go back looking for all the SQL GetTables
	// we just set oPC to OBJECT_SELF and forget about it.
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));	
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
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
	while (iCounter <= iActiveQuests)
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
		LEG_QUEST_ClearOBJRuleSet(oPC, sQuestID, iNPC);
		
		// Initialize any Objective Rules for quests the PC has already started.
		string sNPC = IntToString(iNPC);
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
	
	
}