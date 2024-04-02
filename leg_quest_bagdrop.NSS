/*

    Script:			On Left Click script for interactive placeables for quests. This is a special bootstrap
					script specifically for dropped loot bags because of their temporary nature.  When a loot
					bag drops on death of a creature, this script becomes it's OnLeftClick script.  This script
					created an iPoint that runs the leg_quest_placeables script.  Because the loot bag will
					vanish in 2 minutes, sometimes a player will click it and the script will hang them up
					in a progress bar and stop running.  Because we "run" the script on the ipoint, the loot bag
					can go ahead and disappear.  The iPoint will vanish after 3 minutes rather than 2.
	Version:		1.0
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		09/07/2015 - 1.00 MV - Initial Release
					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN INCLUDE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oPC = GetPlaceableLastClickedBy();
	string sName = GetName(OBJECT_SELF);
	
	// Check for and create the iPoint
	location lLoc = GetLocation(OBJECT_SELF);
	string sID = SQLLocationToString(lLoc);
	string sTag = sID + "lootmanager";
	object oLootManager = GetNearestObjectByTag(sTag);

	if (!GetIsObjectValid(oLootManager))
	{
		// Create a Loot Manager
		int iDeSpawnMins = GetLocalInt(OBJECT_SELF, "LEG_BodyBag_Mins");
		if (!iDeSpawnMins)
			iDeSpawnMins = 2;		
		oLootManager = CreateObject(OBJECT_TYPE_PLACEABLE, "leg_quest_lootmanager", lLoc, FALSE, sTag);
		DestroyObject(oLootManager, 60.0 * IntToFloat(iDeSpawnMins + 1), FALSE);
		
		// Copy variables over toit.
		if(GetIsObjectValid(oLootManager))
		{
			int iTotalQuests = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests");
			int iCount;
			string sQuestCounter;
			SetLocalInt(oLootManager, "LEG_QUEST_TotalQuests", iTotalQuests);
			SetLocalObject(oLootManager, "LEG_KillWinner", oPC);
			SetLocalInt(oLootManager, "LEG_QUEST_UseTime", GetLocalInt(OBJECT_SELF, "LEG_QUEST_UseTime"));
			SetLocalInt(oLootManager, "MOBDeath", TRUE);

			// First thing we do is cycle through the MOB's quests.	
			for (iCount = 1; iCount <= iTotalQuests; iCount++)
			{
				// Get who we are.
				sQuestCounter = IntToString(iCount);
				if (GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + sQuestCounter) != "")
				{
					string sQuestID = GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter);
					int iObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_IsObjective_" + sQuestCounter);
					int iNPCObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);
			
					SetLocalString(oLootManager, "LEG_QUEST_QuestID_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_IsObjective_" + sQuestCounter, iObjective);
					SetLocalInt(oLootManager, "LEG_QUEST_ObjectiveFor_" + sQuestCounter, iNPCObjective);		
					SetLocalString(oLootManager, "LEG_QUEST_Item_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_Item_" + sQuestCounter));
					SetLocalString(oLootManager, "LEG_QUEST_FakePlaceable_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_FakePlaceable_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_MinQty_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_MinQty_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_MaxQty_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_MaxQty_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_Chance_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_Chance_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_PCNeeds_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_PCNeeds_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_NPCAdvance_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCAdvance_" + sQuestCounter));
					SetLocalInt(oLootManager, "LEG_QUEST_Finisher_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_Finisher_" + sQuestCounter));
					SetLocalString(oLootManager, "LEG_QUEST_Action_" + sQuestCounter, "Searching");
				}
			}			
		}		
	}
	
	
	// Run placeables script on it.
	AddScriptParameterObject(oPC);
	ExecuteScriptEnhanced("leg_quest_placeables", oLootManager);
}